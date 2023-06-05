//
//  CurrentLocationViewModel.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/03.
//



import Foundation
import Combine
import Alamofire

final class CurrentLocationViewModel: ObservableObject {
    
    var cancellables: Set<AnyCancellable> = []
    @Published var networkPublisher: CurrentLocation = []
    
    func fetchNetwork() {
        // ViewModel 내에 Subscriber를 생성해준다.
        // sink를 통해 Subscriber를 생성해주면 리턴 타입이 AnyCancellable이므로 반드시 cancellables에 저장해야 한다.
        // 네트워크 통신 값을 새로 만든 Publisher에게 담아준 후에 반드시 cancellables에 저장해야 한다.
        CurrentLocationNetworkManager.shared.fetchNetwork().sink { [weak self] currentLocation in
            self?.networkPublisher = currentLocation
            
        }.store(in: &cancellables)
    }
    
    
}
