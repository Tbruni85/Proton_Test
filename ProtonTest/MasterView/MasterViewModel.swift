//
//  MasterViewModel.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

public protocol MasterViewModelDelegate: AnyObject {
    
    func didFetchWeekData(_ weekData: [DailyWeather])
    func didFailFetchWeekData()
}

class MasterViewModel {
    
    public weak var delegate: MasterViewModelDelegate?
    
    private var weekData: [DailyWeather] = []
    private let interactor: NetworkManagerProviding
    
    init(interactor: NetworkManagerProviding) {
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
                delegate?.didFetchWeekData(self.weekData)
            case .failure(let error):
                print(error.localizedDescription)
                delegate?.didFailFetchWeekData()
            }
        }
    }
}
