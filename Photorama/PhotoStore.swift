//
//  PhotoStore.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import UIKit

enum PhotoError: Error {
    
    case imageCreationError
    case missingImageURL
}

class PhotoStore {
    
    let imageStore = ImageStore()
    
    private let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        return URLSession( configuration:  config )
    }()
    
    
    func fetchInterestingPhotos( completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest( url: url )

        let task = session.dataTask( with: request ) {
            ( data, response, error ) in
            
            if let httpResponse = response as? HTTPURLResponse {
                print( "Interesting photos: http status = \(httpResponse.statusCode)",
                    "\n...headers = \(httpResponse.allHeaderFields)" )
            }
            
            let result = self.processPhotosRequest(data: data, error: error )
            OperationQueue.main.addOperation {
                completion( result )
            }
        }
        task.resume()
    }
    
    func fetchImage( for photo: Photo,
                     completion: @escaping (Result<UIImage, Error>) -> Void ) {
        
        let photoKey = photo.photoID
        if let image = imageStore.image( forKey: photoKey ) {
            OperationQueue.main.addOperation {
                completion( .success( image ))
            }
            return
        }
    
        guard let photoURL = photo.remoteURL else {
            completion( .failure( PhotoError.missingImageURL ))
            return
        }
        
        let request = URLRequest( url: photoURL )
        
        let task = session.dataTask( with: request ) { (data, response, error) in
            
            let result = self.processImageRequest( data: data, error: error )
            
            if case let .success( image ) = result {
                self.imageStore.setImage( image, forKey: photoKey )
            }
            
            OperationQueue.main.addOperation {
                completion( result )
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest( data: Data?,
                                       error: Error? ) -> Result<[Photo], Error> {
        
        guard let jsonData = data else {
            return .failure( error! )
        }
        
        return FlickrAPI.photos( fromJSON: jsonData )
    }
    
    private func processImageRequest( data: Data?,
                                      error: Error? ) -> Result<UIImage, Error> {
        
        guard let imageData = data,
            let image = UIImage( data: imageData ) else {
                
                if data == nil { return .failure( error! ) }
                else { return .failure( PhotoError.imageCreationError ) }
        }
        
        return .success( image )
    }
}
