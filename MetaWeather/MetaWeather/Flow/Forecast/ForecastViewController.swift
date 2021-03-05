//
//
//  ForecastViewController.swift
//
//  Created by Tomasz Idzi on 05/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import UIKit

class ForecastViewController: UIViewController {

    // MARK: - Properties
    private let city: CityModel

    // MARK: - UI properties

    var _view: ForecastView? {
        return view as? ForecastView
    }

    // MARK: - Initialization
    
    init(city: CityModel) {
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC life cycle
    
    override func loadView() {
        view = ForecastView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    // MARK: - Private
    
    private func makeRequests(with city: CityModel) {
        _view?.showActivityIndicator()
       
        WeatherManager(session: URLSession.shared).currentWeather(forCity: city) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self.updateInterface(with: weather)
                case .failure(let error):
                    self.updateInterfac(with: error)
                }
                self._view?.hideActivityIndicator()
            }
        }
    }
    
    private func refresh() {
        makeRequests(with: city)
    }
    
    private func updateInterface(with weather: WeatherResponse) {
        let viewModel = ForecastView.ViewModel(weather: weather)
        self._view?.viewModel = viewModel
    }
    
    private func updateInterfac(with error: Error) {
        let viewModel = ForecastView.ErrorViewModel(error: error)
        self._view?.errorViewModel = viewModel
    }
}
