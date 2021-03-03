//
//
//  WeatherManager.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import UIKit

class WeatherManager {
  
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

// MARK: - MetaWeather API

private extension WeatherManager {
    
    struct MetaWeatherAPI {
        static let scheme = "https"
        static let host = "www.metaweather.com"
        static let path = "/api"
    }
    
    func getForecast(forCity city: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = MetaWeatherAPI.scheme
        components.host = MetaWeatherAPI.host
        components.path = MetaWeatherAPI.path + "/location/\(city)"
        return components
    }
}

extension WeatherManager {
 
    func currentWeather(forCity city: CityModel, completion : @escaping (Result<WeatherResponse, Error>) -> Void) {
        weather(with: getForecast(forCity: city.code), completion: completion)
    }
    
    private func weather<T>(with components: URLComponents, completion : @escaping (Result<T, Error>) -> ()) where T: Decodable {
        guard let url = components.url else {
            return completion(.failure(WeatherError.network(description: "Invalid URL.")))
        }
        
        session.dataTask(with: url) { data, _, error in
            if let data = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .formatted(weatherDateFormatter)
                do {
                    let dataObject = try jsonDecoder.decode(T.self, from: data)
                    completion(.success(dataObject))
                } catch {
                    completion(.failure(WeatherError.parsing(description: "Parsing error.")))
                }
                
            } else {
                completion(.failure(WeatherError.network(description: "Wrong data in response.")))
            }
        }.resume()
    }
    
}

// MARK: - MetaWeather API Image

class ImageStore: NSObject {
    
    static let imageCache = NSCache<NSString, UIImage>()
}

private extension WeatherManager {
    
    struct MetaWeatherImageAPI {
        static let scheme = "https"
        static let host = "www.metaweather.com"
        static let path = "/static"
    }
    
    func getWeatherImage(_ weatherCode: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = MetaWeatherImageAPI.scheme
        components.host = MetaWeatherImageAPI.host
        components.path = MetaWeatherImageAPI.path + "/img/weather/png/64/\(weatherCode).png"
        
        return components
    }
}

extension WeatherManager {
    
    func getWeatherImage(_ weatherCode: String, completion : @escaping (UIImage?) -> Void) {
        image(with: getWeatherImage(weatherCode), completion: completion)
    }
    
    private func image(with components: URLComponents, completion : @escaping (UIImage?) -> ()) {
     
        guard let url = components.url else {
            return completion(nil)
        }
        
        let urlToString = url.absoluteString as NSString
        
        if let cachedImage = ImageStore.imageCache.object(forKey: urlToString) {
            completion(cachedImage)
        } else if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            ImageStore.imageCache.setObject(image, forKey: urlToString)
            completion(image)
        } else {
            completion(nil)
        }
    }
}

