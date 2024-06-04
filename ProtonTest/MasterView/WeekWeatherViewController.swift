//
//  WeekWeatherViewController.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit
import SnapKit

class WeekWeatherViewController: UIViewController {
    
    private struct Constants {
        static var title = "Forecast"
        static var segmentTitles = ["Upcoming", "Hottest"]
    }
    
    private let viewModel: WeekWeatherViewModel
    private var segmentControl: UISegmentedControl!
    private var tableView: UITableView!
    
    init(viewModel: WeekWeatherViewModel) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        title = Constants.title
        view.backgroundColor = .white
        viewModel.delegate = self
        
        segmentControl = UISegmentedControl(items: Constants.segmentTitles)
        segmentControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        
        view.addSubview(segmentControl)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherRowView.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        
        segmentControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getWeekData()
    }
    
    @objc
    private func segmentControl(_ segmentedControl: UISegmentedControl) {
//       switch (segmentedControl.selectedSegmentIndex) {
//          case 0:
//            print("Show upcoming")
//          break
//          case 1:
//           print("Show hottest")
//          break
//          default:
//          break
//       }
    }
}

extension WeekWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WeatherRowView else {
            return UITableViewCell()
        }
        
        cell.setTitle(day: viewModel.weekData[indexPath.row].day ?? "Day not found",
                      description: viewModel.weekData[indexPath.row].description)
        
        return cell
    }
}

extension WeekWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension WeekWeatherViewController: WeekWeatherViewModelDelegate {
    func didFetchWeekData(_ weekData: [DailyWeather]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailFetchWeekData() {
        
    }
}
