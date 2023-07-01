//
//  TwelveHoursWeatherForecast.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/05.
//

import Foundation


// MARK: - ForecastWeather
struct ShortTermForecastWeather: Codable {
    let forecastResponse: ForecastResponse
    
    enum CodingKeys: String, CodingKey {
        case forecastResponse = "response"
    }
}

// MARK: - Response
struct ForecastResponse: Codable {
    let forecastHeader: ForecastHeader
    let forecastBody: ForecastBody
    
    enum CodingKeys: String, CodingKey {
        case forecastHeader = "header"
        case forecastBody = "body"
    }
}

// MARK: - Body
struct ForecastBody: Codable {
    let forecastItems: ForecastItems
    
    enum CodingKeys: String, CodingKey {
        case forecastItems = "items"
    }
    
}

// MARK: - Items
struct ForecastItems: Codable {
    let forecastItem: [ForecastItem]
    
    enum CodingKeys: String, CodingKey {
        case forecastItem = "item"
    }
}

// MARK: - Item
struct ForecastItem: Codable {
    let baseDate, baseTime: String
    let category: Category
    let fcstDate, fcstTime, fcstValue: String
    let nx, ny: Int
    
}

enum Category: String, Codable {
    case pcp = "PCP"
    case pop = "POP"
    case pty = "PTY"
    case reh = "REH"
    case sky = "SKY"
    case sno = "SNO"
    case tmn = "TMN"
    case tmp = "TMP"
    case tmx = "TMX"
    case uuu = "UUU"
    case vec = "VEC"
    case vvv = "VVV"
    case wav = "WAV"
    case wsd = "WSD"
}

// MARK: - Header
struct ForecastHeader: Codable {
    let resultCode, resultMsg: String
}
