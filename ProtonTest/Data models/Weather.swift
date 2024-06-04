//
//  Weather.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

public struct DailyWeather: Decodable, Equatable {
    
    let day, description: String
    let sunrise, sunset: Int
    let chanceRain: Double
    let high, low: Int
    let image: String
}
