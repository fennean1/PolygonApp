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
    var notification: Parachute!
    var rotateCounter: Double = 0
    

    @objc func rotate(sender: UIButton) {
        
        
        print("trying to rotate")
        
        let currentRotation = atan2(ActivePolygon.transform.b, ActivePolygon.transform.a)
        let newRotation = currentRotation + CGFloat((90.0 * .pi) / 180.0)
        
        UIView.animate(withDuration: 1, animations: {ActivePolygon.transform = CGAffineTransform(rotationAngle: newRotation)})
        
   
       
        // Reset the transform so it rotates again the second time.
      
   
    }
    
    @objc func trash(sender: UIButton) {
        
    }
    
    @objc func segueToPallete(sender: UIButton) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PalleteViewController")
        
        self.show(vc as! UIViewController, sender: vc)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.bringSubview(toFront: ActivePolygon)
    }
    
    @objc func goBack(sender: UIButton) {

        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "LandingViewController")
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
        
        // Can I do this programmatically?
        //collectionView.dataSource = self as? UICollectionViewDataSource
        //collectionView.delegate = self as? UICollectionViewDelegate
        
        view.tag = 1
        
        // AllPolygons is so global that it works kind of like a "Scratch Pad" We can just assign it whatever polygons we want to work on and they behave just like they would in the cutting view. Even if there is no cutting. 
        
        AllPolygons = SavedPolygons
        
        // ----------- init ----------------------

        let backGround = UIImageView()
        backButton = UIButton()
        
        
        // ------------ targets ---------------------
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        trashButton.addTarget(self, action: #selector(trash(sender:)), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(rotate(sender:)), for: .touchUpInside)
        palleteButton.addTarget(self, action: #selector(segueToPallete(sender:)), for: .touchUpInside)
        
        // ---------- Adding The Views -----------
        
        view.addSubview(backGround)
        view.addSubview(backButton)
        view.addSubview(trashButton)
        view.addSubview(rotateButton)
        view.addSubview(palleteButton)
        
        if AllPolygons.count != 0 {
            for p in AllPolygons {
                view.addSubview(p)
            }
        }
        
        
        // -------------- Setting State ---------------
        
        backButton.setImage(ImgGoBack, for: .normal)
        backGround.image = BackGround
        trashButton.setImage(TrashIcon, for: .normal)
        rotateButton.setImage(RotateIcon, for: .normal)
        palleteButton.setImage(DesignButtonImage, for: .normal)


        // -----  Ordering Views ------------
        

        
        // ------------ Adding Styles ----------------------
        
        backButton.frame.styleTopLeft(container: view.frame)
        backGround.frame.styleFillContainer(container: view.frame)
        trashButton.frame.styleBottomLeft(container: view.frame)
        rotateButton.frame.styleBottomRight(container: view.frame)
        palleteButton.frame.styleBottomMiddle(container: view.frame)

        // ----- Finishing Touches ---------------
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

