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


class PalleteViewController: UICollectionViewController {
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "palleteCell", for: indexPath) as! PalleteCell
        
        cell.drawPolygon(n: 6)
        
        return cell
        
    }
    
    @objc func goBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "LandingViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ----------- init ----------------------
        
        // let backGround = UIImageView()
        
        // ------------ targets ---------------------
        
        
        
        // ---------- Adding The Views -----------
        
        //view.addSubview(backGround)
        //view.addSubview(ActivePolygon)
        
        
        // -------------- Setting State ---------------
        
        
        
        // -----  Ordering Views ------------
        
        //view.bringSubview(toFront: ActivePolygon)
        
        
        // ------------ Adding Styles ----------------------
        
        //ActivePolygon.center = self.view.center
        
        // ----- Finishing Touches ---------------
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

