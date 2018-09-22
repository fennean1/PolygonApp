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



class DesignViewController: UIViewController {

    var backButton: UIButton!
    var backGround: UIButton!
    var notification: Parachute!
    

    @objc func undo(sender: UIButton) {
        
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
        
        view.tag = 1
        
        
        // Could be like "current Puzzle" or some shit"
        AllPolygons = SavedPolygons
        
        // ----------- init ----------------------

        let backGround = UIImageView()
        backButton = UIButton()
        
        
        // ------------ targets ---------------------
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        // ---------- Adding The Views -----------
        
        view.addSubview(backGround)
        view.addSubview(backButton)
        
        if AllPolygons.count != 0 {
            for p in AllPolygons {
                view.addSubview(p)
            }
        }
        
        
        // -------------- Setting State ---------------
        
        backButton.setImage(ImgGoBack, for: .normal)

        // -----  Ordering Views ------------
        

        
        // ------------ Adding Styles ----------------------
        
        backButton.frame.styleTopLeft(container: view.frame)
        backGround.frame.styleFillContainer(container: view.frame)
        

        // ----- Finishing Touches ---------------
        
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

