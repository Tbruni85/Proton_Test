//
//  NetworkManager.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case badResponse
    case unableToDecode
    case unableToConvertDataToImage
}

enum APIURLs: String {
    case weekData = "https://protonmail.github.io/proton-mobile-test/api/forecast"
    case custom
}

class NetworkManager: NetworkManagerProviding {
    
    func getData<T>(fromURL url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) where T: Decodable  {
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            if error != nil {
                completion(.failure(.badResponse))
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        
        task.resume()
    }
    
    
    func getImage(fromURL url: URL, completion: @escaping(Result<UIImage, NetworkError>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            if error != nil {
                completion(.failure(.badResponse))
            }
            
            if let data = data {
                guard let image = UIImage(data: data) else {
                    completion(.failure(.unableToConvertDataToImage))
                    return
                }
                completion(.success(image))
            }
        }
        
        task.resume()
    }
}
