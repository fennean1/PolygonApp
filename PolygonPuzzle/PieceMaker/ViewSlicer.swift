
import Foundation

import UIKit


// Need this for drawing over the view.
class ViewSlicer: UIView {
    
    var corners: [CGPoint] = []
    var myPan: UIPanGestureRecognizer!
    
    func reset() {
        corners = []
        cutStart = nil
        drawingComplete = false
        cutEnd = CGPoint(x: 0,y: 0)
    }
    
    public var cutStart: CGPoint?
    
    // These might take over for CuttingViewNeedsClearing and ValidCutHasBeenMade
    var drawingComplete = false
    
    // Might want to look into this some more...
    public var cutEnd: CGPoint?
    {
        didSet {
            // Don't call set needs display if pan has ended.
            self.setNeedsDisplay()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = cutStart else {cutStart = (touches.first?.location(in: self))!; return}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches ended has been called")
        guard let _ = cutEnd else {cutStart = nil; return}
    }
    
    // Draw is a single source of truth for our view. Everything drawn is a function of
    // the current app state.
    override func draw(_ rect: CGRect) {
        guard let _ = cutStart else {return}

        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.white.cgColor)
        context?.setLineWidth(4)
        
        context?.move(to: cutStart!)
        
        for c in corners {
            context?.addLine(to: c)
        }
        
        context?.addLine(to: cutEnd!)
        context?.strokePath()
    }
    
    func makePolygon(color: CGColor) -> DraggablePolygon {
        
        var vertices = [cutStart]
        vertices = vertices + corners
        vertices.append(cutEnd)
        let newPolygon = DraggablePolygon()
        let newPolygonFrame = getFrame(of: vertices as! [CGPoint])
        newPolygon.frame = newPolygonFrame
        let adjustedVertices = vertices.map({v in subtractPoints(a: (v as CGPoint?)!, b: newPolygonFrame.origin)})
        newPolygon.config(vertices: adjustedVertices)
        newPolygon.polygonLayer.colorOverride = true
        newPolygon.polygonLayer.myColor = color
        newPolygon.drawTheLayer()
        return newPolygon
        
    }
    
    @objc func panHandler(pan: UIPanGestureRecognizer){
        
        if pan.state == .ended {
            
            if distance(a: cutEnd!, b: cutStart!) < 20 {
                cutEnd = cutStart!
                drawingComplete = true
                UIView.animate(withDuration: 1, animations: {makePieceButton.alpha = 1})
            } else {
                corners.append(cutEnd!)
            }
            
        }
        
        if !drawingComplete {
           cutEnd = pan.location(in: self)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = colorForSix
        
        myPan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        
        self.addGestureRecognizer(myPan)
    }
    
    
}
