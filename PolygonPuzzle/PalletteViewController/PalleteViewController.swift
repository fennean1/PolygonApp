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


class PalleteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var backButton = UIButton()
    var backGround: UIButton!
    var notification: Parachute!
    
    override func viewDidAppear(_ animated: Bool) {
        
        notification = Parachute(frame: view.frame)
        view.addSubview(notification)
        
        if SavedPolygons.count == 0 {
            notification.setText(message: "You have no saved polygons!")
            notification.showParachute()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = indexPath.row
        PolygonsOnPallette.append(SavedPolygons[i])
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "DesignViewController")
        
        self.show(vc as! UIViewController, sender: vc)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SavedPolygons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let i = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "palleteCell", for: indexPath) as! PalleteCell
        
        cell.drawPolygon(n: i)
        
        return cell
        
    }
    
    @objc func goBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "DesignViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ----------- init ----------------------
        
        let backGround = UIImageView()
        
        // ------------ targets ---------------------
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        
        // ---------- Adding The Views -----------
        
        view.addSubview(backGround)
        view.addSubview(backButton)
        //view.addSubview(ActivePolygon)
        
        
        // -------------- Setting State ---------------
        
        backGround.image = BackGround
        backButton.setImage(BackImage, for: .normal)
        
        
        // -----  Ordering Views ------------
        
        //view.bringSubview(toFront: ActivePolygon)
        view.sendSubview(toBack: backGround)
        
        
        // ------------ Adding Styles ----------------------
        
        //ActivePolygon.center = self.view.center
        backGround.frame.styleFillContainer(container: view.frame)
        backButton.frame.styleTopLeft(container: view.frame)
        
        // ----- Finishing Touches ---------------
        
        // Need to fetch PallettePuzzle
        
        
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

