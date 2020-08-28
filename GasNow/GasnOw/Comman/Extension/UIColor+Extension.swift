//
//  UIColor+Extension.swift
//  Psychic Connections
//
//  Created by Mac PC 2 on 2/24/18.
//  Copyright © 2018 Office Mac. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    struct appcustomcolor {
        
        static var redcolor : UIColor  { return UIColor.init(red: 273/255, green: 73/255, blue: 38/255, alpha: 1.0) }
       
    }
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xFF) / 255,
            G: CGFloat((hex >> 08) & 0xFF) / 255,
            B: CGFloat((hex >> 00) & 0xFF) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    public convenience init?(hexToUIColor: String) {
           let r, g, b, a: CGFloat

           if hexToUIColor.hasPrefix("#") {
               let start = hexToUIColor.index(hexToUIColor.startIndex, offsetBy: 1)
               let hexColor = String(hexToUIColor[start...])

               if hexColor.count == 8 {
                   let scanner = Scanner(string: hexColor)
                   var hexNumber: UInt64 = 0

                   if scanner.scanHexInt64(&hexNumber) {
                       r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                       g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                       b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                       a = CGFloat(hexNumber & 0x000000ff) / 255

                       self.init(red: r, green: g, blue: b, alpha: a)
                       return
                   }
               }
           }

           return nil
       }
    
    
    func hexStringToUIColor (hexString:String) -> UIColor {
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

