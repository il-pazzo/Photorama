//
//  Photo.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

class Photo: Codable {
    
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
