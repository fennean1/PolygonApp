//
//  Parachute.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/14/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


extension CGRect {
    
    mutating func styleHideParachute(container: CGRect) {
        
        let cH = container.height
        let cW = container.width
        
        let min = [cH,cW].min()!
        
        let h = min/5
        let w = 4*h
        let x = 1/2*(container.width - w)
        let y = -1.5*h
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
    mutating func styleShowParachute(container: CGRect) {
        
        let cH = container.height
        let cW = container.width
        
        let min = [cH,cW].min()!
        
        let h = min/5
        let w = 4*h
        let x = container.width/2 - w/2
        let y = 0.5*h
        
        self = CGRect(x: x, y: y, width: w, height: h)
        
    }
    
}

// Drops down from the top of screen and displays a message to the user.
class Parachute: UIView {
    
    var superViewFrame: CGRect?
    var content: ParachuteTextBox!
    
    func setText(message: String) {
        content.text = message
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // dismiss
        UIView.animate(withDuration: 0.5, animations: {self.frame.styleHideParachute(container: self.superViewFrame!)})
    }
    
    func showParachute() {
        UIView.animate(withDuration: 0.5, animations: {self.frame.styleShowParachute(container: self.superViewFrame!)})
    }
    
    func hideParachute() {
        UIView.animate(withDuration: 0.5, animations: {self.frame.styleHideParachute(container: self.superViewFrame!)})
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        superViewFrame = frame
        self.frame.styleHideParachute(container: frame)
  
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.content = ParachuteTextBox(frame: self.bounds)
        self.addSubview(self.content)
        self.content.text = "Hello World!"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class ParachuteTextBox: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bounds = frame
        self.textAlignment = .center
        self.font = UIFont(name: "Chalkboard SE", size: frame.height/4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


