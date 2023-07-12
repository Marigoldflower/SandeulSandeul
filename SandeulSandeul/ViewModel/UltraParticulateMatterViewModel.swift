//
//  UltraParticulateViewModel.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/07/11.
//

import Foundation
import Combine
import Alamofire

final class UltraParticulateMatterViewModel {
    
    var cancellables: Set<AnyCancellable> = []
    
    // ForecastWeather 타입에 변화가 생기면 View에도 영향이 갈 수 있게끔 값을 바인딩한다.
    @Published var ultraParticulateMatterPublisher: ParticulateMatter?
    
    
    func fetchWeatherNetwork(density: String) {
        // ViewModel 내에 Subscriber를 생성해준다.
        // sink를 통해 Subscriber를 생성해주면 리턴 타입이 AnyCancellable이므로 반드시 cancellables에 저장해야 한다.
        // 네트워크 통신 값을 새로 만든 Publisher에게 담아준 후에 반드시 cancellables에 저장해야 한다.
        ParticulateMatterNetworkManager.shared.fetchNetwork(density: density).sink { [weak self] particulateMatter in
            self?.ultraParticulateMatterPublisher = particulateMatter
        }.store(in: &cancellables)
    }
    
}
