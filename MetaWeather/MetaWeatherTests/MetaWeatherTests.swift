//
//
//  MetaWeatherTests.swift
//
//  Created by Tomasz Idzi on 05/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import XCTest
@testable import MetaWeather

class MetaWeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFormatt() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let date = formatter.date(from: "2021/03/05 09:30")
        let formattedDate = weatherDateFormatter.string(from: date!)
        XCTAssertTrue(formattedDate == "2021-03-05")
    }
    
    func testDateTomorrow() {
        let calendar: Calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.startOfDay(for: Date.tomorrow)
        XCTAssertTrue(calendar.dateComponents([.day], from: today, to: tomorrow).day! == 1)
    }
    
    func testWeatherParsingData() {
        let data = weatherData()
        XCTAssertTrue(data?.cityName == "Stockholm")
        XCTAssertTrue(data?.forecasts.count == 1)
        XCTAssertTrue(data?.forecasts.first?.id == 6053815544446976)
        if let forecatsDate = data?.forecasts.first?.date {
            XCTAssertTrue(weatherDateFormatter.string(from: forecatsDate) == weatherDateFormatter.string(from: Date.tomorrow))
        } else {
            XCTFail("Weather forecat date is nil.")
        }
        XCTAssertTrue(data?.forecasts.first?.weatherStateName == "Light Cloud")
        XCTAssertTrue(data?.forecasts.first?.maxTemp == 7.5)
        XCTAssertTrue(data?.forecasts.first?.weatherStateAbbr == "lc")
        XCTAssertTrue(data?.forecasts.first?.minTemp == 5.5749999999999993)
        XCTAssertTrue(data?.forecasts.first?.temp == 6.54)
    }
    
    func testForecastViewModel() {
        guard let weatherResponse = weatherData() else {
            XCTFail("Test fail during parsing weather response.")
            return
        }
        
        let viewModel = ForecastView.ViewModel(weather: weatherResponse)
        XCTAssertTrue(viewModel.cityName == "Stockholm")
        XCTAssertTrue(viewModel.weatherDescription == "Light Cloud")
        XCTAssertTrue(viewModel.temp == "7°")
        XCTAssertTrue(viewModel.minMaxTemp == "H: 8° L: 6°")
        XCTAssertTrue(viewModel.weatherCode == "lc")
    }
    
    func testForecastErrorViewModel() {
        let viewModel = ForecastView.ErrorViewModel(error: WeatherError.network(description: "Lost internet connection"))
        XCTAssertTrue(viewModel.error == "Lost internet connection")
    }
    
    func testForecastViewModelFail() {
        let weather = WeatherResponse(cityName: "Stockholm", forecasts: [])
        
        let viewModel = ForecastView.ViewModel(weather: weather)
        XCTAssertTrue(viewModel.cityName == "Stockholm")
        XCTAssertTrue(viewModel.weatherDescription == "")
        XCTAssertTrue(viewModel.temp == "")
        XCTAssertTrue(viewModel.minMaxTemp == "")
        XCTAssertTrue(viewModel.weatherCode == "")
    }
    
    func testForecastView() {
        guard let weatherResponse = weatherData() else {
            XCTFail("Test fail during parsing weather response.")
            return
        }
        
        let viewModel = ForecastView.ViewModel(weather: weatherResponse)
        
        let forecastView = ForecastView()
        forecastView.viewModel = viewModel
        
        XCTAssertTrue(forecastView.cityLabel.text == "Stockholm")
        XCTAssertTrue(forecastView.weatherDescriptionLabel.text == "Light Cloud")
        XCTAssertTrue(forecastView.tempLabel.text == "7°")
        XCTAssertTrue(forecastView.tempMinMaxLabel.text == "H: 8° L: 6°")
        XCTAssertNotNil(forecastView.iconImageView.image)
    }
    
    func testErrorForecastView() {
        let viewModel = ForecastView.ErrorViewModel(error: WeatherError.network(description: "Lost internet connection"))
        
        let forecastView = ForecastView()
        forecastView.errorViewModel = viewModel
        
        XCTAssertTrue(forecastView.cityLabel.text == "Lost internet connection")
        XCTAssertTrue(forecastView.weatherDescriptionLabel.text == "")
        XCTAssertTrue(forecastView.tempLabel.text == "")
        XCTAssertTrue(forecastView.tempMinMaxLabel.text == "")
        XCTAssertNil(forecastView.iconImageView.image)
    }
    
    func testWeatherError() {
        let parsingError = WeatherError.parsing(description: "Parsing error")
        XCTAssertTrue(parsingError.errorDescription == "Parsing error")
        
        let networkError = WeatherError.network(description: "Network error")
        XCTAssertTrue(networkError.errorDescription == "Network error")
    }

}

extension MetaWeatherTests {
    
    func weatherData() -> WeatherResponse? {
        var weatherResponse = [String: Any]()
        weatherResponse = [
            "title" : "Stockholm",
            "consolidated_weather" : [
                [
                    "id" : 6053815544446976,
                    "air_pressure" : 997.5,
                    "applicable_date" : weatherDateFormatter.string(from: Date.tomorrow),
                    "weather_state_name" : "Light Cloud",
                    "humidity" : 73,
                    "max_temp" : 7.5,
                    "wind_direction_compass" : "WSW",
                    "predictability" : 70,
                    "weather_state_abbr" : "lc",
                    "wind_direction" : 250.4997332413852,
                    "created" : "2021-03-05T17:25:04.278153Z",
                    "min_temp" : 5.5749999999999993,
                    "wind_speed" : 11.108770431116945,
                    "visibility" : 15.725351447546329,
                    "the_temp" : 6.54

        ]]]
        
        let weatherData = try? JSONSerialization.data(withJSONObject: weatherResponse, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(weatherDateFormatter)
        return try? decoder.decode(WeatherResponse.self, from: weatherData ?? Data())
    }
}
