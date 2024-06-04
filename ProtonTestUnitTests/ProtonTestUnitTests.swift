//
//  ProtonTestUnitTests.swift
//  ProtonTestUnitTests
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import XCTest
@testable import ProtonTest

final class WeekWeatherViewModelTests: XCTestCase {
    
    var viewModel: WeekWeatherViewModelProviding!
    var mockInteractor: MockNetworkManager!
    var mockDelegate: MockWeekViewModelDelegate!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockNetworkManager()
        viewModel = WeekWeatherViewModel(interactor: mockInteractor)
        mockDelegate = MockWeekViewModelDelegate(testCase: self)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        mockInteractor = nil
        viewModel = nil
    }
    
    func test_getData_success() throws {
        mockDelegate.expectCounterChange()
        
        viewModel.getWeekData()
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(viewModel.displayData)
        
        let result = try XCTUnwrap(mockDelegate.didFetchWeekDataCount)
        XCTAssertEqual(result, 1)
    }
    
    func test_getData_failure() throws {
        mockInteractor.isFailing = true
        mockDelegate.expectCounterChange()
        
        viewModel.getWeekData()
        
        waitForExpectations(timeout: 1)
        
        let result = try XCTUnwrap(mockDelegate.didFailFetchWeekDataCount)
        XCTAssertEqual(result, 1)
    }
    
    func test_data_filtering_allWeek() throws {
        let data = Bundle.main.decode([DailyWeather].self, from: "MockData.json")
        viewModel.weekData = data
        
        viewModel.filterType = .all
        
        XCTAssertTrue(viewModel.weekData == viewModel.displayData)
    }
    
    func test_data_filtering_hottest() throws {
        let data = Bundle.main.decode([DailyWeather].self, from: "MockData.json")
        let expectedOutput =  data.sorted { $0.chanceRain > $1.chanceRain }.filter { $0.chanceRain < 0.5 }
        viewModel.weekData = data
        
        viewModel.filterType = .hottest
        
        XCTAssertTrue(viewModel.displayData == expectedOutput)
    }
}
