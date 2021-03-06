//
//  FlickrPhoto.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

class FlickrPhoto: Codable {
    
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}

extension FlickrPhoto: Equatable {
    
    static func == ( lhs: FlickrPhoto, rhs: FlickrPhoto ) -> Bool {
        
        // two photos are "equal" if they have the same photo id
        //
        return lhs.photoID == rhs.photoID
    }
}
