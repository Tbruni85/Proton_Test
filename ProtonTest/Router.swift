//
//  Router.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit

enum Route {
    case detail(DailyWeather)
}

protocol RouterProviding {
    func generateViewForRoute(_ route: Route) -> UIViewController
}

class Router: RouterProviding {
    
    func generateViewForRoute(_ route: Route) -> UIViewController {
        switch route {
        case .detail(let dailyWeather):
            let viewModel = WeatherDetailViewModel(dailyWeather: dailyWeather)
            return WeatherDetailViewController(viewModel: viewModel)
        }
    }
}
