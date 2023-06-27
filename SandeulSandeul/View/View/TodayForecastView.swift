//
//  TodayForecastView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import SnapKit


final class TodayForecastView: UIView {
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal // 가로로 컬렉션 뷰 생성
        flowLayout.minimumInteritemSpacing = 0 // 아이템 사이 간격 설정
        flowLayout.minimumLineSpacing = 0 // 아이템 위 아래 간격 설정
        // ⭐️ 코드로 컬렉션 뷰를 생성할 때에는 반드시 파라미터가 존재해야 한다. ⭐️
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .morningDeep
        return collectionView
    }()
    
    
    
    
    // MARK: - 현재의 시간과 날씨 데이터
    var todayTime: String = "" {
        didSet {
            print("현재 시간이 todayTime에 들어왔습니다! \(todayTime)")
            let formatter = DateFormatter()
            formatter.dateFormat = "HH시"
            let today = formatter.string(from: Date())
            
            if todayTime == today {
                todayTime = "지금"
                print("현재 todayTime 바뀐 시간은 \(todayTime)")
                timeArray.insert(todayTime, at: 0)
                
            }
        }
    }
    
    
    var todayTemperature: String = "" {
        didSet {
            print("현재 시간이 todayTemperature에 들어왔습니다! \(todayTemperature)")
        }
    }
    

    
    
    
    // MARK: - 3일간의 시간, 날씨, 날씨이미지 데이터
    
    var temperatureArray: [String] = [] {
        didSet {
            print("temperatureArray에 값이 들어왔습니다. \(temperatureArray)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var timeArray: [String] = [] {
        didSet {
            print("timeArray에 값이 들어왔습니다. \(timeArray)")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var dateArray: [String] = [] {
        didSet {
            print("dateArray에 값이 들어왔습니다. \(dateArray)")
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
        if timeArray.count > 25 {
            return 25
        }
        
        return timeArray.count
    }
    
    
    // 각 셀에 들어가게 될 객체 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayForecastCell.identifier, for: indexPath) as! TodayForecastCell
        
        
        cell.temperature.text = temperatureArray[indexPath.item]
        cell.time.text = timeArray[indexPath.item]
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
