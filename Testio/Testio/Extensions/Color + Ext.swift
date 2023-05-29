//
//  Color + Ext.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//

import Foundation
import UIKit
extension UIColor {
    
    
    static var appBlue: UIColor {
        return UIColor(hex: "#5D9EFD")
    }
    
  convenience init(hex: String) {
    var stringHex = hex
    if stringHex.contains("#") { stringHex.removeAll(where: {$0 == "#"}) }
    guard let hex = Int(stringHex, radix: 16) else {
      self.init(red: 0, green: 0, blue: 0, alpha: 1)
      return
    }
    
    let red = ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0
    let green = ((CGFloat)((hex & 0x00FF00) >> 8)) / 255.0
    let blue = ((CGFloat)((hex & 0x0000FF) >> 0)) / 255.0
    self.init(displayP3Red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  static func hex(_ hex: String, alpha: CGFloat = 1.0) -> UIColor {
    guard let hex = Int(hex, radix: 16) else { return UIColor.clear }
    return UIColor(red: ((CGFloat)((hex & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((hex & 0x00FF00) >> 8)) / 255.0,
                   blue: ((CGFloat)((hex & 0x0000FF) >> 0)) / 255.0,
                   alpha: alpha)
  }
  
  
 
}
