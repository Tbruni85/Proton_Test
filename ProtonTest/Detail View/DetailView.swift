//
//  DetailView.swift
//  ProtonTest
//
//  Created by Tiziano Bruni on 04/06/2024.
//  Copyright © 2024 Proton Technologies AG. All rights reserved.
//

import UIKit


class DetailView: UIView {
    
    private let title: String
    private let descriptionText: String
    
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    
    init(title: String,
         descriptionText: String) {
        
        self.title = title
        self.descriptionText = descriptionText
        super.init(frame: .zero)
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.text = descriptionText
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
       
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
}
