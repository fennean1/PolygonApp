//
//  Puzzle+CoreDataProperties.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/1/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//
//

import Foundation
import CoreData


extension Puzzle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Puzzle> {
        return NSFetchRequest<Puzzle>(entityName: "Puzzle")
    }

    @NSManaged public var name: String?
    @NSManaged public var polygons: NSSet?

}

// MARK: Generated accessors for polygons
extension Puzzle {

    @objc(addPolygonsObject:)
    @NSManaged public func addToPolygons(_ value: Polygon)

    @objc(removePolygonsObject:)
    @NSManaged public func removeFromPolygons(_ value: Polygon)

    @objc(addPolygons:)
    @NSManaged public func addToPolygons(_ values: NSSet)

    @objc(removePolygons:)
    @NSManaged public func removeFromPolygons(_ values: NSSet)

}
