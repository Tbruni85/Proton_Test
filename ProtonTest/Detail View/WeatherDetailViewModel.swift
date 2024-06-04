//
//  WeatherDetailViewModel.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

protocol WeatherDetailViewModelProviding {
    
    var viewTitle: String { get }
    var sunRiseTime: String { get }
    var sunSetTime: String { get }
    var highTemp: String { get }
    var lowTemp: String { get }
    var dailyWeather: DailyWeather { get set }
}

class WeatherDetailViewModel: WeatherDetailViewModelProviding {
    
    private let formatter = DateFormatter()
    var dailyWeather: DailyWeather
    
    var viewTitle: String {
        "Day \(dailyWeather.day)"
    }
    
    // Temp assumed to be in °C
    var highTemp: String {
        "\(dailyWeather.high) °C"
    }
    
    var lowTemp: String {
        "\(dailyWeather.low) °C"
    }
    
    var sunRiseTime: String {
        let hourString = formatter.string(from: Date(timeIntervalSince1970: Double(dailyWeather.sunrise)))
        return "\(hourString)"
    }
    
    var sunSetTime: String {
        let hourString = formatter.string(from: Date(timeIntervalSince1970: Double(dailyWeather.sunset)))
        return "\(hourString)"
    }
    
    init(dailyWeather: DailyWeather) {
        self.dailyWeather = dailyWeather
        // Date format style
        formatter.dateFormat = "h:mm a"
    }
}
