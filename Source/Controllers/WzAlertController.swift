//
//  WzAlertController.swift
//  WzComponents
//
//  Created by William Huang on 22/8/19.
//

import UIKit

class WzAlertController: UIViewController {
    
    private var alertView: UIView!
    
    convenience init(alertView: UIView? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
        
        if let alertView = alertView {
            self.alertView = alertView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAlertView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .curveEaseIn, animations: {
            if let alertView = self.alertView {
                alertView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            }else{
                self.defaultAlert.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            }
            self.view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        }, completion: nil)
    }
    
    @objc func dismissAlert(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.dismiss(animated: false, completion: nil)
        }) { (completed) in
            //self.dismiss(animated: false, completion: nil)
        }
    }
    
    
    //MARK: SETUP DEFAULT VIEW
    
    private let defaultAlert: WzAlertView = {
        let alertView = WzAlertView()
        alertView.layer.cornerRadius = 12
        alertView.layer.masksToBounds = true
        return alertView
    }()
    
    
    func initialDefaultViewWith(noOfBtns: CGFloat? = 1, title: String? = "Hi Alert", leftBtnTitle: String? = "Cancel", rightBtnTitle: String? = "Ok", msg: String){
        self.defaultAlert.setupViewWith(noOfBtns: noOfBtns, title: title, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle, msg: msg)
    }
}

extension WzAlertController {
    
    fileprivate func setupAlertView(){
        if let alertView = self.alertView {
            self.view.addSubview(alertView)
            alertView.constraintCenterX()
            alertView.constraintCenterY(yConstant: -self.view.frame.size.height)
            alertView.constraintWith(size: CGSize(width: self.view.bounds.width * 0.8, height: -1))
        }else{
            self.view.addSubview(self.defaultAlert)
            self.defaultAlert.constraintCenterX()
            self.defaultAlert.constraintCenterY(yConstant: -self.view.frame.size.height)
            self.defaultAlert.constraintWith(size: CGSize(width: self.view.bounds.width * 0.8, height: -1))
        }
    }
    
    func setupAction(leftAction: Selector? = nil, rightAction: Selector? = nil){
        if let left = leftAction {
            self.defaultAlert.leftButton.addTarget(self, action: left, for: .touchUpInside)
        }else{
            self.defaultAlert.leftButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        }
        
        if let right = rightAction {
            self.defaultAlert.rightButton.addTarget(self, action: right, for: .touchUpInside)
        }
    }
    
}

class WzAlertView: UIView {
    
    let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .white
        lbl.textColor = .black
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.text = "Hi Alert"
        return lbl
    }()
    
    let leftButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.setTitle("Cancel", for: .normal)
        return btn
    }()
    
    let rightButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.setTitle("Ok", for: .normal)
        return btn
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let messageLabel: WInsetLbl = {
        let insetLbl = WInsetLbl(withInset: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        insetLbl.textAlignment = .center
        insetLbl.numberOfLines = 0
        insetLbl.backgroundColor = .white
        
        return insetLbl
    }()
    
    private func addSeparatorLineTo() -> UIView{
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = UIColor.groupTableViewBackground
        
        self.addSubview(seperatorLine)
        seperatorLine.constraintWith(size: CGSize(width: -1, height: 1))
        
        return seperatorLine
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewWith(noOfBtns: CGFloat? = 1, title: String? = "Hi Alert", leftBtnTitle: String? = "Cancel", rightBtnTitle: String? = "Ok", msg: String){
        self.titleLbl.text = title
        self.addSubview(self.titleLbl)
        self.titleLbl.constraintWith(self.topAnchor, left: self.leftAnchor, right: self.rightAnchor)
        self.titleLbl.constraintWith(size: CGSize(width: -1, height: 40))
        
        //Seperator Line
        addSeparatorLineTo().constraintWith(self.titleLbl.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor)
        
        self.addSubview(self.contentView)
        self.contentView.constraintWith(self.titleLbl.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, padding: UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0))
        self.contentView.constraintWith(size: CGSize(width: -1, height: 20), layoutType: .greater)
        
        
        self.setupContentView(noOfBtns: noOfBtns, leftBtnTitle: leftBtnTitle, rightBtnTitle: rightBtnTitle, msg: msg)
    }
    
    private func setupContentView(noOfBtns: CGFloat? = 1, leftBtnTitle: String? = "Cancel", rightBtnTitle: String? = "Ok", msg: String){
        
        self.messageLabel.text = msg;
        self.contentView.addSubview(self.messageLabel)
        self.messageLabel.constraintCenterToSuperView()
        
        
        switch noOfBtns {
        case 2:
            self.addSubview(self.leftButton)
            self.leftButton.constraintWith(self.contentView.bottomAnchor ,left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor , padding: UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0))
            self.leftButton.constraintWith(size: CGSize(width: -1, height: 30))
            self.leftButton.setTitle(leftBtnTitle, for: .normal)
            
            self.addSubview(self.rightButton)
            self.rightButton.constraintWith(self.leftButton.topAnchor ,left: self.leftButton.leftAnchor, bottom: self.leftButton.bottomAnchor, right: self.rightAnchor)
            self.rightButton.constraintWith(eqWidth: self.leftButton.widthAnchor, eqHeight: self.rightButton.heightAnchor)
            self.rightButton.setTitle(rightBtnTitle, for: .normal)
            
            break
        default:
            self.addSubview(self.leftButton)
            self.leftButton.constraintWith(self.contentView.bottomAnchor ,left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0))
            self.leftButton.constraintWith(size: CGSize(width: -1, height: 40))
            self.leftButton.setTitle("OK", for: .normal)
            
            break
        }
        
        //Seperator Line
        addSeparatorLineTo().constraintWith(self.leftButton.topAnchor, left: self.leftAnchor, right: self.rightAnchor)
    }
}


class WInsetLbl: UILabel {
    private var inset: UIEdgeInsets!
    
    init(withInset inset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.inset = inset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: inset.top, left: inset.left, bottom: inset.bottom, right: inset.right)
        super.drawText(in: self.bounds.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += inset.top + inset.bottom
        intrinsicSuperViewContentSize.width += inset.left + inset.right
        return intrinsicSuperViewContentSize
    }
}
