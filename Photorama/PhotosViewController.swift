//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchInterestingPhotos { (photosResult) in
            
            switch photosResult {
                
            case let .success( photos ):
                print( "Successfully found \(photos.count) photos" )
                self.photoDataSource.photos = photos
                
            case let .failure( error ):
                print( "Error fetching interesting photos: \(error)" )
                self.photoDataSource.photos.removeAll()
            }
            
            self.collectionView.reloadSections( IndexSet( integer: 0 ))
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[ indexPath.row ]
        
        // download the image data, which could take some time...
        //
        store.fetchImage(for: photo) { (result) -> Void in
            
            // The index path for the photo MIGHT have changed between the
            // time the request started and the time it finished, so find
            // the most recent index path
            //
            guard let photoIndex = self.photoDataSource.photos.firstIndex( of: photo ),
                case let .success( image ) = result else {
                    return
            }
            let photoIndexPath = IndexPath( item: photoIndex, section: 0 )
            
            // when the request finishes, find the current cell for this photo
            //
            if let cell = self.collectionView.cellForItem( at: photoIndexPath ) as? PhotoCollectionViewCell {
                cell.update( displaying: image )
            }
        }
    }
}
