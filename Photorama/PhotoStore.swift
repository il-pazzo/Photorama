//
//  PhotoStore.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

class PhotoStore {
    
    private let session: URLSession = {
        
        let config = URLSessionConfiguration.default
        
        return URLSession( configuration:  config )
    }()
    
    
    func fetchInterestingPhotos( completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLRequest( url: url )

        let task = session.dataTask( with: request ) {
            ( data, response, error ) in
            
            let result = self.processPhotosRequest(data: data, error: error )
            completion( result )
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
}
