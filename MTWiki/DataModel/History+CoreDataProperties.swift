//
//  History+CoreDataProperties.swift
//  MTWiki
//
//  Created by Rahul Sharma on 24/06/18.
//  Copyright © 2018 Rahul Sharma. All rights reserved.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var pageIDSeen: Int64
    @NSManaged public var time: NSDate?
    @NSManaged public var pageUrl: String?
    @NSManaged public var thumbnailSource: String?
    @NSManaged public var title: String?
    @NSManaged public var descriptionWiki: String?
    @NSManaged public var data: NSData?
    @NSManaged public var pageDetails: Page?

}
