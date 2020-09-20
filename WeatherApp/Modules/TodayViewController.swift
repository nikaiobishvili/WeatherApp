//
//  TodayViewController.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class TodayViewController: UIViewController {
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblWeekDay: UILabel!
    @IBOutlet weak var lblCelsius: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblCompassDirection: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainBgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        
        self.lblWeekDay.text = dateFormatter.string(from: Date())
        
        LocationManager.shared.delegate = self
        LocationManager.shared.request()
    }
    
    private func handleResponse(weather: CurrentWeather) {
        DispatchQueue.main.async {
            let condition: WeatherCondition = weather.weather[0].main ?? .none
            self.lblCelsius.text = "\(Int(celsius(weather.main.temp)))℃ | \(condition.rawValue)"
            self.lblWind.text = String(format: "💨 %0.1f KM/H", weather.wind.speed)
            self.lblHumidity.text = "💧 \(weather.main.humidity)%"
            self.lblCompassDirection.text = "🔄 \(compassDirection(angle: weather.wind.deg))"
            guard let url = URL(string: condition.imageUrl) else { return }
            downloadImage(from: url) {[weak self] (image) in
                DispatchQueue.main.async {
                    self?.typeImageView.image = image
                }
            }
        }
    }
    
    private func getWeatherByCity(_ city: String) {
        APIClient
        .shared.decodable(.weatherBy(city: city))
        .subscribe(onSuccess: { [weak self] (response: CurrentWeather) in
            self?.handleResponse(weather: response)
            }, onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
}

extension TodayViewController: LocationManagerDelegate {
    func didChange(location: CLLocation, city: String, region: String) {
        DispatchQueue.main.async {
            self.lblCity.text = "\(city), \(region)"
            self.getWeatherByCity(city)
        }
    }
    
    func didChangeAuthorizationWith(status: CLAuthorizationStatus) {
        
    }
}
