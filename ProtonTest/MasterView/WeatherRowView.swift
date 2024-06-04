//
//  WeatherRowView.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit
import SnapKit

class WeatherRowView: UITableViewCell {
    
    public var title: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        
        title = UILabel()
        addSubview(title)
        
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    func setTitle(day: String, description: String, rain: String) {
        title.text = "Day \(day): \(description) chance of rain \(rain)"
    }
}
