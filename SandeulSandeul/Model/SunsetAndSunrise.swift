//
//  SunsetAndSunrise.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/14.
//

import Foundation

struct SunsetAndSunrise: Codable {
    let results: Results
    let status: String
}

// MARK: - Results
struct Results: Codable {
    let sunrise: String
    let sunset: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}
