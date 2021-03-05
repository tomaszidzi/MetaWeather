//
//
//  WeatherError.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import Foundation

enum WeatherError: Error {
  case parsing(description: String)
  case network(description: String)
}

extension WeatherError {
   
    public var errorDescription: String? {
        switch self {
        case .parsing(let description):
            return description
        case .network(let description):
            return description
        }
    }
}
