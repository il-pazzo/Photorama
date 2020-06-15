//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Glenn Cole on 6/10/20.
//  Copyright © 2020 Glenn Cole. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: Date?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: URL?
    @NSManaged public var title: String?

}
