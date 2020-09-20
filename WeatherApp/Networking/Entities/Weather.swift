//
//  Weather.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeather: Codable {    
    let visibility: Double
    let wind: Wind
    let clouds: Clouds
    let sys: Sys
    let weather: [Weather]
    let main: Main
}

class Weather: Codable {
    let id: Int
    let main: WeatherCondition
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case description
        case main
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.main = (try? container.decode(WeatherCondition.self, forKey: .main)) ?? .none
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
    }
}

class Main: Codable {
    let temp: Double
    let pressure: Double
    let humidity: Double
    let temp_min: Double
    let temp_max: Double
}


class Wind: Codable {
    let speed: Double
    let deg: Double
}

class Clouds: Codable {
    let all: Int
}

class Sys: Codable {
    let sunrise: Int64
    let sunset: Int64
}

enum WeatherCondition: String, Codable {
    
    case Thunderstorm
    case Drizzle
    case Rain
    case Snow
    case Mist
    case Clear
    case Clouds
    case none
    
    private var imageUrlPrefix: String {
        switch self {
            case .Thunderstorm: return "11"
            case .Drizzle: return "09"
            case .Rain: return "10"
            case .Snow: return "13"
            case .Mist: return "50"
            case .Clear: return "01"
            case .Clouds: return "02"
        default:
            return "03"
        }
    }
    
    var imageUrl: String {
        let iconName = self.imageUrlPrefix
        let periodType = period == .day ? "d" : "n"
        return "\(Constants.Map.openWeatherIconBaseUrl.rawValue)\(iconName)\(periodType)@2x.png"
    }
}
