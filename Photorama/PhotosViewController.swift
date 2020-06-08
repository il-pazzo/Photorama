//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    
    var store: PhotoStore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchInterestingPhotos { (photosResult) in
            
            switch photosResult {
                
            case let .success( photos ):
                print( "Successfully found \(photos.count) photos" )
                
            case let .failure( error ):
                print( "Error fetching interesting photos: \(error)" )
            }
        }
    }


}

