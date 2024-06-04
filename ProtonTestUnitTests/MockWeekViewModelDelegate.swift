//
//  MockWeekViewModelDelegate.swift
//  ProtonTestUnitTests
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation
import XCTest
@testable import ProtonTest

class MockWeekViewModelDelegate: WeekWeatherViewModelDelegate {
    
    var didFetchWeekDataCount: Int = 0
    var didFailFetchWeekDataCount: Int = 0
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }
    
    func expectCounterChange() {
        expectation = testCase.expectation(description: "expect change in counter")
    }
    
    func didFetchWeekData(_ weekData: [ProtonTest.DailyWeather]) {
        
        if expectation != nil {
            didFetchWeekDataCount += 1
        }
        expectation?.fulfill()
        expectation = nil
    }
    
    func didFailFetchWeekData() {
        if expectation != nil {
            didFailFetchWeekDataCount += 1
        }
        expectation?.fulfill()
        expectation = nil
        
    }
}
