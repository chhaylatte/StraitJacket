//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import StraitJacket

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
        self.view = view
        
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blueView.backgroundColor = .blue
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Title"
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Subtitle\nSubtitle\nSubtitle"
        subtitleLabel.textColor = .gray
        subtitleLabel.sizeToFit()
        
        let guide = UILayoutGuide()
        
        let horizontalLine = UIView(frame: .zero)
        horizontalLine.backgroundColor = .black
        
        
        let restraint = Restraint(view)
            .addItems([guide, blueView, titleLabel, subtitleLabel,
                       horizontalLine])
            .widths([blueView.width(50)])
            .heights([blueView.height(50)], [horizontalLine.height(1)])
            .vertical([titleLabel, subtitleLabel],
                      [guide, horizontalLine])
            .horizontal([blueView, Space(8), titleLabel],
                        [blueView, Space(8), subtitleLabel])
            .aligns([guide], sides: [.top, .left])
            .aligns([horizontalLine], sides: [.left, .right])
            .guide(guide) { restraintGuide in
                restraintGuide.aligns([blueView], with: [.top, .left, .softBottom])
                restraintGuide.aligns([titleLabel], with: [.top])
                restraintGuide.aligns([titleLabel, subtitleLabel], with: [.right])
                restraintGuide.aligns([subtitleLabel], with: [.bottom])
                    .vertical([titleLabel, Space(10, relation: .greaterThanOrEqual), subtitleLabel])
            
        }
        restraint.isActive = true
        
        self.view
        print(blueView, guide)
        
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
