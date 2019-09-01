//
//  WzBottomSheetController.swift
//  WzComponents
//
//  Created by William Huang on 1/9/19.
//

import UIKit
typealias Completion = ((_ status: Bool) -> ())

class WzBottomSheetController: UIViewController {
    fileprivate var bgView: UIView!
    fileprivate var sheetContainerView: UIView!
    fileprivate var sheetContentView: UIView!
    fileprivate var sheetNavigationView: WzSheetNavigationView!
    
    fileprivate var sheetContainerBottomConstraint: NSLayoutConstraint?
    fileprivate var sheetHeight: CGFloat = 0
    fileprivate var contentView: AnyObject?
    
    convenience init(view: AnyObject, bottomSheetHeight: CGFloat) {
        self.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .flipHorizontal
        
        self.sheetHeight = bottomSheetHeight
        self.contentView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = defaultBgColor()
        self.prepareUI()
        self.setupGestures()
        self.setupBottomSheet()
        self.setupInitialBottomSheet()
    }
    
    private func setupBottomSheet(){
        if let contentView = self.contentView{
            self.setViewWith(contentView)
        }
    }
    
    func setViewWith(_ anyView: AnyObject){
        self.cleanSheetContent()
        self.contentView = anyView;
        
        if anyView is UIViewController {
            if let vc = anyView as? UIViewController {
                self.sheetContentView.backgroundColor = vc.view.backgroundColor
                vc.view.addTo(parentView: self.sheetContentView)
                vc.didMove(toParentViewController: self)
            }
        }else if anyView is UIView {
            if let view = anyView as? UIView {
                self.sheetContentView.backgroundColor = view.backgroundColor
                view.addTo(parentView: self.sheetContentView)
            }
        }
    }
    
    
}

extension WzBottomSheetController {
    
    fileprivate func defaultBgColor(with opacity: CGFloat = 0) -> UIColor{
        return UIColor.init(white: 0.2, alpha: opacity)
    }
    
    fileprivate func prepareUI(){
        prepareView()
        prepareSheetView()
    }
    
    fileprivate func prepareView(){
        self.bgView = UIView()
        self.view.addSubview(self.bgView)
        self.bgView.constraintWith(self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor)
        self.bgView.backgroundColor = .clear
        
        self.sheetContainerView = UIView()
        self.view.addSubview(self.sheetContainerView)
        self.sheetContainerBottomConstraint = self.sheetContainerView.constraintWith(self.bgView.bottomAnchor, left: self.bgView.leftAnchor, bottom: self.view.bottomAnchor, right: self.bgView.rightAnchor)[2]
    }
    
    fileprivate func prepareSheetView(){
        self.sheetContentView = UIView()
        self.sheetContainerView.addSubview(self.sheetContentView)
        self.sheetContentView.constraintWith(left: self.sheetContainerView.leftAnchor, bottom: self.sheetContainerView.bottomAnchor, right: self.sheetContainerView.rightAnchor)
        self.sheetContentView.constraintWith(size: CGSize(width: -1, height: self.sheetHeight))
        
        self.sheetNavigationView = WzSheetNavigationView(frame: .zero, withRadius: 6)
        self.sheetContainerView.addSubview(self.sheetNavigationView)
        self.sheetNavigationView.constraintWith(size: CGSize(width: -1, height: 30))
        self.sheetNavigationView.constraintWith(self.sheetContainerView.topAnchor, left: self.sheetContainerView.leftAnchor, bottom: self.sheetContentView.topAnchor, right: self.sheetContainerView.rightAnchor)
        
    }
    
    private func cleanSheetContent(){
        if self.sheetContentView.subviews.count != 0 {
            self.sheetContentView.removeSubViews()
        }
    }
    
    func setupInitialBottomSheet(){
        self.sheetContainerBottomConstraint?.constant = self.getBottomSheetContainerHeight()
        self.perform(#selector(self.presentBottomSheet), with: nil, afterDelay: 0.1)
    }
    
    
    //MARK: Sheet Container Height
    private func safeArea() -> (top: CGFloat, bottom: CGFloat){
        if #available(iOS 11.0, *) {
            
            let window = UIApplication.shared.keyWindow
            let topPadding = (window?.safeAreaInsets.top) ?? 0
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            
            return (topPadding, bottomPadding)
        }
        return (0,0)
    }
    
    private func getBottomSheetContainerHeight() -> CGFloat{
        return self.sheetHeight + 30
    }
    
    private func getBottomSheetHeight() -> CGFloat {
        return abs(self.getBottomSheetContainerHeight()) + self.safeArea().bottom
    }
    
    
    //MARK: TAP GESTURE
    fileprivate func setupGestures(){
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(closeBottomSheet))
        self.bgView.addGestureRecognizer(dismissTap)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(recognizer:)))
        self.sheetContainerView.addGestureRecognizer(panGesture)
    }
    
    
    //MARK: TAP Gesture Action
    @objc func presentBottomSheet(){
        self.view.backgroundColor = defaultBgColor(with: 0.6)
        self.animateBottomSheet(withOrigin: 0, completion: nil)
    }
    
    
    @objc func closeBottomSheet(){
        self.animateBottomSheet(withOrigin: self.getBottomSheetContainerHeight()) { (status) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func panGestureAction(recognizer: UIPanGestureRecognizer){
        
        let translate = recognizer.translation(in: self.sheetContainerView)
        let containerHeight = self.getBottomSheetHeight() / 2
        let yDirection = translate.y
        
        switch recognizer.state {
        case .began:
            break
        case .changed:
            if yDirection > 0 {
                self.setBottomSheetContainerConstraint(yDirection)
            }
            break
        case .ended, .cancelled:
            if yDirection > containerHeight {
                self.closeBottomSheet()
            }else{
                self.presentBottomSheet()
            }
            break
        default:
            break
        }
    }
    
    private func animateBottomSheet(withOrigin origin: CGFloat, completion: Completion? = nil){
        UIView.animate(withDuration: 0.2, animations: {
            self.setBottomSheetContainerConstraint(origin)
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        }) { (status) in
            if (status){
                completion?(status)
            }
        }
    }
    
    private func setBottomSheetContainerConstraint(_ constant: CGFloat){
        self.sheetContainerBottomConstraint?.constant = constant
    }
    
}




class WzSheetNavigationView: UIView{
    
    private var bgRadius: CGFloat?
    
    init(frame: CGRect, withRadius radius: CGFloat){
        super.init(frame: frame)
        self.bgRadius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        self.backgroundColor = .white
        self.layer.mask = createHollowShape()
    }
    
    func createHollowShape() -> CAShapeLayer{
        let maskLayer = CAShapeLayer()
        let bgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners:[.topLeft, .topRight], cornerRadii: CGSize(width: bgRadius ?? 0, height: bgRadius ?? 0))
        
        let width: CGFloat = 60
        let bgViewSize: CGSize = self.bounds.size
        let hollowPath = UIBezierPath(roundedRect: CGRect(x: (bgViewSize.width - width ) / 2, y: (bgViewSize.height - 4) / 2, width: width, height: 4), cornerRadius: 2)
        
        bgPath.append(hollowPath)
        maskLayer.path = bgPath.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        return maskLayer
    }
}
