//
//  ViewController.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import CoreLocation
import SnapKit

class WeatherController: UIViewController {
    
    let mainInformationView: MainInformationView = {
        let view = MainInformationView()
        view.backgroundColor = .green
        return view
    }()
    
    
    let todayForecastView: TodayForecastView = {
        let view = TodayForecastView()
        view.backgroundColor = .blue
        return view
    }()
    
    
    
    // MARK: - 스택 뷰
    let stackView: UIStackView = {
        let stack = UIStackView() // arrangedSubview를 이용해서 바로 할당하지 말 것
        stack.axis = .vertical // 가로로 스크롤하고 싶으면 horizontal로 맞추기
        stack.spacing = 15
        stack.distribution = .fill
        return stack
    }()
    
    
    
    
    // MARK: - 스크롤 뷰
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        return scroll
    }()
    

    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupLayout()
        fillStackView()
        setupLocation()
        
    }
    
    func setupLayout() {
        
        // MARK: - 뷰 레이아웃
        
        mainInformationView.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        
        todayForecastView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        
        
        
        // MARK: - 스크롤 뷰 및 스택 뷰 레이아웃
    
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.snp.top)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.width.equalTo(scrollView.snp.width)
        }
        
    }
    
    
    func fillStackView() {
        let companyArray = [mainInformationView, todayForecastView]
        for company in companyArray {
            var elementView = UIView()
            elementView = company
            elementView.translatesAutoresizingMaskIntoConstraints = false
            // ⭐️ 스크롤 방향이 세로 방향이면 widthAnchor에 값을 할당하는 부분은 지워도 된다.
//            elementView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            // ⭐️ 스크롤 방향이 가로 방향이면 heightAnchor에 값을 할당하는 부분은 지워도 된다.
            elementView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
            stackView.addArrangedSubview(elementView)
        }
    }
    
    
    
    func setupLocation() {
        locationManager.delegate = self
        
        // 해당 앱이 사용자의 위치를 사용하도록 허용할지 물어보는 창을 띄운다.
        // (한 번 허용, 앱을 사용하는 동안 허용, 허용 안 함) 문구가 적혀있는 창을 띄움
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
}


extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // "앱을 사용하는 동안 허용", "한 번 허용" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
        case .restricted, .notDetermined:
            // 아직 사용자의 위치가 설정되지 않았을 때 이 부분이 실행된다.
            print("GPS 권한 설정되지 않음")
            setupLocation()
        case .denied:
            // "허용 안 함" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 요청 거부됨")
            setupLocation()
        default:
            print("GPS: Default")
        }
    }
    
    // 위도, 경도 정보를 얻는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 가장 최근 업데이트 된 위치를 설정
        guard let currentLocation = locations.first else { return }
        
        // 최근 업데이트 된 위치의 위도와 경도를 설정
        let latitude = currentLocation.coordinate.latitude
        let longtitude = currentLocation.coordinate.longitude
        print("위도: \(latitude) | 경도: \(longtitude)")
        
    }
}
