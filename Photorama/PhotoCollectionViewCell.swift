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
    
    
    // MARK: - Accessibility vars
    
    var photoDescription: String?
    
    override var isAccessibilityElement: Bool {
        get {
            return true
        }
        set {
            // ignored
        }
    }
    
    override var accessibilityLabel: String? {
        get {
            return photoDescription
        }
        set {
            // ignored
        }
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            return super.accessibilityTraits.union([ .image, .button ])
        }
        set {
            // ignore
        }
    }
    
    // MARK: - Code begins here
    
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
