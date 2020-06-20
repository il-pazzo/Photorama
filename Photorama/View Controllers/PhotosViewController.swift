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
    
    // implement pull-to-refresh!
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshThumbnails(_:)), for: .valueChanged)
        control.attributedTitle = NSAttributedString( string: "Retrieving photos..." )
        return control
    }()
    
    // MARK: - Code begins here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        fetchThumnails()
    }
    
    @objc func refreshThumbnails( _ sender: Any ) {
        
        fetchThumnails()
    }
}


// MARK: - Fetch photo thumbnails

extension PhotosViewController {
    
    func fetchThumnails() {
        
        // first show what Core Data has saved previously
        self.updateDataSourceWithAllPhotos()
        
        store.fetchInterestingPhotos { (photosResult) in
            
            // the following is performed on the main thread after the fetch has completed
            
            self.updateDataSourceWithAllPhotos()
            
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func updateDataSourceWithAllPhotos() {
        
        store.fetchAllPhotos { (photosResult) in
            
            switch photosResult {
                
            case let .success( photos ):
                self.photoDataSource.photos = photos
                
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            
            self.collectionView.reloadSections( IndexSet( integer: 0 ))
        }
    }
}


// MARK: - Implement collection view delegate method(s)

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


// MARK: - Handle segue to photo detail

extension PhotosViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let segueIdentifier = segue.identifier else {
            preconditionFailure( "Missing segue identifier" )
        }
        
        switch segueIdentifier {
            
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                
                let photo = photoDataSource.photos[ selectedIndexPath.row ]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
            
        default:
            preconditionFailure( "Unexpected segue identifier: \(segueIdentifier)" )
        }
    }
}
