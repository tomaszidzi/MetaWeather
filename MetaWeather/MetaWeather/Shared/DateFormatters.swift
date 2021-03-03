//
//
//  DateFormatters.swift
//
//  Created by Tomasz Idzi on 03/03/2021
//  Copyright © 2021 Tomasz Idzi. All rights reserved.
//


import Foundation

let weatherDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
