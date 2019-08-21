//
//  UIColor+Helpers.swift
//  WzComponents
//
//  Created by William Huang on 21/8/19.
//

import UIKit

extension UIColor {
    static public func colorForHexString(hex: String) -> UIColor {
        var rgbValue = UInt64(0)
        let scanner = Scanner(string: hex)
        
        if scanner.scanHexInt64(&rgbValue) {
            
            let redValue = CGFloat((rgbValue & 0xFF0000) >> 16)/255
            let blueValue = CGFloat((rgbValue & 0xFF00) >> 8)/255
            let greenValue = CGFloat((rgbValue & 0xFF))/255
            
            return UIColor(red: redValue, green: blueValue, blue: greenValue, alpha: 1)
        }
        
        return UIColor()
    }
}
