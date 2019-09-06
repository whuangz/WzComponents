//
//  WzPageControl.swift
//  WzComponents
//
//  Created by William Huang on 6/9/19.
//

import UIKit

@IBDesignable
class WzPageControl: UIControl {
    
    private var stackView: UIStackView!
    fileprivate var currentPageWidth: NSLayoutConstraint?
    fileprivate var pageWidth: NSLayoutConstraint?
    
    @IBInspectable var indicatorColor: UIColor? = .lightGray
    @IBInspectable var currentIndicatorColor: UIColor? = .darkGray
    
    @IBInspectable private var defaultSize =  CGSize(width: 8, height: 8)
    
    private var cornerRadius: CGFloat = 4
    
    @IBInspectable var noOfPages: Int = 0 {
        didSet{
            for tag in 0 ..< noOfPages {
                let dot = self.createDot()
                dot.tag = tag
                self.noOfDots.append(dot)
            }
            prepareUI()
        }
    }
    
    private var noOfDots = [UIView]()
    
    var currentPage: Int = 0 {
        didSet{
            let selectedDot = noOfDots[currentPage]
            
            _ = noOfDots.map { (dot) in
                setupCustomDotFor(dot)
                if dot.tag == selectedDot.tag {
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        dot.layer.cornerRadius = 2
                        dot.transform = CGAffineTransform.init(scaleX: 2, y: 1)
                        selectedDot.backgroundColor = self.currentIndicatorColor
                    })
                    
                }
            }
        }
    }
    
    
    //MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(indicatorColor: UIColor = .lightGray, currentIndicatorColor: UIColor = .darkGray, indicatorSize: CGSize? = nil, withRadius radius: CGFloat = 0) {
        self.init(frame: .zero)
        self.indicatorColor = indicatorColor
        self.currentIndicatorColor = currentIndicatorColor
        if let size = indicatorSize {
            self.defaultSize = size
            self.cornerRadius = radius == 0 ? size.height / 2 : radius
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension WzPageControl {
    
    fileprivate func prepareUI(){
        stackView = UIStackView.init(frame: self.bounds)
        
        for dot in self.noOfDots {
            stackView.addArrangedSubview(dot)
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        self.addSubview(stackView)
        stackView.constraintCenterX()
        stackView.constraintCenterY()
    }
    
    fileprivate func createDot() -> UIView {
        let dot = UIView()
        self.setupCustomDotFor(dot)
        dot.constraintWith(size: self.defaultSize)
        return dot
    }
    
    fileprivate func setupCustomDotFor(_ dot: UIView){
        dot.transform = .identity
        dot.layer.masksToBounds = true
        dot.layer.cornerRadius = self.cornerRadius
        dot.backgroundColor = indicatorColor
    }
}
