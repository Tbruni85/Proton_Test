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
    
    private var title: UILabel!
    private var thumbnail: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = UIImage(systemName: "x.square")
        title.text = ""
    }
    
    private func setupView() {
        selectionStyle = .none
        
        title = UILabel()
        contentView.addSubview(title)
        
        thumbnail = UIImageView()
        thumbnail.contentMode = .scaleAspectFit
        thumbnail.image = UIImage(systemName: "x.square")
        thumbnail.tintColor = .lightGray
        contentView.addSubview(thumbnail)
        
        title.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        
        thumbnail.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(15)
            make.leading.lessThanOrEqualTo(title.snp.trailing)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
    }
    
    func setTitle(day: String, description: String) {
        title.text = "Day \(day): \(description)"
    }
    
    func updateImage(_ image: UIImage) {
        thumbnail.image = image
    }
}
