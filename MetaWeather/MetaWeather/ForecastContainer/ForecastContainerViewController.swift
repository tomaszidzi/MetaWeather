//
//
//  ForecastContainerViewController.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import UIKit

class ForecastContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let city = CityModel(name: "Gothenburg", code: "890869")
        
        WeatherManager(session: URLSession.shared).currentWeather(forCity: city) { result in
            DispatchQueue.main.async {
                // TODO: Handle response
//                switch result {
//                case .success(let weather):
//                    // TODO: Display weather on UI
//                case .failure(let error):
//                    // TODO: Display error message
//                }
            }
        }
    }
}
