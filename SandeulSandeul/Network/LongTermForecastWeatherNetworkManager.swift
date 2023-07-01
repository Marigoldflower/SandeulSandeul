//
//  LongTermForecastWeatherNetworkManager.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/30.
//

import Foundation
import Combine
import Alamofire


final class LongTermForecastWeatherNetworkManager {
    
    static let shared = LongTermForecastWeatherNetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    private let serviceKey = "MSM4hND9K%2B8DAXSj6qAZhKiu7duCchZ99loLETFFWK9w1mAksfkTEBJMByCvhWxOJp1nzcbeb5jDoNdmodxkXA%3D%3D"
    
    // 네트워크 통신 작업을 할 때 Future 타입 Publisher를 사용해 비동기적인 작업을 처리해준다.
    func fetchNetwork(regionID: String) -> AnyPublisher<LongTermForecastWeather, Never> {
        
        // MARK: - 현재 시간
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmm"
        let today = formatter.string(from: Date())
        print("오늘의 날짜는 \(today)")
        
        
        // 단기예보는 0210, 0510, 0810, 1110, 1410, 1710, 2010, 2310 시에 확인할 수 있다. (1일 8회만 확인 가능)
        // 0200로 설정하면 데이터를 그 날 하루의 데이터를 언제든지 받아볼 수 있다. ⭐️
        let url = "https://apis.data.go.kr/1360000/MidFcstInfoService/getMidTa?serviceKey=\(serviceKey)&pageNo=1&numOfRows=1000&dataType=JSON&regId=\(regionID)&tmFc=\(today)"
 
        return Future<LongTermForecastWeather, Never> { promise in
            AF.request(url).validate().responseDecodable(of: LongTermForecastWeather.self) { response in
                switch response.result {
                case .success(let weather):
                    print("LontTerm Forecast 통신이 성공적으로 이루어졌습니다!")
                    promise(.success(weather))
                case .failure(let error):
                    print("LongTerm Forecast 네트워크에서 에러가 발생했습니다 \(error)")
                }
                
            }
            
        }.eraseToAnyPublisher()
    }
   
}
