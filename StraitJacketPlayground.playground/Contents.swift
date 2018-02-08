//: Playground - noun: a place where people can play

import UIKit
import StraitJacket

import PlaygroundSupport

let label = UILabel(frame: .zero)
label.textColor = .black
label.text = "StraitJacket"
label.font = UIFont.systemFont(ofSize: 20)

let horizontalLine = UIView(frame: .zero)
horizontalLine.backgroundColor = .black

let verticalLine = UIView(frame: .zero)
verticalLine.backgroundColor = .black

let redView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
redView.backgroundColor = .red

let greenView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
greenView.backgroundColor = .green

let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
blueView.backgroundColor = .blue

let view = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
view.backgroundColor = .yellow
view.addSubviews(label,
                 blueView, redView, greenView,
                 horizontalLine, verticalLine)

let viewRestraint = Restraint(view)
    .aligns([label], sides: [.left, .top])
    .aligns([horizontalLine], sides: .horizontal)
    .aligns([verticalLine], sides: .vertical)
    .vertical([label, horizontalLine, blueView, Space(8), redView, Space(16), greenView])
    .horizontal([blueView, redView, greenView, Space(20), verticalLine])
    .widths([blueView.width(200), redView.width(100), greenView.width(50), verticalLine.width(1)])
    .heights([blueView.height(200), redView.height(100), greenView.height(50), horizontalLine.height(1)])

viewRestraint.isActive = true
view.layoutIfNeeded()

let visibleView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
visibleView.backgroundColor = .blue
visibleView.addSubview(view)
visibleView.layoutIfNeeded()

PlaygroundPage.current.liveView = visibleView
