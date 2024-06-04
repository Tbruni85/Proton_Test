//
//  Weather.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

struct DailyWeather: Decodable {
    
    private struct Constants {
        // Generate day considering Monday as first day of the week
        static var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        static func dayOfTheWeek(dayNumber: Int) -> String? {
            days.indices.contains(dayNumber - 1) ? days[dayNumber - 1] : nil
        }
    }
    
    let day, description: String
    let sunrise, sunset: Int
    let chanceRain: Double
    let high, low: Int
    let image: String
    
    // Generate Day name from the provided day number
    var dayOfTheWeek: String? {
        
        guard let dayNumber = Int(day) else {
            return nil
        }
        
        return Constants.dayOfTheWeek(dayNumber: dayNumber)
    }
}
