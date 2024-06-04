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
    
    private var viewModel: WeekWeatherViewModelProviding
    private var router: RouterProviding
    private var segmentControl: UISegmentedControl!
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    init(viewModel: WeekWeatherViewModelProviding = WeekWeatherViewModel(),
         router: RouterProviding = Router()) {
        
        self.viewModel = viewModel
        self.router = router
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
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherRowView.self, forCellReuseIdentifier: "cell")
        tableView.addSubview(refreshControl)
        
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
        switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            viewModel.filterType = .all
            tableView.reloadData()
            break
        case 1:
            viewModel.filterType = .hottest
            tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @objc
    private func refreshView() {
        viewModel.getWeekData()
    }
}

extension WeekWeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.displayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WeatherRowView else {
            return UITableViewCell()
        }
        
        cell.setTitle(day: viewModel.displayData[indexPath.row].day,
                      description: viewModel.displayData[indexPath.row].description)
        
        if let data = viewModel.displayData[indexPath.row].imageData, let image = UIImage(data: data) {
            cell.updateImage(image)
        }
        
        return cell
    }
}

extension WeekWeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushDetailView(model: viewModel.displayData[indexPath.row], index: indexPath.row)
    }
}

extension WeekWeatherViewController: WeekWeatherViewModelDelegate {
    func didFetchWeekData(_ weekData: [DailyWeather]) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func didFailFetchWeekData() {
        let alert = UIAlertController(title: "Message", message: "We couldn't retrieve the data, please pull to retry", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dataUpdate() {
        self.tableView.reloadData()
    }
}

extension WeekWeatherViewController {
    
    private func pushDetailView(model: DailyWeather, index: Int) {
        
        let vc = router.generateViewForRoute(.detail(model))
        if let vcDetail = vc as? WeatherDetailViewController {
            vcDetail.delegate = self
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WeekWeatherViewController: WeatherDetailViewControllerDelegate {
    func didFetchImage(_ model: DailyWeather) {
        viewModel.updateElementImage(model: model)
    }
}
