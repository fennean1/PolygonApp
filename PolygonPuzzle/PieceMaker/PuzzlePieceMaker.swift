//
//  PuzzlePieceMaker.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/28/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


var viewSlicer: ViewSlicer!

var makePieceButton: UIButton!

class PieceMakerViewController: UIViewController {
    
    var backButton = UIButton()
    var currentColor = colorForOne.cgColor
    
    
    @objc func navigateBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "DesignViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    @objc func makePiece(sender: UIButton) {
        let newPiece = viewSlicer.makePolygon(color: currentColor)
        SavedPolygons.append(newPiece)
        PolygonsOnPallette.append(newPiece)
        viewSlicer.reset()
        print("makePiece Called")
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "DesignViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    @objc func pickColor(sender: ColorButton) {
        
        viewSlicer.backgroundColor = sender.myColor
        currentColor = sender.myColor.cgColor
        
    }
    
    
    override func viewDidLoad() {
        
        // Set Up ColorPickers
        let colorForZeroPicker = ColorButton()
        let colorForOnePicker = ColorButton()
        let colorForTwoPicker = ColorButton()
        let colorForThreePicker = ColorButton()
        let colorForFourPicker = ColorButton()
        let colorForFivePicker = ColorButton()
        let colorForSixPicker = ColorButton()
        let colorForSevenPicker = ColorButton()
        let colorForEightPicker = ColorButton()
        let colorForNinePicker = ColorButton()
        
        let colorPickers = [(colorForZeroPicker,colorForZero),(colorForOnePicker,colorForOne),(colorForTwoPicker,colorForTwo),(colorForThreePicker,colorForThree),(colorForFourPicker,colorForFour),(colorForFivePicker,colorForFive),(colorForSixPicker,colorForSix),(colorForSevenPicker,colorForSeven),(colorForEightPicker,colorForEight),(colorForNinePicker,colorForNine)]
        
        viewSlicer = ViewSlicer()
        viewSlicer.backgroundColor = colorForOne
        view.addSubview(viewSlicer)
        viewSlicer.frame.styleFillContainer(container: view.frame)
        
        view.addSubview(backButton)
        backButton.frame.styleTopLeft(container: view.frame)
        backButton.setImage(BackImage, for: .normal)
        backButton.addTarget(self, action: #selector(navigateBack(sender:)), for: .touchUpInside)
        
        for (i,T) in colorPickers.enumerated() {
            let b = T.0
            view.addSubview(b)
            b.addTarget(self, action: #selector(pickColor(sender:)), for: .touchUpInside)
            b.config(color: T.1)
            print("this is i",i)
            b.frame.styleColorPickerButton(order: CGFloat(i), container: view.frame)
        }
        makePieceButton = UIButton()
        view.addSubview(makePieceButton)
        makePieceButton.frame.styleTopRight(container: view.frame)
        makePieceButton.addTarget(self, action: #selector(makePiece(sender:)), for: .touchUpInside)
        makePieceButton.setImage(DoneImage, for: .normal)
        makePieceButton.alpha = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}
