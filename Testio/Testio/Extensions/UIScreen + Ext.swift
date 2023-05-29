//
//  UIScreen + Ext.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//

import Foundation
import UIKit

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}


extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
