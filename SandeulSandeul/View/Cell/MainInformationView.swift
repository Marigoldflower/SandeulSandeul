//
//  MainInformationView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import SnapKit

class MainInformationView: UIView {

    lazy var todayWeatherIs: UILabel = {
        let label = UILabel()
        label.text = "\(myLocation) 오늘의 날씨는"
        label.font = UIFont(name: "IBMPlexSansKR-Medium", size: 25)
        return label
    }()
    
    
    let todayWeatherCelsius: UILabel = {
        let label = UILabel()
        label.text = "23°C"
        label.font = UIFont(name: "IBMPlexSansKR", size: 60)
        return label
    }()
    
    var myLocation = ""
    
    var currentLocation: CurrentLocation = [] {
        didSet {
            print("Current Location에 값이 들어왔습니다! \(currentLocation)")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(todayWeatherIs)
        self.addSubview(todayWeatherCelsius)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func setupLayout() {
        todayWeatherIs.snp.makeConstraints { make in
            
        }
        
        todayWeatherCelsius.snp.makeConstraints { make in
            
            make.top.equalTo(todayWeatherIs.snp.bottom)
          
        }
    }
    
}
