//
//  Notifications.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/22/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

// Exports: Global "Parachute Notification" - needs to be renamed "Global Parachute"
var parachute = Parachute(frame: ViewControllerFrame)
var helpOn = true

func notify(messege: String) {
    
    if helpOn == true {
        print("showing parachute")
        //parachute.superview?.bringSubview(toFront: parachute)
        parachute.setText(message: messege)
        parachute.showParachute()
    }
    
}
