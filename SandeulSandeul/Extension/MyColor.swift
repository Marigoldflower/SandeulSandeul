//
//  MyColor.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/02.
//

import Foundation
import UIKit


enum WeatherStatus {
    case sunny
    case rainy
    case snowy
    case cloudy
}

enum DayAndNight {
    case day
    case night
}


extension UIColor {
    
    // 데이터의 색깔 (밝은 날씨일 때에는 어두운 주황, 어두운 날씨일 때에는 밝은 주황)
    static let dayDataText = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let nightDataText = UIColor(red: 1.00, green: 0.80, blue: 0.67, alpha: 1.00)
    
    
    
    // MARK: - SearchController
    
    static let searchControllerWhite = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    
    
    
    // MARK: - PageControl
    
    static let pageIndicatorGray = UIColor(red: 0.77, green: 0.77, blue: 0.77, alpha: 1.00)
    static let currentPageIndicatorDarkBlue = UIColor(red: 0.00, green: 0.12, blue: 0.44, alpha: 1.00)
    
    
    
    // MARK: - Day
    
    
    static let dayBackground = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let dayImage = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let dayMainLabel = UIColor(red: 0.94, green: 0.67, blue: 0.51, alpha: 1.00)
    static let daySideLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)

    
    
    // MARK: - Night
    
    static let nightBackground = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
    static let nightImage = UIColor(red: 0.91, green: 0.79, blue: 0.47, alpha: 1.00)
    static let nightMainLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let nightSideLabel = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    
    
    
    // MARK: - Cloudy
    
    static let cloudyBackground = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let cloudyImage = UIColor(red: 0.41, green: 0.81, blue: 0.90, alpha: 1.00)
    static let cloudyMainLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
    static let cloudySideLabel = UIColor(red: 0.28, green: 0.29, blue: 0.51, alpha: 1.00)
    
    
    
    // MARK: - Snowy
    
    static let snowyBackground = UIColor(red: 0.65, green: 0.67, blue: 0.77, alpha: 1.00)
    static let snowyImage = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let snowyMainLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    static let snowySideLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    
    
    
    // MARK: - Rainy
    
    static let rainyBackground = UIColor(red: 0.50, green: 0.52, blue: 0.59, alpha: 1.00)
    static let rainyImage = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let rainyMainLabel = UIColor(red: 0.87, green: 0.93, blue: 0.95, alpha: 1.00)
    static let rainySideLabel = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
    
    
    
    
    // MARK: - 미세먼지 농도에 따른 색깔
    
    // 밝은 배경화면일 때 사용할 색깔
    static let particulateGoodColorDay = UIColor(red: 0.18, green: 0.67, blue: 0.78, alpha: 1.00)
    static let particulateNormalColorDay = UIColor(red: 0.50, green: 0.67, blue: 0.53, alpha: 1.00)
    static let particulateBadColorDay = UIColor(red: 0.74, green: 0.64, blue: 0.38, alpha: 1.00)
    static let particulateVeryBadColorDay = UIColor(red: 0.78, green: 0.25, blue: 0.18, alpha: 1.00)
    
    // 어두운 배경화면일 때 사용할 색깔
    static let particulateGoodColorNight = UIColor(red: 0.24, green: 0.86, blue: 1.00, alpha: 1.00)
    static let particulateNormalColorNight = UIColor(red: 0.67, green: 0.89, blue: 0.71, alpha: 1.00)
    static let particulateBadColorNight = UIColor(red: 0.91, green: 0.79, blue: 0.47, alpha: 1.00)
    static let particulateVeryBadColorNight = UIColor(red: 0.98, green: 0.62, blue: 0.57, alpha: 1.00)
    
}


// MARK: - Label 색깔에 변화를 주는 메소드
// 여기서 밝은 날씨와 어두운 날씨에 따라 색깔에 구분을 줘야 한다.
// 1. 낮, 구름 많음: 밝은 날씨
// 2. 밤, 눈, 비: 어두운 날씨

// 낮인데 눈일 경우? : 어두운 날씨
// 낮인데 비일 경우? : 어두운 날씨
// 밤인데 구름 많을 경우? : 어두운 날씨

func coloringTextMethod(text: String, colorText: String, color: UIColor) -> NSAttributedString {
    let stringOne = "\(text): \(colorText)"
    let stringTwo = "\(colorText)"
    
    let range = (stringOne as NSString).range(of: stringTwo)
    
    let attributedText = NSMutableAttributedString.init(string: stringOne)
    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    
    return attributedText
    
}



// MARK: - 날씨에 따라 배경색, 이미지 색, Label 색에 변화를 주는 메소드


func coloringMainInformationView(mainInformationView: MainInformationView, weatherController: WeatherController, currentSkyStatus: String, particulateMatter: [ParticulateMatterItem], ultraParticulateMatter: [ParticulateMatterItem]) {
    mainInformationView.currentSky.text = currentSkyStatus // 현재 SkyStatus에 따라서 들어갈 색깔을 나눠주어야 한다.
    
    switch currentSkyStatus {
    case "비옴":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .rainyBackground, imageColor: .rainyImage, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, imageName: "cloud.rain.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "비와눈":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .rainyBackground, imageColor: .rainyImage, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, imageName: "cloud.sleet.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "눈옴":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .snowyBackground, imageColor: .snowyImage, mainLabelColor: .snowyMainLabel, sideLabelColor: .snowySideLabel, imageName: "snowflake", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "소나기":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .rainyBackground, imageColor: .rainyImage, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, imageName: "cloud.heavyrain.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "맑음":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .dayBackground, imageColor: .dayImage, mainLabelColor: .dayMainLabel, sideLabelColor: .daySideLabel, imageName: "sun.max.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "구름많음":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .cloudyBackground, imageColor: .cloudyImage, mainLabelColor: .cloudyMainLabel, sideLabelColor: .cloudySideLabel, imageName: "smoke.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    case "흐림":
        colorMatchingAccordingToCurrentStatus(mainInformationView: mainInformationView, weatherController: weatherController, backgroundColor: .rainyBackground, imageColor: .rainyImage, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, imageName: "smoke.fill", particulateMatter: particulateMatter, ultraParticulateMatter: ultraParticulateMatter)
    default: break
    }
}


func colorMatchingAccordingToCurrentStatus(mainInformationView: MainInformationView, weatherController: WeatherController, backgroundColor: UIColor, imageColor: UIColor, mainLabelColor: UIColor, sideLabelColor: UIColor, imageName: String, particulateMatter: [ParticulateMatterItem], ultraParticulateMatter: [ParticulateMatterItem]) {
    
    // backgroundColor
    weatherController.view.backgroundColor = backgroundColor
    mainInformationView.backgroundColor = backgroundColor
    
    
    // imageName
    mainInformationView.todayWeatherImage.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
    
    
    // imageColor
    mainInformationView.todayWeatherImage.tintColor = imageColor
    
    
    // mainLabelColor
    mainInformationView.todayWeatherCelsius.textColor = mainLabelColor
    mainInformationView.celsiusLabel.textColor = mainLabelColor
    mainInformationView.currentLocation.textColor = mainLabelColor
    mainInformationView.currentSky.textColor = mainLabelColor
    
    
    // sideLabelColor
    mainInformationView.particulateMatter.textColor = sideLabelColor
//    weatherController.particulateMatterCalculatorAccordingToLocation(location: weatherController.particulateMatterLocation, particulateData: particulateMatter) // 미세먼지 데이터가 들어와야 함
    mainInformationView.ultraParticulateMatter.textColor = sideLabelColor
//    weatherController.particulateMatterCalculatorAccordingToLocation(location: weatherController.ultraParticulateMatterLocation, particulateData: ultraParticulateMatter) // 초미세먼지 데이터가 들와야 함
    mainInformationView.highestCelsius.textColor = sideLabelColor
//    mainInformationView.highestCelsius.attributedText = coloringTextMethod(text: "최고", colorText: "26.0", color: .nightText)
    mainInformationView.lowestCelsius.textColor = sideLabelColor
//    mainInformationView.lowestCelsius.attributedText = coloringTextMethod(text: "최저", colorText: "24.0", color: .nightText)
    
    mainInformationView.sunrise.textColor = sideLabelColor
    mainInformationView.sunset.textColor = sideLabelColor
}




// MARK: - 미세 & 초미세가 좋음, 보통, 나쁨, 
