//
//  WeekWeatherViewModel.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

protocol WeekWeatherViewModelProviding {
    
    func getWeekData()
    func updateElementImage(model: DailyWeather)
    
    var delegate: WeekWeatherViewModelDelegate? { get set }
    var filterType: FiterType { get set }
    var displayData: [DailyWeather] { get }
    var weekData: [DailyWeather] { get set }
    var hottestDays: [DailyWeather] { get }
}

public protocol WeekWeatherViewModelDelegate: AnyObject {
    
    func didFetchWeekData(_ weekData: [DailyWeather])
    func didFailFetchWeekData()
    func dataUpdate()
}

enum FiterType {
    case all
    case hottest
}

class WeekWeatherViewModel: WeekWeatherViewModelProviding {
    
    public weak var delegate: WeekWeatherViewModelDelegate?
    
    public var weekData: [DailyWeather] = []
    public var filterType: FiterType = .all {
        willSet {
            if newValue == .all {
                displayData = weekData
            } else {
                displayData = hottestDays
            }
        }
    }
    public var displayData: [DailyWeather] = []
    // Hottest day sort and filter
    public var hottestDays: [DailyWeather] {
        weekData.sorted { $0.chanceRain > $1.chanceRain }.filter { $0.chanceRain < 0.5 }
    }
    
    private let interactor: NetworkManagerProviding
    
    init(interactor: NetworkManagerProviding = NetworkManager()) {
        self.interactor = interactor
    }
    
    func getWeekData() {
        guard let url = URL(string: "https://protonmail.github.io/proton-mobile-test/api/forecast") else {
            return
        }
        
        interactor.getData(fromURL: url) { [weak self] (result: Result<[DailyWeather], NetworkError>) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.weekData = data
                self.displayData = weekData
                delegate?.didFetchWeekData(self.weekData)
            case .failure(let error):
                print(error.localizedDescription)
                delegate?.didFailFetchWeekData()
            }
        }
    }
    
    func updateElementImage(model: DailyWeather) {
        if let index = weekData.firstIndex(where: {$0.day == model.day}) {
            weekData[index] = model
            displayData = weekData
            // re-set the filter type to update Hottest array
            filterType = filterType == .all ? .all : .hottest
            delegate?.dataUpdate()
        }
    }
}
