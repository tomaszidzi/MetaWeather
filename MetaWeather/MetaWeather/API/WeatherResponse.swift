//
//
//  WeatherResponse.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import Foundation

struct WeatherResponse: Codable {
    
    let cityName: String
    let forecasts: [WeatherDetail]
    
    enum CodingKeys: String, CodingKey {
        case cityName = "title"
        case forecasts = "consolidated_weather"
    }
}

extension WeatherResponse {
    
    struct WeatherDetail: Codable {
        
        let id: Int
        let date: Date
        let weatherStateName: String
        let maxTemp: Double
        let weatherStateAbbr: String
        let minTemp: Double
        let temp: Double
                
        enum CodingKeys: String, CodingKey {
            case id
            case date = "applicable_date"
            case weatherStateName = "weather_state_name"
            case maxTemp = "max_temp"
            case weatherStateAbbr = "weather_state_abbr"
            case minTemp = "min_temp"
            case temp = "the_temp"
            
        }
    }
}
