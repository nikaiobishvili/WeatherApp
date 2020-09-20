//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Nika Iobishvili on 9/19/20.
//  Copyright © 2020 Home. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

class ForecastViewController: UIViewController {

    struct WeatherByDay {
        let dayOfWeek: DayOfWeek
        let weatherData: [Forecast]
    }
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var datasource = [WeatherByDay]()
    
    var selectedDay: DayOfWeek? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = mainBgColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .clear
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib(nibName: "ForecastTableViewCell", bundle: nil), forCellReuseIdentifier: "ForecastTableViewCell")
        self.configureWeekDays()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.delegate = self
        LocationManager.shared.handleLocation(LocationManager.shared.lastLocation)
    }
    
    private func handleResponse(forecast: ForecastList) {
        var dayComponent = DateComponents()
        let theCalendar = Calendar.current
        for i in 0..<5 {
            dayComponent.day = i
            let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
            let day = DayOfWeek.day(from: nextDate!)
            let datesForDay = forecast.list.filter({ $0.getDay() == nextDate?.toString(dateFormat: "yyyy-MM-dd") })
            self.datasource.append(.init(dayOfWeek: day, weatherData: datesForDay))
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func getForecastByCity(_ city: String) {
        APIClient
        .shared.decodable(.forecastBy(city: city))
        .subscribe(onSuccess: { [weak self] (response: ForecastList) in
            self?.handleResponse(forecast: response)
            }, onError: {(error) in
                print(error)
        }).disposed(by: disposeBag)
    }
    
    private func configureWeekDays() {
        var dayComponent = DateComponents()
        let theCalendar = Calendar.current
        for i in 0..<5 {
            dayComponent.day = i
            let nextDate = theCalendar.date(byAdding: dayComponent, to: Date())
            let day = DayOfWeek.day(from: nextDate!)
            let name = i == 0 ? "TODAY" : String(describing: day).uppercased()
            addButton(with: name, tag: day.rawValue)
        }
        guard let button = stackView.subviews.first as? UIButton else { return }
        onDayTapped(button: button)
    }
    
    private func addButton(with title: String, tag: Int) {
        let button = UIButton()
        button.tag = tag
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(Color.primary.uiColor, for: .selected)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(onDayTapped(button:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }
    
    @objc private func onDayTapped(button: UIButton) {
        stackView.subviews.forEach({ ($0 as? UIButton)?.isSelected = false })
        button.isSelected = !button.isSelected
        self.selectedDay = DayOfWeek(rawValue: button.tag)
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func weatherObj() -> WeatherByDay? {
        return datasource.filter({ $0.dayOfWeek == self.selectedDay }).first
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        if let row = weatherObj()?.weatherData[indexPath.row] {
            cell.configure(with: row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherObj()?.weatherData.count ?? 0
    }
}

extension ForecastViewController: LocationManagerDelegate {
    func didChange(location: CLLocation, city: String, region: String) {
        DispatchQueue.main.async {
            self.getForecastByCity(city)
        }
    }
    
    func didChangeAuthorizationWith(status: CLAuthorizationStatus) {
        
    }
}
