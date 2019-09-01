//
//  UIView+Layouts.swift
//  WzComponents
//
//  Created by William Huang on 21/8/19.
//

import UIKit

extension UIView {
    
    public func constraintWithVisualFormat(_ format: String, views: UIView..., options: NSLayoutFormatOptions = NSLayoutFormatOptions() ){
        var viewToDictionary = [String:UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewToDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options , metrics: nil, views: viewToDictionary))
    }
    
    @discardableResult
    public func constraintWith(size: CGSize = .zero , eqWidth: NSLayoutDimension? = nil, eqHeight: NSLayoutDimension? = nil, widthMultiplier: CGFloat = 1, heightMultiplier: CGFloat = 1, layoutType: LayoutDimensionType? = LayoutDimensionType.equal) -> [NSLayoutConstraint] {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var toActivatedConstraints = [NSLayoutConstraint]()
        
        if layoutType == LayoutDimensionType.greater {
            if size.width > 0 {
                toActivatedConstraints.append(widthAnchor.constraint(greaterThanOrEqualToConstant: size.width))
            }
            
            if size.height > 0 {
                toActivatedConstraints.append(heightAnchor.constraint(greaterThanOrEqualToConstant: size.height))
            }
            
            if let eqWidth = eqWidth {
                toActivatedConstraints.append(widthAnchor.constraint(greaterThanOrEqualTo: eqWidth, multiplier: widthMultiplier))
            }
            
            if let eqHeight = eqHeight {
                toActivatedConstraints.append(heightAnchor.constraint(greaterThanOrEqualTo: eqHeight, multiplier: widthMultiplier))
            }
            
        }else if layoutType == LayoutDimensionType.lesser {
            if size.width > 0 {
                toActivatedConstraints.append(widthAnchor.constraint(lessThanOrEqualToConstant: size.width))
            }
            
            if size.height > 0 {
                toActivatedConstraints.append(heightAnchor.constraint(lessThanOrEqualToConstant: size.height))
            }
            
            if let eqWidth = eqWidth {
                toActivatedConstraints.append(widthAnchor.constraint(lessThanOrEqualTo: eqWidth, multiplier: widthMultiplier))
            }
            
            if let eqHeight = eqHeight {
                toActivatedConstraints.append(heightAnchor.constraint(lessThanOrEqualTo: eqHeight, multiplier: widthMultiplier))
            }
        }else {
            if size.width > 0 {
                toActivatedConstraints.append(widthAnchor.constraint(equalToConstant: size.width))
            }
            
            if size.height > 0 {
                toActivatedConstraints.append(heightAnchor.constraint(equalToConstant: size.height))
            }
            
            if let eqWidth = eqWidth {
                toActivatedConstraints.append(widthAnchor.constraint(equalTo: eqWidth, multiplier: widthMultiplier))
            }
            
            if let eqHeight = eqHeight {
                toActivatedConstraints.append(heightAnchor.constraint(equalTo: eqHeight, multiplier: widthMultiplier))
            }
        }
        
        _ = toActivatedConstraints.forEach({$0.isActive = true})
        return toActivatedConstraints
        
    }
    
    @discardableResult
    public func constraintWith(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var toActivatedConstraints = [NSLayoutConstraint]()
        
        if let top = top {
            toActivatedConstraints.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let left = left {
            toActivatedConstraints.append(leftAnchor.constraint(equalTo: left, constant: padding.left))
        }
        
        if let bottom = bottom {
            toActivatedConstraints.append(bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom))
        }
        
        if let right = right {
            toActivatedConstraints.append(rightAnchor.constraint(equalTo: right, constant: -padding.right))
        }
        
        _ = toActivatedConstraints.forEach({$0.isActive = true})
        
        return toActivatedConstraints
        
    }
    
    public func constraintToFillSuperView(){
        if let superview = self.superview {
            self.constraintWith(superview.topAnchor, left: superview.leftAnchor, bottom: superview.bottomAnchor, right: superview.rightAnchor)
        }
    }
    
    public func constraintToFillSafeAreaLayout(){
        if #available(iOS 11.0, *){
            if let superview = self.superview?.safeAreaLayoutGuide{
                self.constraintWith(superview.topAnchor, left: superview.leftAnchor, bottom: superview.bottomAnchor, right: superview.rightAnchor)
            }
        }else{
            self.constraintToFillSuperView()
        }
    }
    
    public func constraintCenterX(_ centerX: NSLayoutXAxisAnchor? = nil, xConstant: CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let xAnchor = centerX {
            centerXAnchor.constraint(equalTo: xAnchor, constant: xConstant).isActive = true
        }else if let xAnchor = self.superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: xAnchor, constant: xConstant).isActive = true
        }
    }
    
    public func constraintCenterY(_ centerY: NSLayoutYAxisAnchor? = nil, yConstant: CGFloat = 0){
        self.translatesAutoresizingMaskIntoConstraints = false
        if let yAnchor = centerY {
            centerYAnchor.constraint(equalTo: yAnchor, constant: yConstant).isActive = true
        } else if let yAnchor = self.superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: yAnchor, constant: yConstant).isActive = true
        }
    }
    
    public func constraintCenterToSuperView() {
        self.constraintCenterX()
        self.constraintCenterY()
    }
    
    public func addTo(parentView: UIView){
        parentView.addSubview(self)
        self.constraintToFillSuperView()
    }
    
    public func removeSubViews(){
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
}

public enum LayoutDimensionType {
    case greater
    case equal
    case lesser
}

