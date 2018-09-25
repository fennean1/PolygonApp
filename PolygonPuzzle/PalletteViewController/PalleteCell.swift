//
//  PalleteCell.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/17/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

class PalleteCell: UICollectionViewCell {
    

    // Dummy
    func drawPolygon(n: Int) {
        let polygon = DraggablePolygon()
        let v = getVerticesForType(numberOfSides: n, radius: 50)
        polygon.config(vertices: v)
        polygon.drawTheLayer()
        polygon.frame = self.bounds
        self.addSubview(polygon)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blue
    }
}
