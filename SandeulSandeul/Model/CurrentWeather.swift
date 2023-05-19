//
//  CurrentWeather.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import Foundation

// 2) CurrentLocation으로부터 받은 key를 그대로 이 친구의 url에 할당해주어야 함
struct CurrentWeatherElement: Codable {
    let epochTime: Int
    let weatherText: String
    let temperature: Temperature
    

    enum CodingKeys: String, CodingKey {
        case epochTime = "EpochTime"
        case weatherText = "WeatherText"
        case temperature = "Temperature"
    }
}

// MARK: - Temperature
struct Temperature: Codable {
    let celsius, fahrenheit: DetailTemperatureData

    enum CodingKeys: String, CodingKey {
        case celsius = "Metric"
        case fahrenheit = "Imperial"
    }
}

// MARK: - Imperial
struct DetailTemperatureData: Codable {
    let value: Double

    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}

typealias CurrentWeather = [CurrentWeatherElement]

