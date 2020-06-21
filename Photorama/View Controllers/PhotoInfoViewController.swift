//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Glenn Cole on 6/10/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var store: PhotoStore!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    
    // MARK: - Code begins here
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.accessibilityLabel = photo.title
        
        store.fetchImage(for: photo) { (result) -> Void in
            
            switch result {
                
            case let .success( image ):
                self.imageView.image = image
                
            case let .failure( error ):
                print( "Error fetching image for photo: \(error)" )
            }
        }
    }
    
    override func prepare( for segue: UIStoryboardSegue, sender: Any? ) {
        
        switch segue.identifier {
            
        case "showTags":
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController

            tagController.store = store
            tagController.photo = photo
            
        default:
            preconditionFailure( "Unexpected segue identifier." )
        }
    }
}
