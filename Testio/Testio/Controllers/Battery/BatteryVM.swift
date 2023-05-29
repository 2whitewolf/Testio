//
//  BatteryVM.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 29.05.2023.
//
import Foundation
import RxSwift
import RxCocoa
import RxRelay
import UIKit
import DeviceKit


class BatteryViewModel {
    struct Input {
        let viewWillAppearTrigger: Driver<Void>
    }
    struct Output {
//        let batteryCapacity: Driver<BatteryInfo>
        let batteryStatus: Driver<BatteryInfo>
        let voltage: Driver<BatteryInfo>
        let level: Driver<BatteryInfo>
        
    }
    
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let device = Device.current
        
        
        let level = Driver.just(BatteryInfo(title: "Battery Level", description: "\(device.batteryLevel!)"))
        let charging = Driver.just(BatteryInfo(title: "Battery Status", description: "Plugged in".uppercased()))
        
        let voltage = Driver.just(BatteryInfo(title: "Battery Voltage", description: "3.7 V"))
        
        return Output(batteryStatus: charging, voltage: voltage, level: level)
    }
}
        
        
        
