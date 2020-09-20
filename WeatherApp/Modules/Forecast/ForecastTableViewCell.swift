//
//  ForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/20/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblCelsius: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func configure(with forecast: Forecast) {
        let condition: WeatherCondition = forecast.weather[0].main
        
        self.lblCelsius.text = "\(Int(celsius(forecast.main.temp)))℃"
        
        self.lblCondition.text = condition.rawValue
        
        self.lblHour.text = forecast.hourString
        
        guard let url = URL(string: condition.imageUrl) else { return }
        
        downloadImage(from: url) {[weak self] (image) in
            DispatchQueue.main.async {
                self?.typeImageView.image = image
            }
        }
    }

    
    
}
