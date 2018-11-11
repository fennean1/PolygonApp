
import Foundation
import UIKit



class PuzzleCell: UICollectionViewCell {


     let nameText = UILabel()
     var puzzle = UIView()

    func clear() {
        puzzle.removeFromSuperview()
        nameText.removeFromSuperview()
    }

    // Need to write a shrink function.
    func drawPuzzle(cache: cachedPuzzle) {
        
        var nameTextFrame: CGRect {
           
            let x: CGFloat = 0
            let y: CGFloat = 250
            let w: CGFloat = 250
            let h: CGFloat = 50
            
            return CGRect(x: x, y: y, width: w, height: h)
        }
        
        nameText.frame = nameTextFrame
        nameText.text = cache.puzzleName
        nameText.textAlignment = .center
        nameText.font = UIFont(name: "Chalkboard SE", size: 20)
        nameText.backgroundColor = UIColor.clear
        puzzle = cache.puzzleView
        contentView.addSubview(puzzle)
        contentView.addSubview(nameText)

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(puzzle)
        print("init called")
        //contentView.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        for v in contentView.subviews{
            v.removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("Awake From Nib, Setting Color To Blue")
        contentView.backgroundColor = UIColor.white
    }
    
}
