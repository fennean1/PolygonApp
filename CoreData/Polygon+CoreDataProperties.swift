//
//  Polygon+CoreDataProperties.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/1/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//
//

import Foundation
import CoreData


extension Polygon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Polygon> {
        return NSFetchRequest<Polygon>(entityName: "Polygon")
    }

    @NSManaged public var index: Int16
    @NSManaged public var nodes: NSOrderedSet?
    @NSManaged public var puzzle: Puzzle?

}

// MARK: Generated accessors for nodes
extension Polygon {

    @objc(insertObject:inNodesAtIndex:)
    @NSManaged public func insertIntoNodes(_ value: PrimitiveNode, at idx: Int)

    @objc(removeObjectFromNodesAtIndex:)
    @NSManaged public func removeFromNodes(at idx: Int)

    @objc(insertNodes:atIndexes:)
    @NSManaged public func insertIntoNodes(_ values: [PrimitiveNode], at indexes: NSIndexSet)

    @objc(removeNodesAtIndexes:)
    @NSManaged public func removeFromNodes(at indexes: NSIndexSet)

    @objc(replaceObjectInNodesAtIndex:withObject:)
    @NSManaged public func replaceNodes(at idx: Int, with value: PrimitiveNode)

    @objc(replaceNodesAtIndexes:withNodes:)
    @NSManaged public func replaceNodes(at indexes: NSIndexSet, with values: [PrimitiveNode])

    @objc(addNodesObject:)
    @NSManaged public func addToNodes(_ value: PrimitiveNode)

    @objc(removeNodesObject:)
    @NSManaged public func removeFromNodes(_ value: PrimitiveNode)

    @objc(addNodes:)
    @NSManaged public func addToNodes(_ values: NSOrderedSet)

    @objc(removeNodes:)
    @NSManaged public func removeFromNodes(_ values: NSOrderedSet)

}
