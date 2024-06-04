//
//  WeatherDetailViewModel.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit

protocol WeatherDetailViewModelProviding {
    
    func getWeatherImage()

    var delegate: WeatherDetailViewModelDelegate? { get set }
    var viewTitle: String { get }
    var sunRiseTime: String { get }
    var sunSetTime: String { get }
    var highTemp: String { get }
    var lowTemp: String { get }
    var dailyWeather: DailyWeather { get set }
    var isDownloadButtonEnabled: Bool { get }
}

public protocol WeatherDetailViewModelDelegate: AnyObject {
    func didFetchImage(uiImage: UIImage)
    func fetchImageDidFail()
}

class WeatherDetailViewModel: WeatherDetailViewModelProviding {
    
    weak var delegate: WeatherDetailViewModelDelegate?
    var dailyWeather: DailyWeather
    var isDownloadButtonEnabled: Bool = true
    
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
    
    private let formatter = DateFormatter()
    private let interactor: NetworkManagerProviding
    
    init(dailyWeather: DailyWeather,
         interactor: NetworkManagerProviding = NetworkManager()) {
        self.dailyWeather = dailyWeather
        self.interactor = interactor
        // Date format style
        formatter.dateFormat = "h:mm a"
    }
    
    func getWeatherImage() {
        guard let url = URL(string: dailyWeather.image) else {
            return
        }
        interactor.getImage(fromURL: url) { [weak self] result in
            switch result {
            case .success(let image):
                self?.delegate?.didFetchImage(uiImage: image)
                self?.isDownloadButtonEnabled = false
            case .failure:
                self?.delegate?.fetchImageDidFail()
            }
        }
    }
}
