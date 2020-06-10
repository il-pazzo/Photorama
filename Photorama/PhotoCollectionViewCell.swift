//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Glenn Cole on 6/9/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    func update( displaying image: UIImage? ) {
        
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}
