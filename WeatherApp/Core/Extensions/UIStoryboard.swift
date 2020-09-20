//
//  Storyboard.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T>(_ type: T.Type = T.self) -> T where T: UIViewController {
        // swiftlint:disable force_cast
        return instantiateViewController(withIdentifier: String(describing: type)) as! T
        // swiftlint:enable force_cast
    }
    
}
