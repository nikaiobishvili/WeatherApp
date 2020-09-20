//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import CoreLocation
import RxCoreLocation
import RxCocoa
import RxSwift

protocol LocationManagerDelegate: class {
    func didChangeAuthorizationWith(status: CLAuthorizationStatus)
    func didChange(location: CLLocation, city: String, region: String)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()

    private let disposeBag = DisposeBag()

    private let manager = CLLocationManager()
    
    private let geoCoder = CLGeocoder()

    weak var delegate: LocationManagerDelegate?
    
    var lastLocation: CLLocation?
    
    var isAuthorized: Bool {
        return CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse)
    }
    
    var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50

        manager
            .rx
            .didChangeAuthorization
            .bind { (manager, status) in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    manager.startUpdatingLocation()
                default:
                    break
                }
            }.disposed(by: disposeBag)

        manager
            .rx
            .didUpdateLocations
            .bind { [unowned self] (_, locations) in
                self.lastLocation = locations.last
                self.handleLocation(locations.last)
            }.disposed(by: disposeBag)
    }
    
    func handleLocation(_ newLocation: CLLocation?) {
        guard let newLocation = newLocation else { return }
        geoCoder.reverseGeocodeLocation(newLocation) { (placemarks, error) in
            guard let currentLocPlacemark = placemarks?.first else { return }
            let city = currentLocPlacemark.locality ?? currentLocPlacemark.administrativeArea
            self.delegate?.didChange(
                location: newLocation,
                city: city ?? "Could not detect city",
                region: currentLocPlacemark.isoCountryCode ?? ""
            )
        }
        
    }

    func request() {
        manager.requestWhenInUseAuthorization()
    }

    func stop() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.delegate?.didChangeAuthorizationWith(status: status)
    }
    
    
}
