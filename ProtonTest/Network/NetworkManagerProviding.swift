//
//  NetworkManagerProviding.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit

protocol NetworkManagerProviding {

    func getData<T>(fromURL url: URL, completion: @escaping(Result<T, NetworkError>) -> Void) where T: Decodable
    func getImage(fromURL url: URL, completion: @escaping(Result<UIImage, NetworkError>) -> Void)
}
