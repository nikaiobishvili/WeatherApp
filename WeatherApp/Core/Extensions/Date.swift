//
//  Date.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/20/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

extension Date {
    var milliseconds: Int64 {
        return Int64((timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    var millisecondsFromStartDay: Int64 {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // HH:mm:ss
        let today = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: today + " 00:00:00")!
        return Int64((newDate.timeIntervalSince1970 * 1000.0).rounded())
    }

    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
