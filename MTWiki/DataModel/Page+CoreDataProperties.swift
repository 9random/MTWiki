//
//  Page+CoreDataProperties.swift
//  MTWiki
//
//  Created by Rahul Sharma on 23/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension Page {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Page> {
        return NSFetchRequest<Page>(entityName: "Page")
    }

    @NSManaged public var pageid: Int64
    @NSManaged public var title: String?
    @NSManaged public var thumbnailSource: String?
    @NSManaged public var thumbnailWidth: Int64
    @NSManaged public var thumbnailHeight: Int64
    @NSManaged public var descriptionWiki: String?
    @NSManaged public var index: Int64

}
