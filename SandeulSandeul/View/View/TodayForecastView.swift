//
//  TodayForecastView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import SnapKit
import SDWebImage

// Weather 이미지를 넣기 위해 사용될 enum 
enum Weather: String {
    case sunny = "1"
    case cloudy = "3"
    case blur = "4"
}


final class TodayForecastView: UIView {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal // 가로로 컬렉션 뷰 생성
        flowLayout.minimumInteritemSpacing = 0 // 아이템 사이 간격 설정
        flowLayout.minimumLineSpacing = 0 // 아이템 위 아래 간격 설정
        // ⭐️ 코드로 컬렉션 뷰를 생성할 때에는 반드시 파라미터가 존재해야 한다. ⭐️
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    
    // MARK: - TodayTime, TodayTemperature 변수에 값이 두 번 들어오는데 1번만 들어오게 해서 값을 적용하게 하기 위한 임시 저장용 변수
    var todayTimeDidSetCallCount = 0
    var todayTemperatureDidSetCallCount = 0
    var todayWeatherDidSetCallCount = 0
    
    
    
    // MARK: - "현재"의 시간, 온도, 날씨 이미지 데이터
    var todayTime: String = "" {
        didSet {
            
            // didSet이 불릴 때마다 값을 1씩 추가
            todayTimeDidSetCallCount += 1
            print("현재 시간이 todayTime에 들어왔습니다! \(todayTime)")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH"
            let today = formatter.string(from: Date())
            
            
            if todayTime.contains(today) {
                // todayTimeDidSetCallCount가 1일 때만, 즉, didSet이 딱 한 번만 불릴 때, 코드 블럭을 실행한다.
                // didSet이 두 번째 불려서, todayTimeDidSetCallCount가 2가 되면, 이 코드 블럭은 실행되지 않는다.
                if todayTimeDidSetCallCount == 1 {
                    self.timeArray.insert("지금", at: 0)
                    
                }
            }
        }
    }
    
    
    
    var todayTemperature: String = "" {
        didSet {
            todayTemperatureDidSetCallCount += 1
            print("현재 온도가 todayTemperature에 들어왔습니다! \(todayTemperature)")
            
            if todayTemperatureDidSetCallCount == 1 {
                self.temperatureArray.insert(todayTemperature, at: 0)
            }
        }
    }
    
    
    
    var todayWeather: String = "" {
        didSet {
            todayWeatherDidSetCallCount += 1
            print("현재 날씨가 todayWeather에 들어왔습니다! \(todayWeather)")
            
            if todayWeatherDidSetCallCount == 1 {
                self.weatherArray.insert(todayWeather, at: 0)
            }
        }
    }
    
    
    
    
    // MARK: - 3일간의 시간, 온도, 날씨이미지 데이터
    
    var temperatureArray: [String] = [] {
        didSet {
            print("temperatureArray에 값이 들어왔습니다. \(temperatureArray)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var timeArray: [String] = [] {
        didSet {
            print("timeArray에 값이 들어왔습니다. \(timeArray)")
            
            // "00" 이라는 값이 있는 인덱스에 "내일" 이라는 값을 대신 집어넣게 하는 방법 ⭐️
            if let indexTomorrow = timeArray.firstIndex(of: "00") {
                timeArray[indexTomorrow] = "내일"
            }
            
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    var weatherArray: [String] = [] {
        didSet {
            print("weatherArray에 값이 들어왔습니다. \(weatherArray)")
            
            for i in weatherArray {
                switch Weather(rawValue: i) {
                case .sunny:
//                    self.weatherImageArray.append(UIImage(named: "sun") ?? UIImage())
                    print("여기에 태양 관련 이미지 넣기")
                case .cloudy:
//                    self.weatherImageArray.append(UIImage(named: "cloud") ?? UIImage())
                    print("여기에 구름많음 관련 이미지 넣기")
                case .blur:
//                    self.weatherImageArray.append(UIImage(named: "moon") ?? UIImage())
                    print("여기에 흐림 관련 이미지 넣기")
                case .none:
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    
    // MARK: - 실제로 날씨 이미지 데이터를 모아놓은 곳
    
    
    var weatherImageArray: [UIImage] = [] {
        didSet {
            print("weatherImageArray에 값이 들어왔습니다. \(weatherImageArray)")
           
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        setupLayout()
        setupDelegate()
        registerCollectionView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    
    func setupDelegate() {
        // dataSource와 delegate를 둘 다 설정해주어야 비로소 collectionView cell의 크기를 정해줄 수 있다.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // 셀 등록 함수
    func registerCollectionView() {
        collectionView.register(TodayForecastCell.self, forCellWithReuseIdentifier: TodayForecastCell.identifier)
    }
    
    
    
}


extension TodayForecastView: UICollectionViewDataSource {
    // 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("컬렉션 뷰 셀의 개수는 \(temperatureArray.count)") // 0개로 나오면 collectionView.reloadData() 했는지 확인하기
        if temperatureArray.count > 24 {
            return 24
        }
//        
        return temperatureArray.count
    }
    
    
    // 각 셀에 들어가게 될 객체 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayForecastCell.identifier, for: indexPath) as! TodayForecastCell
        
        
        cell.temperature.text = temperatureArray[indexPath.item]
        cell.time.text = timeArray[indexPath.item]
//        cell.weatherImage.image = weatherImageArray[indexPath.item]
        
        return cell
    }
    
    
}

extension TodayForecastView: UICollectionViewDelegate {
    // 컬렉션 뷰를 클릭할 경우 실행할 메소드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


// ⭐️ 이 Protocol 내에서만 각각의 아이템 사이즈를 정해줄 수 있다. 반드시 기억하기! ⭐️
// 다른 Protocol 내에서는 각각의 아이템 사이즈를 정해줄 수 없다.
extension TodayForecastView: UICollectionViewDelegateFlowLayout {
    // ⭐️ 컬렉션 뷰 각각의 아이템 사이즈 크기를 정하는 곳 ⭐️
    // 컬렉션 뷰는 각각의 아이템 사이즈를 반드시 정해줘야 한다.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 200)
    }
}
