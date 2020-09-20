//
//  Forecast.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/20/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

class ForecastList: Codable {
    let list: [Forecast]
}

class Forecast: Codable {
    let dt: Int64
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt_txt: String

    var hourString: String {
        let date = Date(milliseconds: dt * 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }

    func getDay() -> String {
        return Date(milliseconds: dt * 1000).toString(dateFormat: "yyyy-MM-dd")
    }
}
