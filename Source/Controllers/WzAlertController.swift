//
//  WzAlertController.swift
//  WzComponents
//
//  Created by William Huang on 22/8/19.
//

import UIKit

open class WzAlertController: UIViewController {
    
    var alertView: UIView?
    
    init(frame: CGRect, alertView: UIView) {
        self.alertView = alertView
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.constructAlertView()
    }
    
    func constructAlertView(){
        
    }
    
}
