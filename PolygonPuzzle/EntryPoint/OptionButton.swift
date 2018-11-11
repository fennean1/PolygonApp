//
//  OptionButton.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/21/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


class OptionButton: UIButton {
    
    var thumb = UIImageView()
    var textView = UILabel()
    
    
    func initiaize(img: UIImage,text: String,frame: CGRect) {
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 5
        
        var thumbFrame: CGRect {
            let x = CGFloat(0)
            let y = CGFloat(0)
            let h = frame.height/7
            let w = h
            
            return CGRect(x: x, y: y, width: w, height: h)
        }
        thumb.frame = thumbFrame
        //thumb.backgroundColor = UIColor.brown
        
        var textViewFrame: CGRect {
            let h = frame.height/7
            let x = h
            let y = CGFloat(0)
            let w = 0.8*frame.width - h
            
            return CGRect(x: x, y: y, width: w, height: h)
        }
        
        textView.frame = textViewFrame
        //textView.backgroundColor = UIColor.cyan
        
        thumb.image = img
        textView.text = text
        textView.textAlignment = NSTextAlignment.center
        textView.font = UIFont(name: "ChalkBoard SE", size: frame.width/20)
        
        self.addSubview(thumb)
        self.addSubview(textView)
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
