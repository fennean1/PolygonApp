//
//  NumberFrame.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/21/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

let imgs = [Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine]

class NumberFrame: UIView {

    var dm: CGFloat = 0
    var Left =  UIImageView()
    var Right = UIImageView()
    
    
    func getSizeFromDimAndNumber(n: Int,dim: CGFloat) -> CGSize {
        
        if n < 10 {
            return CGSize(width: dim, height: dim)
        } else if n >= 10 {
            return CGSize(width: 2*dim, height: dim)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func setImage(for n: Int) {
        if n < 10 {
            Right.removeFromSuperview()
            Left.image = imgs[n]
        } else if n >= 10 {
            self.addSubview(Right)
            let ones = n%10
            let tens = (n - ones)/10
            Left.image = imgs[tens]
            Right.image = imgs[ones]
        }
    }
    
    func render(n: Int) {
        let size = getSizeFromDimAndNumber(n: n, dim: self.dm)
        self.setImage(for: n)
        self.frame.size = size
    }
    
    // Custom initializer.
    init(n: Int,dim: CGFloat) {
        
        self.dm = dim
        var initFrame = CGRect(x: 0, y: 0, width: 0, height: 0)

        Left.frame = CGRect(x: 0, y: 0, width: dim, height: dim)
        Right.frame = CGRect(x: dim, y: 0, width: dim, height: dim)
        
        if n < 10 {
            initFrame = CGRect(x: 0, y: 0, width: dim, height: dim)
        } else if n >= 10 {
            let ones = n%10
            let tens = (n - ones)/10
            Left.image = imgs[tens]
            Right.image = imgs[ones]
            initFrame = CGRect(x: 0, y: 0, width: 2*dim, height: dim)
        }
        
        super.init(frame: initFrame)
        
        self.addSubview(Left)
        self.addSubview(Right)
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

    
}
