//
//  Storyboard.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

enum Storyboard: String {

    case main = "Main"

    var uiStoryboard: UIStoryboard {
        return UIStoryboard(name: rawValue, bundle: nil)
    }

    func instantiateViewController<T>(_ type: T.Type = T.self) -> T where T: UIViewController {
        return uiStoryboard.instantiateViewController(type)
    }
    
    func instantiateViewController<T>(_ type: T.Type, _ customIdentifier: String? = nil) -> T where T: UIViewController {
        // swiftlint:disable force_cast
        return uiStoryboard.instantiateViewController(withIdentifier: customIdentifier ?? String(describing: type)) as! T
        // swiftlint:enable force_cast
    }

}
