//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import StraitJacket

class MyViewController : UIViewController {
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = "Title"
        titleLabel.textColor = .black
        titleLabel.sizeToFit()
        
        return titleLabel
    }()
    
    lazy var subtitleLabel: UILabel = {
        let subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .gray
        subtitleLabel.sizeToFit()
        
        return subtitleLabel
    }()
    
    lazy var blueView: UIView = {
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blueView.backgroundColor = .blue
        
        return blueView
    }()
    
    lazy var guide: UILayoutGuide = UILayoutGuide()
    
    lazy var horizontalLine: UIView = {
        let horizontalLine = UIView(frame: .zero)
        horizontalLine.backgroundColor = .black
        
        return horizontalLine
    }()
    
    lazy var horizontalYellowLine: UIView = {
        let horizontalLine = UIView(frame: .zero)
        horizontalLine.backgroundColor = .yellow
        
        return horizontalLine
    }()
    
    lazy var blueView2: UIView = {
        let blueView2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        blueView2.backgroundColor = .blue
        
        return blueView2
    }()
    
    lazy var titleLabel2: UILabel = {
        let titleLabel2 = UILabel(frame: .zero)
        titleLabel2.text = "Title2"
        titleLabel2.textColor = .black
        titleLabel2.sizeToFit()
        
        return titleLabel2
    }()
    
    lazy var subtitleLabel2: UILabel = {
        let subtitleLabel2 = UILabel(frame: .zero)
        subtitleLabel2.text = "Subtitle2"
        subtitleLabel2.numberOfLines = 0
        subtitleLabel2.textColor = .gray
        subtitleLabel2.sizeToFit()
        
        return subtitleLabel2
    }()
    
    lazy var guide2 = UILayoutGuide()
    
    lazy var centeredLabel: UILabel = {
        let centeredLabel = UILabel(frame: .zero)
        centeredLabel.text = "X"
        centeredLabel.textColor = .purple
        centeredLabel.sizeToFit()
        
        return centeredLabel
    }()
    
    // MARK: -
    
    lazy var blueView3: UIView = {
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        aView.backgroundColor = .blue
        
        return aView
    }()
    
    lazy var titleLabel3: UILabel = {
        let aLabel = UILabel(frame: .zero)
        aLabel.text = "Title2"
        aLabel.textColor = .black
        aLabel.sizeToFit()
        
        return aLabel
    }()
    
    lazy var subtitleLabel3: UILabel = {
        let aLabel = UILabel(frame: .zero)
        aLabel.text = "Subtitle2"
        aLabel.numberOfLines = 0
        aLabel.textColor = .gray
        aLabel.sizeToFit()
        
        return aLabel
    }()
    
    lazy var guide3 = UILayoutGuide()
    
    override func loadView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = .white
        
        self.view = view
        
        let restraint = Restraint(view)
            .addItems([guide, blueView, titleLabel, subtitleLabel,
                       horizontalLine, horizontalYellowLine,
                       centeredLabel])
            .setWidths([blueView.width(60)])
            .setHeights([blueView.height(60)], [horizontalLine.height(10), horizontalYellowLine.height(4)])
            .chainVertically(
                [titleLabel, Space(10, relation: .greaterThanOrEqual), subtitleLabel],
                [guide, horizontalLine, centeredLabel])
            .chainHorizontally(
                [blueView, Space(8), titleLabel],
                [blueView, Space(8), subtitleLabel])
            .alignItems([guide], to: [.top, .left])
            .alignItems([horizontalLine], to: [.left, .right])
            .guide(guide) { restraintGuide in
                restraintGuide.alignItems([blueView], to: [.top, .left, .softBottom])
                restraintGuide.alignItems([titleLabel], to: [.top])
                restraintGuide.alignItems([titleLabel, subtitleLabel], to: [.softRight])
                restraintGuide.alignItems([subtitleLabel], to: [.bottom])
                restraintGuide.alignItems([centeredLabel], to: [.centerX])
                restraintGuide.alignItems([horizontalYellowLine], to: [.bottom, .left, .right])
            
        }
        restraint.isActive = true
        
        subtitleLabel.text = "Subtitle"
        self.view
        
        subtitleLabel.text = "Subtitle\nSubtitle Subtitle\nSubtitle"
        restraint.isActive = true // for some reason constraint may get deactivated
        self.view
        
        let restraint2 = Restraint(view)
            .addItems([guide2, blueView2, titleLabel2, subtitleLabel2])
            .setWidths([blueView2.width(60)])
            .setHeights([blueView2.height(60)])
            .chainVertically([titleLabel2, Space(10, relation: .greaterThanOrEqual), subtitleLabel2])
            .chainHorizontally([guide, Space(8), guide2],
                        [blueView2, Space(8), titleLabel2],
                        [blueView2, Space(8), subtitleLabel2])
            .alignItems([guide2], to: [.top])
            .alignItems([blueView2], to: [.top, .left, .softBottom],
                        of: guide2)
            .alignItems([titleLabel2], to: [.top], of: guide2)
            .guide(guide2) { restraintGuide in
                restraintGuide.alignItems([blueView2], to: [.top, .left, .softBottom])
                restraintGuide.alignItems([titleLabel2], to: [.top])
                restraintGuide.alignItems([titleLabel2, subtitleLabel2], to: [.right])
                restraintGuide.alignItems([subtitleLabel2], to: [.bottom])
        }
        restraint2.isActive = true
        
        self.view
        
        let restraint3 = Restraint(view)
            .addItems([guide3, blueView3, titleLabel3, subtitleLabel3])
            .setWidths([blueView3.width(60)])
            .setHeights([blueView3.height(60)])
            .chainVertically([titleLabel3, Space(10, relation: .greaterThanOrEqual), subtitleLabel3])
            .chainHorizontally([blueView3, Space(8), titleLabel3],
                        [blueView3, Space(8), subtitleLabel3])
            .alignItems([guide3], to: [.centerX, .centerY])
            .guide(guide3) { restraintGuide in
                restraintGuide.alignItems([blueView3], to: [.top, .left, .softBottom])
                restraintGuide.alignItems([titleLabel3], to: [.top])
                restraintGuide.alignItems([titleLabel3, subtitleLabel3], to: [.right])
                restraintGuide.alignItems([subtitleLabel3], to: [.bottom])
        }
        restraint3.isActive = true
        
        self.view
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
