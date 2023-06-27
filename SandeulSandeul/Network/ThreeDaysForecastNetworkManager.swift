//
//  ThreeDaysForecastNetworkManager.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/26.
//

import Foundation
import Combine
import Alamofire


final class ThreeDaysForecastNetworkManager {
    
    static let shared = ThreeDaysForecastNetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    private let serviceKey = "8777a274d0344e0a80c73132230606"
    
    // 네트워크 통신 작업을 할 때 Future 타입 Publisher를 사용해 비동기적인 작업을 처리해준다.
    func fetchNetwork(latitude: String, longtitude: String) -> AnyPublisher<ThreeDaysForecast, Never> {
        
        // MARK: - 현재 시간
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let today = formatter.string(from: Date())
        print("오늘의 날짜는 \(today)")
        
        
        // 단기예보는 0210, 0510, 0810, 1110, 1410, 1710, 2010, 2310 시에 확인할 수 있다. (1일 8회만 확인 가능)
        // 0200로 설정하면 데이터를 그 날 하루의 데이터를 언제든지 받아볼 수 있다. ⭐️
        let url = "http://api.weatherapi.com/v1/forecast.json?key=\(serviceKey)&q=\(latitude),\(longtitude)&days=2"
 
        return Future<ThreeDaysForecast, Never> { promise in
            AF.request(url).validate().responseDecodable(of: ThreeDaysForecast.self) { response in
                switch response.result {
                case .success(let weather):
                    print("ThreeDays 통신이 성공적으로 이루어졌습니다!")
                    promise(.success(weather))
                case .failure(let error):
                    print("ThreeDays 네트워크에서 에러가 발생했습니다 \(error)")
                }
                
            }
            
        }.eraseToAnyPublisher()
    }
   
}


