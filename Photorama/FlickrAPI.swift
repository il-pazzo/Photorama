//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Glenn Cole on 6/7/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//

import Foundation

enum EndPoint: String {
    
    case interestingPhotos = "flickr.interestingness.getList"
}

struct FlickrAPI {
    
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    static var interestingPhotosURL: URL {
        
        return flickrURL( endPoint: .interestingPhotos,
                          parameters: ["extras": "url_z,date_taken"] )
    }
    
    static let incomingJsonDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale( identifier: "en_US_POSIX" )
        dateFormatter.timeZone = TimeZone( secondsFromGMT: 0 )
        return dateFormatter
    }()
    
    
    // MARK: - Code begins here
    
    private static func flickrURL( endPoint: EndPoint,
                                   parameters: [String:String]? ) -> URL {
        
        var components = URLComponents( string: baseURLString )!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method"    : endPoint.rawValue,
            "format"    : "json",
            "nojsoncallback": "1",
            "api_key"   : apiKey,
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem( name: key, value: value )
            queryItems.append( item )
        }
        
        if let additionalParameters = parameters {
            
            for (key, value) in additionalParameters {
                let item = URLQueryItem( name: key, value: value )
                queryItems.append( item )
            }
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    static func photos( fromJSON data: Data ) -> Result<[FlickrPhoto], Error> {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted( incomingJsonDateFormatter )

            let flickrResponse = try decoder.decode( FlickrResponse.self, from: data )
            
            let photos = flickrResponse.photosInfo.photos.filter { $0.remoteURL != nil }
            
            return .success( photos )
        }
        catch {
            return .failure( error )
        }
    }
}

struct FlickrResponse: Codable {
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    let photos: [FlickrPhoto]
    
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}
