//
//  UIImage.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

extension UIImage {

    static func createImage(withColor color: UIColor, ofSize size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)

        color.setFill()
        UIRectFill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

    static func createImage(withGradientLayer layer: CAGradientLayer) -> UIImage? {
        var image: UIImage?

        UIGraphicsBeginImageContext(layer.bounds.size)

        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }

        UIGraphicsEndImageContext()

        return image
    }
    
}
