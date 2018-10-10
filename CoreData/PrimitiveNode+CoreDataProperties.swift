//
//  PrimitiveNode+CoreDataProperties.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/1/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//
//

import Foundation
import CoreData


extension PrimitiveNode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PrimitiveNode> {
        return NSFetchRequest<PrimitiveNode>(entityName: "PrimitiveNode")
    }

    @NSManaged public var isOriginalNode: Bool
    @NSManaged public var sisterIndex: Int16
    @NSManaged public var xCoordinate: Float
    @NSManaged public var yCoordinate: Float
    @NSManaged public var drawingOrder: Int16
    @NSManaged public var polygon: Polygon?

}
