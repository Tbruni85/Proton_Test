//
//  MockNetworkManager.swift
//  ProtonTestUnitTests
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit
@testable import ProtonTest

class MockNetworkManager: NetworkManagerProviding {
    
    var isFailing: Bool = false
    
    func getData<T>(fromURL url: URL, completion: @escaping (Result<T, ProtonTest.NetworkError>) -> Void) where T : Decodable {
        if isFailing {
            completion(.failure(.badResponse))
        } else {
            completion(.success(Bundle.main.decode(T.self, from: "MockData.json")))
        }
        
    }
    
    func getImage(fromURL url: URL, completion: @escaping (Result<UIImage, ProtonTest.NetworkError>) -> Void) {
        
    }
}
