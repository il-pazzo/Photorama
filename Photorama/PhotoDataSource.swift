//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by Glenn Cole on 6/9/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()
    
    func collectionView( _ collectionView: UICollectionView,
                         numberOfItemsInSection section: Int ) -> Int {
        
        return photos.count
    }
    
    func collectionView( _ collectionView: UICollectionView,
                         cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        
        let identifier = "PhotoCollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell( withReuseIdentifier: identifier,
                                                       for: indexPath)
            as! PhotoCollectionViewCell
        
        let photo = photos[ indexPath.row ]
        cell.photoDescription = photo.title
        
        cell.update( displaying: nil )
        
        return cell
    }
}
