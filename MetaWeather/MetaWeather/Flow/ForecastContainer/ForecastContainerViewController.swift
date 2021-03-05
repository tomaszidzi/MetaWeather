//
//
//  ForecastContainerViewController.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import UIKit

class ForecastContainerViewController: UIViewController {

    // MARK: - Properties
    
    private let citiesDataSource: [CityModel] = [CityModel(name: "Gothenburg", code: "890869"),
                               CityModel(name: "Stockholm", code: "906057"),
                               CityModel(name: "Mountain View", code: "2455920"),
                               CityModel(name: "London", code: "44418"),
                               CityModel(name: "New York", code: "2459115"),
                               CityModel(name: "Berlin", code: "638242")]
    
    // MARK: - UI properties

    var _view: ForecastContainerView? {
        return view as? ForecastContainerView
    }
    
    // MARK: - VC life cycle
    
    override func loadView() {
        view = ForecastContainerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCitiesViewController()
    }

    // MARK: - Private funcs
    
    private func add(_ child: UIViewController) {
        addChild(child)
        _view?.addViewToStack(child.view)
        child.didMove(toParent: self)
    }

    private func setupCitiesViewController() {
        for city in citiesDataSource {
            add(ForecastViewController(city: city))
        }
        
        _view?.updatePageControl()
    }
}
