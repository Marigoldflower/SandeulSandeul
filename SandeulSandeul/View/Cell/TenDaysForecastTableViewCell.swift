//
//  TenDaysForecastTableViewCell.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/29.
//

import UIKit

class TenDaysForecastTableViewCell: UITableViewCell {

    static let identifier = "TenDaysForecastTableViewCell"
    
    
    let weekend: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        return label
    }()
    
    
    let todayWeatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray
        return imageView
    }()
    
    
    let highestTemperature: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        return label
    }()
    
    
    let divider: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        return label
    }()
    
    
    let lowestTemperature: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        return label
    }()
    
    
    
    // MARK: - StackView
    
    
    lazy var highestLowestTemperature: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestTemperature, divider, lowestTemperature])
        stack.axis = .horizontal
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()
    
    
  
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.addSubview(weekend)
        self.addSubview(todayWeatherImage)
        self.addSubview(highestTemperature)
        self.addSubview(highestLowestTemperature)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func setupLayout() {
        weekend.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(15)
            make.centerY.equalToSuperview()
        }
        
        todayWeatherImage.snp.makeConstraints { make in
            make.leading.equalTo(weekend.snp.trailing).offset(45)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(45)
        }
        
        
//        highestTemperature.snp.makeConstraints { make in
//            make.trailing.equalTo(highestLowestTemperature.snp.leading).offset(-5)
//            make.centerY.equalToSuperview()
//        }
        
        highestLowestTemperature.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        
        
    }
    
}
