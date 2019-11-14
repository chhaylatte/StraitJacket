//
//  RestraintProxy.swift
//  StraitJacket
//
//  Created by Danny Chhay on 11/13/19.
//  Copyright © 2019 Danny Chhay. All rights reserved.
//

import Foundation

public class RestraintProxy: RestraintTargetable {
    public enum YAnchor {
        case top
        case centerY
        case bottom
        case firstBaseline
        case lastBaseline
    }
    
    public enum XAnchor {
        case leading
        case centerX
        case trailing
    }
    
    internal let proxiedView: UIView
    
    // MARK: - RestraintTargetable
    
    public var bottomAnchor: NSLayoutYAxisAnchor
    public var centerXAnchor: NSLayoutXAxisAnchor
    public var centerYAnchor: NSLayoutYAxisAnchor
    public var heightAnchor: NSLayoutDimension
    public var leadingAnchor: NSLayoutXAxisAnchor
    public var leftAnchor: NSLayoutXAxisAnchor
    public var rightAnchor: NSLayoutXAxisAnchor
    public var topAnchor: NSLayoutYAxisAnchor
    public var trailingAnchor: NSLayoutXAxisAnchor
    public var widthAnchor: NSLayoutDimension
    
    public func addToRootView(_ view: UIView) {
        proxiedView.addToRootView(view)
    }
    
    // MARK: - Initialization
    
    public init(view: UIView) {
        proxiedView = view
        bottomAnchor = view.bottomAnchor
        centerXAnchor = view.centerXAnchor
        centerYAnchor = view.centerYAnchor
        heightAnchor = view.heightAnchor
        leadingAnchor = view.leadingAnchor
        leftAnchor = view.leftAnchor
        rightAnchor = view.rightAnchor
        topAnchor = view.topAnchor
        trailingAnchor = view.trailingAnchor
        widthAnchor = view.widthAnchor
    }
    
    // MARK: - Private Methods
    
    private func proxiedAnchor(for anchor: YAnchor)  -> NSLayoutYAxisAnchor {
        switch anchor {
        case .top:
            return proxiedView.topAnchor
        case .centerY:
            return proxiedView.centerYAnchor
        case .bottom:
            return proxiedView.bottomAnchor
        case .firstBaseline:
            return proxiedView.firstBaselineAnchor
        case .lastBaseline:
            return proxiedView.lastBaselineAnchor
        }
    }
    
    private func proxiedAnchor(for anchor: XAnchor)  -> NSLayoutXAxisAnchor {
        switch anchor {
        case .leading:
            return proxiedView.leadingAnchor
        case .centerX:
            return proxiedView.centerXAnchor
        case .trailing:
            return proxiedView.trailingAnchor
        }
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    public func top(is replacementAnchor: YAnchor) -> RestraintProxy {
        topAnchor = proxiedAnchor(for: replacementAnchor)
        
        return self
    }
    
    @discardableResult
    public func bottom(is replacementAnchor: YAnchor) -> RestraintProxy {
        bottomAnchor = proxiedAnchor(for: replacementAnchor)
        
        return self
    }
    
    @discardableResult
    public func leading(is replacementAnchor: XAnchor) -> RestraintProxy {
        leadingAnchor = proxiedAnchor(for: replacementAnchor)
        
        return self
    }
    
    @discardableResult
    public func trailing(is replacementAncrhor: XAnchor) -> RestraintProxy {
        trailingAnchor = proxiedAnchor(for: replacementAncrhor)
        
        return self
    }
}
