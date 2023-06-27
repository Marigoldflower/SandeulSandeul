//
//  SunsetAndSunriseNetworkManager.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/14.
//

import Foundation
import Combine
import Alamofire


final class SunsetAndSunriseNetworkManager {
    
    static let shared = SunsetAndSunriseNetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // 네트워크 통신 작업을 할 때 Future 타입 Publisher를 사용해 비동기적인 작업을 처리해준다.
    
    func fetchNetwork(latitude: String, longtitude: String) -> AnyPublisher<SunsetAndSunrise, Never> {
        
        let todayDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = formatter.string(from: todayDate)
        
        
        let url = "https://api.sunrise-sunset.org/json?lat=\(latitude)&lng=\(longtitude)&date=\(today)"
        
        return Future<SunsetAndSunrise, Never> { promise in
            AF.request(url).validate().responseDecodable(of: SunsetAndSunrise.self) { response in
                switch response.result {
                case .success(let weather):
                    print("일출 일몰 네트워크가 성공적으로 이루어졌습니다!")
                    promise(.success(weather))
                case .failure(let error):
                    print("일출 일몰 네트워크에서 에러가 발생했습니다 \(error)")
                }
            }
        }.eraseToAnyPublisher()
    }
    
   
}


