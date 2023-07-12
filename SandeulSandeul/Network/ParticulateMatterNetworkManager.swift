//
//  ParticulateMatterNetworkManager.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/12.
//

import Foundation
import Combine
import Alamofire

// 미세먼지를 알려주기 위해 에어코리아 사이트를 사용하면 반드시 앱 배포 전에 개발보고서를 작성해서 에어코리아에 제출해야 한다. ⭐️⭐️⭐️

final class ParticulateMatterNetworkManager {
    
    static let shared = ParticulateMatterNetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    private let serviceKey = "MSM4hND9K%2B8DAXSj6qAZhKiu7duCchZ99loLETFFWK9w1mAksfkTEBJMByCvhWxOJp1nzcbeb5jDoNdmodxkXA%3D%3D"
    
    
    
    // 네트워크 통신 작업을 할 때 Future 타입 Publisher를 사용해 비동기적인 작업을 처리해준다.
    
    // 미세먼지 농도를 잰다.
    // PM10 - 미세먼지 농도
    // PM25 - 초미세먼지 농도
    func fetchNetwork(density: String) -> AnyPublisher<ParticulateMatter, Never> {
        
        // 단기예보는 0210, 0510, 0810, 1110, 1410, 1710, 2010, 2310 시에 확인할 수 있다. (1일 8회만 확인 가능)
        // 0200로 설정하면 데이터를 그 날 하루의 데이터를 언제든지 받아볼 수 있다. ⭐️
        
        let url = "https://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst?serviceKey=\(serviceKey)&returnType=json&numOfRows=10&pageNo=1&itemCode=\(density)&dataGubun=HOUR&searchCondition=WEEK"
        
      
        
        return Future<ParticulateMatter, Never> { promise in
            AF.request(url).validate().responseDecodable(of: ParticulateMatter.self) { response in
                switch response.result {
                case .success(let weather):
                    print("미세먼지 통신이 성공적으로 이루어졌습니다!")
                    promise(.success(weather))
                case .failure(let error):
                    print("미세먼지 네트워크에서 에러가 발생했습니다 \(error)")
                }
            }
        }.eraseToAnyPublisher()
    }
    
   
}

