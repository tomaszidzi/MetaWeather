//
//
//  Date+Days.swift
//
//  Created by Tomasz Idzi on 05/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import Foundation

extension Date {
    
    static var tomorrow:  Date { return Date().dayAfter }
 
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}
