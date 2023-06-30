//
//  MainInformationView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import SnapKit

final class MainInformationView: UIView {
    
    
    // MARK: - 오늘의 날씨
    
    lazy var todayWeatherIs: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 25)
        return label
    }()
    
    let todaySky: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 25)
        return label
    }()
    
    
    // MARK: - 현재 온도
    
    let todayWeatherCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 60)
        label.text = "--"
        return label
    }()
    
    
    let celsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 60)
        label.text = "°"
        return label
    }()
    
    
    
    // MARK: - 최고 온도 & 최저 온도
    
    lazy var highestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "최고: --"
        return label
    }()
    
    
    lazy var lowestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "최저: --"
        return label
    }()
    
    
    
    // MARK: - 미세 & 초미세
    
    let particulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "미세: --"
        return label
    }()
    
    
    
    let ultraParticulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "초미세: --"
        return label
    }()
    
    
    
    // MARK: - 일출, 일몰 시간
    
    let sunrise: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "일출: --"
        return label
    }()
    
    
    let sunset: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 18)
        label.text = "일몰: --"
        return label
    }()
    
    
    
    
    // MARK: - StackView
    
    // 오늘의 날씨와 구름 상태를 알리는 스택 뷰
    lazy var todayIs: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [todayWeatherIs, todaySky])
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    
    
    // 최고 & 최저 기온 스택 뷰
    lazy var highLowCelciusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestCelsius, lowestCelsius])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    // 오늘의 온도를 알려주는 스택 뷰
    lazy var totalTodayWeatherCelsisus: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [todayWeatherCelsius, celsiusLabel])
        stack.axis = .horizontal
        stack.spacing = 1
        return stack
    }()
    
    
    // 미세 & 초미세먼지를 알려주는 스택 뷰
    lazy var particulateMatterStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [particulateMatter, ultraParticulateMatter])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    // 일출 & 일몰을 알려주는 스택 뷰
    lazy var sunriseAndSunsetStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sunrise, sunset])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(todayIs)
        self.addSubview(totalTodayWeatherCelsisus)
        self.addSubview(highLowCelciusStackView)
        self.addSubview(particulateMatterStackView)
        self.addSubview(sunriseAndSunsetStackView)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func setupLayout() {
        
        todayIs.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(10)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        totalTodayWeatherCelsisus.snp.makeConstraints { make in
            make.top.equalTo(todayIs.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }

        highLowCelciusStackView.snp.makeConstraints { make in
            make.top.equalTo(todayWeatherCelsius.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        particulateMatterStackView.snp.makeConstraints { make in
            make.top.equalTo(highLowCelciusStackView.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        sunriseAndSunsetStackView.snp.makeConstraints { make in
            make.top.equalTo(particulateMatterStackView.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        

    }
    
    
  
    
}
