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
    
    private struct Constants {
        static var thumbnailSize = CGSize(width: 50, height: 50)
        static var trailingPadding: CGFloat = 5
        static var verticalPadding: CGFloat = 15
        static var leadingPadding: CGFloat = 10
    }
    
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
            make.leading.equalToSuperview().inset(Constants.leadingPadding)
            make.top.bottom.equalToSuperview().inset(Constants.verticalPadding)
        }
        
        thumbnail.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(title.snp.trailing)
            make.trailing.equalToSuperview().inset(Constants.trailingPadding)
            make.size.equalTo(Constants.thumbnailSize)
        }
    }
    
    func setTitle(day: String, description: String) {
        title.text = "Day \(day): \(description)"
    }
    
    func updateImage(_ image: UIImage) {
        thumbnail.image = image
    }
}
