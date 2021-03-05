//
//
//  ForecastViewModel.swift
//
//  Created by Tomasz Idzi on 05/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import Foundation

extension ForecastView {
    
    struct ViewModel {
 
        let cityName: String
        
        let weatherDescription: String
        
        let temp: String
        
        let minMaxTemp: String
        
        let weatherCode: String
        
        init(weather: WeatherResponse) {
            self.cityName = weather.cityName
            
            guard let tomorrowForecast = weather.forecasts.first(where: {Calendar.current.isDate($0.date, equalTo: Date.tomorrow, toGranularity: .day)}) else {
                self.weatherDescription = ""
                self.temp = ""
                self.weatherCode = ""
                self.minMaxTemp = ""
                return
            }
            
            self.weatherDescription = tomorrowForecast.weatherStateName
            self.temp = String(format:"%.0f°", tomorrowForecast.temp)
            self.weatherCode = tomorrowForecast.weatherStateAbbr
            self.minMaxTemp = String(format:"H: %.0f° L: %.0f°", tomorrowForecast.maxTemp, tomorrowForecast.minTemp)
        }
    }
    
    struct ErrorViewModel {
        
        let error: String
        
        init(error: Error) {
            self.error = error.localizedDescription
        }
        
    }
    
}
