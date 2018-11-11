//
//  ViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

// This will fail on launch is AllPolygons is currently empty. What's the initial state for these polygons? How do we show that none have been created yet? How do we redirect them to create more?

import UIKit
import Foundation

func balls() {
    print("Function is balls")
}

class DesignViewController: UIViewController  {

    //let collectionView = UICollectionView()
    
    var backButton: UIButton!
    var rotateButton = UIButton()
    var trashButton = UIButton()
    var palleteButton = UIButton()
    var flipButton = UIButton()
    var notification: Parachute!
    var rotateCounter: Double = 0
    var newPieceButton = UIButton()
    var n = 1
    
    var rotationOfCurrentPiece: CGFloat = 0
    let scaleXOfCurrentPiece: CGFloat = 1
    let scaleYOfCurrentPiece: CGFloat = 1
    
    

    @objc func rotate(sender: UIButton) {
        
        
        
        print("trying to rotate and the current rotation is",rotationOfCurrentPiece)
        if AllPolygons.count != 0 {
        
            let currentScaleX = ActivePolygon.transform.a
            let currentScaleY = ActivePolygon.transform.d
            print("currentScaleX,currentScaleY",currentScaleX,currentScaleY)
            let newRotation = rotationOfCurrentPiece + CGFloat((90.0 * .pi) / 180.0)
            print("newRotation",newRotation)
        
            UIView.animate(withDuration: 1, animations: {ActivePolygon.transform = CGAffineTransform(rotationAngle: newRotation)})
            
        
        
        }
        
        rotationOfCurrentPiece = atan2(ActivePolygon.transform.b, ActivePolygon.transform.a)
        
        
    }
    
    @objc func trash(sender: UIButton) {
        print("trash clicked")
        if AllPolygons.count != 0 {
            ActivePolygon.removeFromSuperview()
            AllPolygons.remove(at: ActivePolygonIndex)
            PolygonsOnPallette = AllPolygons
        }
    }
    
    @objc func segueToPallete(sender: UIButton) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PalletteViewController")
        
        self.show(vc as! UIViewController, sender: vc)
    }
    
    @objc func flip(sender: UIButton){
     sender.isEnabled = false
        let _ = Timer.scheduledTimer(withTimeInterval: 1.1, repeats: false, block: {_ in sender.isEnabled = true})
 
        ActivePolygon.polygonLayer.flip()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if AllPolygons.count != 0 {
            view.bringSubview(toFront: ActivePolygon)
        }
    }
    
    @objc func goBack(sender: UIButton) {

        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "EntryPointViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    @objc func segueToNewPieceViewController(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PieceMakerViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        notification = Parachute(frame: view.frame)
        view.addSubview(notification)
        
        if SavedPolygons.count == 0 {
            notification.setText(message: "You have no saved polygons!")
            notification.showParachute()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tag = 1
        
        // ----------- init ----------------------

        let backGround = UIImageView()
        backButton = UIButton()
        
        
        // ------------ targets ---------------------
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(trash(sender:)), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(rotate(sender:)), for: .touchUpInside)
        flipButton.addTarget(self, action: #selector(flip(sender:)), for: .touchUpInside)
        palleteButton.addTarget(self, action: #selector(segueToPallete(sender:)), for: .touchUpInside)
        newPieceButton.addTarget(self, action: #selector(segueToNewPieceViewController(sender:)), for: .touchUpInside)
        
        // ---------- Adding The Views -----------
        
        view.addSubview(backGround)
        view.addSubview(backButton)
        view.addSubview(trashButton)
        view.addSubview(rotateButton)
        view.addSubview(palleteButton)
        view.addSubview(newPieceButton)
        view.addSubview(flipButton)
        
        // AllPolygons is so global that it works kind of like a "Scratch Pad" We can just assign it whatever polygons we want to work on and they behave just like they would in the cutting view. Even if there is no cutting.
        
        AllPolygons = PolygonsOnPallette
        
        if AllPolygons.count != 0 {
            for p in AllPolygons {
                view.addSubview(p)
            }
        }
        
        
        
        
        // -------------- Setting State ---------------
        
        backButton.setImage(BackImage, for: .normal)
        backGround.image = BackGround
        trashButton.setImage(TrashIcon, for: .normal)
        rotateButton.setImage(RotateIcon, for: .normal)
        palleteButton.setImage(KeyPadImage, for: .normal)
        flipButton.setImage(FlipIconImage, for: .normal)
        newPieceButton.setImage(NewPieceButton, for: .normal)


        // -----  Ordering Views ------------
        

        
        // ------------ Adding Styles ----------------------
        
        backButton.frame.styleTopLeft(container: view.frame)
        backGround.frame.styleFillContainer(container: view.frame)
        trashButton.frame.styleBottomLeft(container: view.frame)
        rotateButton.frame.styleBottomRight(container: view.frame)
        //palleteButton.frame.styleTopRight(container: view.frame)
        flipButton.frame.styleBottomMiddle(container: view.frame)
        newPieceButton.frame.styleTopRight(container: view.frame)

        // ----- Finishing Touches ---------------
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

