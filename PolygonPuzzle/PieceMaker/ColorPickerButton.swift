//
//  ColorPickerButton.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/28/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


class ColorButton: UIButton {
    
    var myColor: UIColor!
    
    func config(color: UIColor){
        self.myColor = color
        self.backgroundColor = color
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 5
    }
}
