//
//  TestsEnum.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 26.05.2023.
//

import Foundation
import UIKit

enum Test: String{
    case  Microphone, Vibration, GPS, LCD
    var name : String {
        switch self {
        case .Microphone:
            return "Microphone"
        case .LCD:
            return "LCD"
        case .Vibration:
            return "Vibration"
        case .GPS:
            return "GPS"
            
        }
    }
    
    var imageOn : String {
        switch self {
        case .Microphone:
            return "\(self.name.lowercased())On"
        case .LCD:
            return "\(self.name.lowercased())On"
        case .Vibration:
            return "\(self.name.lowercased())On"
        case .GPS:
            return "\(self.name.lowercased())On"
        }
    }
    
    var imageOff : String {
        switch self {
        case .Microphone:
            return "\(self.name.lowercased())Off"
        case .LCD:
            return "\(self.name.lowercased())Off"
        case .Vibration:
            return "\(self.name.lowercased())Off"
        case .GPS:
            return "\(self.name.lowercased())Off"
        }
    }
    
    var descritpion : String {
        switch self {
        case .Microphone:
            return "Please say “Hello” to check your Microphone"
        case .LCD:
            return "Check if there are any dead pixels on the folowing 5 colour screens"
        case .Vibration:
            return "Is the device vibrating ?"
        case .GPS:
            return "Please turn on location services"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .Microphone:
            return UIImage(named: "\(self.name.lowercased())")
        case .LCD:
            return UIImage(named: "\(self.name.lowercased())")
        case .Vibration:
            return UIImage(named: "\(self.name.lowercased())")
        case .GPS:
            return UIImage(named: "\(self.name.lowercased())")
        }
    }
}
