import Foundation
import UIKit

func printAllSisters() {
    var totalNodes = 0
    for p in AllPolygons {
        for n in p.nodes! {
            totalNodes += 1
        }
    }
    print("Total Nodes",totalNodes)
}

func getAllSisters(withIndex index: Int) -> [Node] {
    
    var returnMe: [Node] = []
    
    for p in AllPolygons {
        
        let filteredBySister = p.nodes?.filter({$0.sister == index})
        
        // Make sure that this sister has an origin that can later be used.
        filteredBySister?.forEach({$0.origin = p.frame.origin})
        
        returnMe += filteredBySister!
    }
    
    return returnMe
}

func validateSisters(sisters: [Node]) -> Bool {
    
    var varSisters = sisters
    
    var valid = true
    
    let mark = varSisters.popLast()
    
    for s in varSisters {
        if distance(a: s.locationInSuperview, b: (mark?.locationInSuperview)!) > 50 {
            valid = false
        }
    }
    
    return valid
}

func validateAllSisters() -> Bool {
    var valid = true
    for i in 0...SisterIndex {
        let sisters = getAllSisters(withIndex: i)
        print("sister index",i)
        for s in sisters {
            print("sister location",s.locationInSuperview)
        }
        if !validateSisters(sisters: sisters) {
            valid = false
        }
    }
    return valid
}
