//
//  Connection.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//

import UIKit
import CoreBluetooth
import Reachability
import CoreLocation

class Connection: NSObject {
    static let `default` = Connection()
    
    private var cbManager: CBCentralManager?
    private var reachability: Reachability!
    private let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        return $0
    }(CLLocationManager())
    private let locationDelegate = LocationDelegate()
    
    
    private var bluetoothHandle: Sound.TestFinale?
    
    func testBluetooth(completion: Sound.TestFinale?) {
        cbManager = CBCentralManager(delegate: self, queue: .main)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            completion?(false, nil)
        }
        
        bluetoothHandle = { (value, _) in
            timer.invalidate()
            completion?(value, nil)
        }
    }
    
    func testWiFi(completion: Sound.TestFinale?) {
        do {
            reachability = try Reachability()
            reachability.whenReachable = { [weak self] _ in
                completion?(true, nil)
                self?.reachability.stopNotifier()
            }
            
            reachability.whenUnreachable = { [weak self] _ in
                completion?(false, nil)
                self?.reachability.stopNotifier()
            }
            try reachability.startNotifier()
        } catch {
            completion?(false, nil)
        }
    }
    
    func testGPS(completion: Sound.TestFinale?) {
        let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            completion?(false, nil)
        }
        
        locationManager.delegate = locationDelegate
        
        locationDelegate.locationCallback = { [weak self] location in
            timer.invalidate()
            self?.locationManager.delegate = nil
            completion?(true, nil)
        }
    }
}

extension Connection: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        bluetoothHandle?(central.state == .poweredOn, nil)
    }
}

class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var locationCallback: ((CLLocation) -> ())? = nil
    var headingCallback: ((CLLocationDirection) -> ())? = nil
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ Error while updating location " + error.localizedDescription)
    }
}
