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
        static var horizontalPadding: CGFloat = 5
    }
    
    private var viewModel: WeatherDetailViewModelProviding
    
    private var stackContainer = UIStackView()
    private var scrollView = UIScrollView()
    private var forecastDetail: DetailView!
    private var chanceOfRaintDetail: DetailView!
    private var highTempDetail: DetailView!
    private var lowTempDetail: DetailView!
    private var sunRiseDetail: DetailView!
    private var sunSetDetail: DetailView!
    private var downloadButton = UIButton(type: .custom)
    private var imageView: UIImageView!
    
    init(viewModel: WeatherDetailViewModelProviding) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.delegate = self
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
    
        
        view.addSubview(scrollView)
        
        stackContainer.axis = .vertical
        stackContainer.distribution = .fillProportionally
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackContainer)
        
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
        
        downloadButton.setTitle("Download image", for: .normal)
        downloadButton.setTitleColor(.systemBlue, for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadImageTapped), for: .touchUpInside)
        downloadButton.isHidden = !viewModel.isDownloadButtonEnabled
        stackContainer.addArrangedSubview(downloadButton)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.addArrangedSubview(imageView)
    }
   
    private func setupConstraints() {
        scrollView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackContainer.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        imageView.snp.remakeConstraints { make in
            make.width.lessThanOrEqualTo(UIScreen.main.bounds.width - Constants.horizontalPadding * 2)
        }
    }
 
    @objc
    private func downloadImageTapped() {
        viewModel.getWeatherImage()
    }
}

extension WeatherDetailViewController: WeatherDetailViewModelDelegate {
    func didFetchImate(uiImage: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = uiImage
            self.downloadButton.isHidden = !self.viewModel.isDownloadButtonEnabled
            self.setupConstraints()
        }
    }
    
    func fetchImageDidFail() {
        self.downloadButton.isHidden = !self.viewModel.isDownloadButtonEnabled
        let alert = UIAlertController(title: "Error", message: "Unable to download image please retry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
