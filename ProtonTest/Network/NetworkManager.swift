//
//  NetworkManager.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badResponse
    case unableToDecode
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
}
