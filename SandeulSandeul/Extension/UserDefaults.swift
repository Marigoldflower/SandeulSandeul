//
//  UserDefaults.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/08.
//

import Foundation

extension UserDefaults {
    
    var currentTemperature: String {
        get {
            // lowTemperature에 담긴 값을 가져오는 메소드
            return UserDefaults.standard.string(forKey: "currentTemperature")!
        }
        set {
            // lowTemperature에 newValue 값을 넣으면 UserDefaults에 newValue값이 저장된다.
            UserDefaults.standard.setValue(newValue, forKey: "currentTemperature")
        }
    }
}
