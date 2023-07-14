//
//  MainInformationView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import SnapKit

final class MainInformationView: UIView {
    
    
    // MARK: - Page Control
    
    let pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = 3
        page.backgroundColor = .searchControllerWhite
        page.pageIndicatorTintColor = .pageIndicatorGray
        page.currentPageIndicatorTintColor = .currentPageIndicatorDarkBlue
        page.layer.cornerRadius = 5
        return page
    }()
    
    
    // MARK: - 현재 날씨 이미지
    
    let todayWeatherImage: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "sun.max.fill")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = .dayOrange
        return imageView
    }()
    
    
    
    // MARK: - 현재 온도
    
    let todayWeatherCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 66.38)
        label.text = "--"
        label.textColor = .dayImage
        return label
    }()
    
    
    let celsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: 35)
        label.text = "°"
        label.textColor = .dayImage
        return label
    }()
    
    
    
    // MARK: - 현재 지역과 날씨 상태
    
    lazy var currentLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 24)
        label.text = "--, "
        label.textColor = .dayImage
        return label
    }()
    
    let currentSky: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = UIFont(name: "Poppins-Semibold", size: 24)
        label.textColor = .dayImage
        return label
    }()
    
    
    // MARK: - 미세 & 초미세
    
    let particulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "미세: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    
    
    let ultraParticulateMatter: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "초미세: --"
        label.textColor = .daySideLabel
        return label
    }()
    
//    var particulateMatterStore = "" {
//        didSet { 
//            print("미세먼지 값이 들어왔습니다 \(particulateMatterStore)")
//        }
//    }
//
//    var ultraParticulateMatterStore = "" {
//        didSet {
//            print("초미세먼지 값이 들어왔습니다 \(ultraParticulateMatterStore)")
//        }
//    }
    
    
    
    
    // MARK: - 최고 온도 & 최저 온도
    
    lazy var highestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "최고: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    
    lazy var lowestCelsius: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "최저: --"
        label.textColor = .daySideLabel
        return label
    }()
    

    
    // MARK: - 일출, 일몰 시간
    
    let sunrise: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "일출: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    
    let sunset: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Semibold", size: 18)
        label.text = "일몰: --"
        label.textColor = .daySideLabel
        return label
    }()
    
    
    
    
    // MARK: - StackView
   
    
    // 현재 위치와 현재 날씨 상태를
    lazy var currentStatus: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currentLocation, currentSky])
        stack.axis = .horizontal
        stack.spacing = 4
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
    
    
    // 최고 & 최저 기온 스택 뷰
    lazy var highLowCelciusStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [highestCelsius, lowestCelsius])
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
        self.addSubview(pageControl)
        self.addSubview(todayWeatherImage)
        self.addSubview(todayWeatherCelsius)
        self.addSubview(celsiusLabel)
        self.addSubview(currentStatus)
        self.addSubview(particulateMatterStackView)
        self.addSubview(highLowCelciusStackView)
        self.addSubview(sunriseAndSunsetStackView)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    
    func setupLayout() {
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.top).offset(0)
        }
        
        todayWeatherImage.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(25)
            make.centerX.equalTo(self.snp.centerX)
            make.height.equalTo(118)
            make.width.equalTo(125)
        }
        
        
        todayWeatherCelsius.snp.makeConstraints { make in
            make.top.equalTo(todayWeatherImage.snp.bottom)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        celsiusLabel.snp.makeConstraints { make in
            make.leading.equalTo(todayWeatherCelsius.snp.trailing)
            make.top.equalTo(todayWeatherImage.snp.bottom)
        }
        
        
       
        currentStatus.snp.makeConstraints { make in
            make.top.equalTo(todayWeatherCelsius.snp.bottom).offset(-7)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        
        particulateMatterStackView.snp.makeConstraints { make in
            make.top.equalTo(currentStatus.snp.bottom).offset(40)
            make.centerX.equalTo(self.snp.centerX)
        }
        

        highLowCelciusStackView.snp.makeConstraints { make in
            make.top.equalTo(particulateMatterStackView.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
   
        
        sunriseAndSunsetStackView.snp.makeConstraints { make in
            make.top.equalTo(highLowCelciusStackView.snp.bottom).offset(5)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        

    }
    
    
  
    
}
