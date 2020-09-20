//
//  ApiResource.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

enum APIResource {
    
    // AUTH
    case weatherBy(city: String)
    case forecastBy(city: String)
    
    static var clientTimeToken: Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000.0)
    }
    
    var request: (method: HTTPMethod, path: String, headers: HTTPHeaders, parameters: HTTPParameters) {
        switch self {
            case .weatherBy(let city):
                return (.get, "weather", [:], ["q": city, "appid": Constants.Map.openWeatherApiKey.rawValue])
            case .forecastBy(let city):
                return (.get, "forecast", [:], ["q": city, "appid": Constants.Map.openWeatherApiKey.rawValue])
        }
    }
    
    var cachePolicy: NSURLRequest.CachePolicy {
        switch self {
        default:
            //return NSURLRequest.CachePolicy.returnCacheDataElseLoad
            return NSURLRequest.CachePolicy.useProtocolCachePolicy
        }
    }
    
}

extension APIResource: CustomStringConvertible {
    
    var description: String {
        let (method, path, _, params) = request
        return "Method = \(method), Path = \(path), Params = \(params)"
    }
    
}
