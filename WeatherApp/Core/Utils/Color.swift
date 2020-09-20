//
//  Color.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit

enum Color: String {

    case primary = "#FF4500"
    case secondary = "#51E9B8"
    case black = "#0D0D0C"
    case danger = "#FC615F"
    case lightBlue = "#51E0E9"
    case lightBlue2 = "#51CEE9"

    var uiColor: UIColor {
        return UIColor(rgb: rawValue)
    }

    var cgColor: CGColor {
        return uiColor.cgColor
    }

    var uiImage: UIImage? {
        return UIImage.createImage(withColor: uiColor)
    }

    func uiColorWithAlpha(_ alpha: CGFloat) -> UIColor {
        return UIColor(rgb: rawValue, alpha: alpha)
    }
    
}


