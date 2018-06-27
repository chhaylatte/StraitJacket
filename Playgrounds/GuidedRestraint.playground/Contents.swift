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
        subtitleLabel.textColor = .gray
        subtitleLabel.sizeToFit()
        
        let guide = UILayoutGuide()
        
        let horizontalLine = UIView(frame: .zero)
        horizontalLine.backgroundColor = .black
        
        let restraint = Restraint(view)
            .addItems([guide, blueView, titleLabel, subtitleLabel,
                       horizontalLine])
            .widths([blueView.width(60)])
            .heights([blueView.height(60)], [horizontalLine.height(1)])
            .vertical([titleLabel, subtitleLabel],
                      [guide, horizontalLine])
            .horizontal([blueView, Space(8), titleLabel],
                        [blueView, Space(8), subtitleLabel])
            .aligns([guide], sides: [.top, .left])
            .aligns([horizontalLine], sides: [.left, .right])
            .guide(guide) { restraintGuide in
                restraintGuide.aligns([blueView], with: [.top, .left, .softBottom])
                restraintGuide.aligns([titleLabel], with: [.top])
                restraintGuide.aligns([titleLabel, subtitleLabel], with: [.softRight])
                restraintGuide.aligns([subtitleLabel], with: [.bottom])
                    .vertical([titleLabel, Space(10, relation: .greaterThanOrEqual), subtitleLabel])
            
        }
        restraint.isActive = true
        
        subtitleLabel.text = "Subtitle"
        self.view
        
        subtitleLabel.text = "Subtitle\nSubtitle Subtitle\nSubtitle"
        restraint.isActive = true // for some reason constraint may get deactivated
        self.view
        
        
        let blueView2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blueView2.backgroundColor = .blue
        
        let titleLabel2 = UILabel(frame: .zero)
        titleLabel2.text = "Title2"
        titleLabel2.textColor = .black
        titleLabel2.sizeToFit()
        
        let subtitleLabel2 = UILabel(frame: .zero)
        subtitleLabel2.text = "Subtitle2"
        subtitleLabel2.numberOfLines = 0
        subtitleLabel2.textColor = .gray
        subtitleLabel2.sizeToFit()
        
        let guide2 = UILayoutGuide()
        
        let restraint2 = Restraint(view)
            .addItems([guide2, blueView2, titleLabel2, subtitleLabel2])
            .widths([blueView2.width(60)])
            .heights([blueView2.height(60)])
            .vertical([titleLabel2, subtitleLabel2],
                      [guide2])
            .horizontal([guide, Space(8), guide2],
                        [blueView2, Space(8), titleLabel2],
                        [blueView2, Space(8), subtitleLabel2])
            .aligns([guide2], sides: [.top])
            .guide(guide2) { restraintGuide in
                restraintGuide.aligns([blueView2], with: [.top, .left, .softBottom])
                restraintGuide.aligns([titleLabel2], with: [.top])
                restraintGuide.aligns([titleLabel2, subtitleLabel2], with: [.right])
                restraintGuide.aligns([subtitleLabel2], with: [.bottom])
                    .vertical([titleLabel2, Space(10, relation: .greaterThanOrEqual), subtitleLabel2])
                
        }
        restraint2.isActive = true
        
        self.view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
