//
//  WeatherDetailViewController.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    private struct Constants {
        static var forecastTitle = "Forecast"
    }
    
    private let viewModel: WeatherDetailViewModelProviding
    
    private var stackContainer = UIStackView()
    private var forecastDetail: DetailView!
    private var chanceOfRaintDetail: DetailView!
    private var highTempDetail: DetailView!
    private var lowTempDetail: DetailView!
    private var sunRiseDetail: DetailView!
    private var sunSetDetail: DetailView!
    private var imageView: UIImageView!
    
    init(viewModel: WeatherDetailViewModelProviding) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        title = viewModel.viewTitle
        edgesForExtendedLayout = []
        view.backgroundColor = .white
        
        stackContainer.axis = .vertical
        stackContainer.distribution = .fillProportionally
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.spacing = 10
        view.addSubview(stackContainer)
        
        forecastDetail = DetailView(title: "Forecast 🌡️:", descriptionText: viewModel.dailyWeather.description)
        stackContainer.addArrangedSubview(forecastDetail)
        
        highTempDetail = DetailView(title: "Highest 🥵:", descriptionText: viewModel.highTemp)
        stackContainer.addArrangedSubview(highTempDetail)
        
        lowTempDetail = DetailView(title: "Lowest ❄️:", descriptionText: viewModel.lowTemp)
        stackContainer.addArrangedSubview(lowTempDetail)
        
        sunRiseDetail = DetailView(title: "Sunrise 🌅:", descriptionText: viewModel.sunRiseTime)
        stackContainer.addArrangedSubview(sunRiseDetail)
        
        sunSetDetail = DetailView(title: "Sunset 🌛:", descriptionText: viewModel.sunSetTime)
        stackContainer.addArrangedSubview(sunSetDetail)
        
        chanceOfRaintDetail = DetailView(title: "Chance of rain  🌧️:", descriptionText: "\(viewModel.dailyWeather.chanceRain)%")
        stackContainer.addArrangedSubview(chanceOfRaintDetail)
    }
   
    private func setupConstraints() {
        stackContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
