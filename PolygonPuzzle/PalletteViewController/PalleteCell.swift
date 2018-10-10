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
    var shape = UIImageView()

    // Dummy
    func drawPolygon(n: Int) {
        // Is extracting the vertices this way somehow changing their order?
        let v = SavedPolygons[n].vertices()
        let thumb = createThumbNailView(vertices: v, originalContextDim: InitialPolygonDim, newContextDim: self.frame.width)
        thumb.frame = self.bounds
        self.addSubview(thumb)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        print("Awake From Nib, Setting Color To Blue")
    }
}
