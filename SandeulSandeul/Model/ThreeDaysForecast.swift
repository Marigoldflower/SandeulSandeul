//
//  ThreeDaysForecast.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/26.
//

import Foundation

// MARK: - ThreeDaysForecast
struct ThreeDaysForecast: Codable {
    let location: Location
    let forecast: Forecast
}



// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let hour: [Hour]

}


// MARK: - Hour
struct Hour: Codable {
    let timeEpoch: TimeInterval
    let time: String

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
    }
    
    
    var forecastTimeFormatter: String? {
        let formatter = DateFormatter()
        let epochTime = TimeInterval(timeEpoch)
        let date = Date(timeIntervalSince1970: epochTime)
        formatter.dateFormat = "HH"
        let result = formatter.string(from: date)
        
        return result
    }
}

// MARK: - Location
struct Location: Codable {
    let localtimeEpoch: TimeInterval
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
