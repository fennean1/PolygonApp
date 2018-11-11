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

var puzzleCollectionViewDataSource: [cachedPuzzle] = []

class PuzzleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var backButton = UIButton()
    var backGround: UIButton!
    var notification: Parachute!

    override func viewDidAppear(_ animated: Bool) {
        
        notification = Parachute(frame: view.frame)
        view.addSubview(notification)
        
        if FetchedPuzzles.count == 0 {
            notification.setText(message: "You have no saved Puzzles")
            notification.showParachute()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("fetchedPuzzleCount",puzzleCollectionViewDataSource.count)
        return puzzleCollectionViewDataSource.count // Saved Puzzles
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Record which puzzle is being solved.
        // Load puzzle into 'All polygons'
        // segue to solving view controller.
        // Need to start naming puzzle.
        
        print("puzzle selected")
        
        let i = indexPath.row
        
        let puzzleName = FetchedPuzzles[i].name
        
        let puzzles = FetchedPuzzles.filter({$0.name == puzzleName})
        let puzzle = puzzles.first!
        
        AllPolygons = buildDraggablePolygonsFromPuzzle(puzzle: puzzle,dim: InitialPolygonDim)
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PuzzleSolver")
        
        self.show(vc as! UIViewController, sender: vc)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let i = indexPath.row
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "puzzleCell", for: indexPath) as! PuzzleCell
    
        print("puzzleCollectionview data source count",puzzleCollectionViewDataSource.count)

        cell.drawPuzzle(cache: puzzleCollectionViewDataSource[i])
        
        return cell
        
    }
    
    @objc func goBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "EntryPointViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.register(PuzzleCell.self, forCellWithReuseIdentifier: "puzzleCell")
        
        
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
    
        view.sendSubview(toBack: backGround)
        
        
        // ------------ Adding Styles ----------------------
        
        backGround.frame.styleFillContainer(container: view.frame)
        backButton.frame.styleTopLeft(container: view.frame)
        
        // ----- Finishing Touches ---------------
        
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

