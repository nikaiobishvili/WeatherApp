//
//  Utils.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

enum DayPeriod {
    case day
    case night
}

func celsius(_ kelvin: Double) -> Double {
    return kelvin - Constants.Weather.kelvin.rawValue
}

var period: DayPeriod {
    let hour = Calendar.current.component(.hour, from: Date())
    switch hour {
    case 8..<20: return .day
    default: return .night
    }
}

var mainBgColor: UIColor {
    if period == .day { return UIColor(hex: "#1d4299") }
    return UIColor(hex: "#424242")
}

var mainTabbarViewBgColor: UIColor {
    if period == .day { return UIColor(hex: "#1D2199") }
    return UIColor(hex: "#1D213E")
}

func compassDirection(angle: Double) -> String {
    let directions = ["North", "North-West", "West", "South-West", "South", "South-East", "East", "North-East"]
    let newAngle = angle.truncatingRemainder(dividingBy: 360)
    let index = round(( newAngle < 0 ? angle + 360 : newAngle) / 45).truncatingRemainder(dividingBy: 8)
    return directions[Int(index)]
}

func downloadImage(from url: URL, completion: @escaping(UIImage?) -> Void) {
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else {
            completion(nil)
            return
        }
        DispatchQueue.main.async() {
            completion(UIImage(data: data))
        }
    }
}

func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

enum DayOfWeek: Int, CaseIterable {
    case sun = 1
    case mon = 2
    case tue = 3
    case wen = 4
    case thu = 5
    case fri = 6
    case sat = 7

    static func day(from date: Date) -> DayOfWeek {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "e"
        let dayNumber: Int = Int(formatter.string(from: date))!
        return DayOfWeek(rawValue: dayNumber) ?? .sun
    }
}
