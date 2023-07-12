//
//  LongTermForecastWeather.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/30.
//


import Foundation

// MARK: - LongTermForecast
struct LongTermForecastWeather: Codable {
    let response: Response?
}

// MARK: - Response
struct Response: Codable {
    let header: Header
    let body: Body?
}

// MARK: - Body
struct Body: Codable {
    let dataType: String
    let items: Items
    let pageNo, numOfRows, totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [Item]
}

// MARK: - Item
struct Item: Codable {
    let regID: String
    let taMin3, taMin3Low, taMin3High, taMax3: Int
    let taMax3Low, taMax3High, taMin4, taMin4Low: Int
    let taMin4High, taMax4, taMax4Low, taMax4High: Int
    let taMin5, taMin5Low, taMin5High, taMax5: Int
    let taMax5Low, taMax5High, taMin6, taMin6Low: Int
    let taMin6High, taMax6, taMax6Low, taMax6High: Int
    let taMin7, taMin7Low, taMin7High, taMax7: Int
    let taMax7Low, taMax7High, taMin8, taMin8Low: Int
    let taMin8High, taMax8, taMax8Low, taMax8High: Int
    let taMin9, taMin9Low, taMin9High, taMax9: Int
    let taMax9Low, taMax9High, taMin10, taMin10Low: Int
    let taMin10High, taMax10, taMax10Low, taMax10High: Int

    enum CodingKeys: String, CodingKey {
        case regID = "regId"
        case taMin3, taMin3Low, taMin3High, taMax3, taMax3Low, taMax3High, taMin4, taMin4Low, taMin4High, taMax4, taMax4Low, taMax4High, taMin5, taMin5Low, taMin5High, taMax5, taMax5Low, taMax5High, taMin6, taMin6Low, taMin6High, taMax6, taMax6Low, taMax6High, taMin7, taMin7Low, taMin7High, taMax7, taMax7Low, taMax7High, taMin8, taMin8Low, taMin8High, taMax8, taMax8Low, taMax8High, taMin9, taMin9Low, taMin9High, taMax9, taMax9Low, taMax9High, taMin10, taMin10Low, taMin10High, taMax10, taMax10Low, taMax10High
    }
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}
