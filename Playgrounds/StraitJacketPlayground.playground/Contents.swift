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

let yellowView = UIView(frame: .zero)
yellowView.backgroundColor = .yellow

let redView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
redView.backgroundColor = .red

let greenView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
greenView.backgroundColor = .green

let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
blueView.backgroundColor = .blue

let view = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000))
view.backgroundColor = .white

let viewRestraint = Restraint(view)
    .addItems([label,
               blueView, redView, greenView,
               horizontalLine, yellowView])
    .aligns([label], sides: [.left, .top])
    .aligns([horizontalLine], sides: .horizontal)
    .aligns([yellowView], sides: [.left, .right, .bottom])
    .vertical([label, horizontalLine, blueView, Space(8), redView, Space(16), greenView, Space(32), yellowView])
    .horizontal([blueView, redView, greenView, Space(20)])
    .widths([blueView.width(200), redView.width(100), greenView.width(50)])
    .heights([blueView.height(200), redView.height(100), greenView.height(50), horizontalLine.height(1)])


viewRestraint.isActive = true

let visibleView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
visibleView.backgroundColor = .purple

Restraint(visibleView)
    .addItems([view])
    .aligns([view], sides: .all).isActive = true

PlaygroundPage.current.liveView = visibleView

let preview = visibleView