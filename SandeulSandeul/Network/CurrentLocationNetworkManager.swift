//
//  CurrentLocationNetworkManager.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//


import Foundation
import Combine
import Alamofire


class CurrentLocationNetworkManager {
    
    static let shared = CurrentLocationNetworkManager()
    // 여러객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // 네트워크 통신 작업을 할 때 Future 타입 Publisher를 사용해 비동기적인 작업을 처리해준다.
    // 일단 문제가 Combine에서는 CompletionHandler를 통해서 값이 들어올 때까지 기다리는 것이 아니기 때문에
    // 내 개인적인 생각에는 completionHandler와 똑같이 동작하는 async/await를 Combine에서 같이 써줘야
    // 비동기 작업이 들어오고 난 후에야 UI를 그릴 수 있을 것 같다. 
    func fetchNetwork() -> Future<CurrentLocation, Never> {
        
        let url = "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=VAQZLBkF92ZPgU3ulJGSm9nYInAr3JGt&q=%EC%88%98%EC%9B%90&language=ko-kr"
        
        return Future<CurrentLocation, Never> { promise in
            AF.request(url).validate().responseDecodable(of: CurrentLocation.self) { response in
                switch response.result {
                case .success(let location):
                    print("통신이 성공적으로 이루어졌습니다!")
                    promise(.success(location))
                case .failure(let error):
                    print("에러가 발생했습니다 \(error)")
                }
                
            }
            
        }
    }
   
}
