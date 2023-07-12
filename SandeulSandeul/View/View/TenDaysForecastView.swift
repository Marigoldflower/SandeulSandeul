//
//  TenDaysForecastView.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/29.
//

import UIKit
import SnapKit

class TenDaysForecastView: UIView {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .red
        return table
    }()
    
    
    // MARK: - weekDayArray, highestCelsius, lowestCelsius 변수에 값이 두 번씩 들어오는데 한 번씩만 들어오게 해서 값을 적용하게 하기 위한 임시 저장용 변수
    
    var weekDayArrayDidSetCallCount = 0
    
    var threeDaysHighestCelsiusDidSetCallCount = 0
    var threeDaysLowestCelsisusDidSetCallCount = 0
    
    var tenDaysHighestCelsiusDidSetCallCount = 0
    var tenDaysLowestCelsisuDidSetCallCount = 0
    
    
    // MARK: - 요일 데이터
    
    var weekDayArray: [String] = [] {
        didSet {
            weekDayArrayDidSetCallCount += 1

            
            // DidSet이 4번이 불리면 똑같은 요일이 계속 반복되어 호출되므로 딱 3번까지만 부른다.
            if weekDayArrayDidSetCallCount == 3 {
                if weekDayArray[2] == "일" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["월", "화", "수", "목", "금", "토", "일"])
                } else if weekDayArray[2] == "월" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["화", "수", "목", "금", "토", "일", "월"])
                } else if weekDayArray[2] == "화" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["수", "목", "금", "토", "일", "월", "화"])
                } else if weekDayArray[2] == "수" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["목", "금", "토", "일", "월", "화", "수"])
                } else if weekDayArray[2] == "목" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["금", "토", "일", "월", "화", "수", "목"])
                } else if weekDayArray[2] == "금" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["토", "일", "월", "화", "수", "목", "금"])
                } else if weekDayArray[2] == "토" {
                    weekDayTableViewArray = weekDayArray
                    weekDayTableViewArray.append(contentsOf: ["일", "월", "화", "수", "목", "금", "토"])
                }
            }
        }
    }
    
    
    
    
    // MARK: - "테이블 뷰"에 쓸 요일 데이터
    
    var weekDayTableViewArray: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    
    // MARK: - 3일간 최고 / 최저 온도 데이터
    var threeDaysHighestCelsius: [String] = [] {
        didSet {
            threeDaysHighestCelsiusDidSetCallCount += 1
            print("3일간 최고 온도가 들어왔습니다 \(threeDaysHighestCelsius)")
            
            if threeDaysHighestCelsiusDidSetCallCount == 3 {
                tableHighestCelsisus = threeDaysHighestCelsius
            }
            
        }
    }
    
    
    var threeDaysLowestCelsius: [String] = [] {
        didSet {
            threeDaysLowestCelsisusDidSetCallCount += 1
            print("3일간 최저 온도가 들어왔습니다 \(threeDaysLowestCelsius)")
            
            if threeDaysLowestCelsisusDidSetCallCount == 3 {
                tableLowestCelsisus = threeDaysLowestCelsius
            }
        }
    }
    
    
    
    
    // MARK: - 3~10일간 최고 / 최저 온도 데이터
    
    
    var tenDaysHighestCelsius: [String] = [] {
        didSet {
            tenDaysHighestCelsiusDidSetCallCount += 1
            print("3~10일간 최고 온도가 들어왔습니다 \(tenDaysHighestCelsius)")
            
            if tenDaysHighestCelsiusDidSetCallCount == 1 {
                tableHighestCelsisus.append(contentsOf: tenDaysHighestCelsius)
            }
            
        }
    }
    
    
    var tenDaysLowestCelsius: [String] = [] {
        didSet {
            tenDaysLowestCelsisuDidSetCallCount += 1
            print("3~10일간 최저 온도가 들어왔습니다 \(tenDaysLowestCelsius)")
            
            if tenDaysLowestCelsisuDidSetCallCount == 1 {
                tableLowestCelsisus.append(contentsOf: tenDaysLowestCelsius)
            }
        }
    }
    
    
    
    
    // MARK: - "테이블 뷰"에 쓸 최고 / 최저 온도 데이터
    
    
    var tableHighestCelsisus: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    var tableLowestCelsisus: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(tableView)
        setupTableView()
        setupDelegate()
        registerTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupTableView() {
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(5)
            make.top.equalTo(self.snp.top).offset(5)
            make.trailing.equalTo(self.snp.trailing).offset(-5)
            make.bottom.equalTo(self.snp.bottom).offset(-5)
        }
    }
    
    
    func setupDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func registerTableViewCell() {
        tableView.register(TenDaysForecastTableViewCell.self, forCellReuseIdentifier: TenDaysForecastTableViewCell.identifier)
    }
    
    
    
    
}


extension TenDaysForecastView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("weekDayTableViewArray의 개수는 \(weekDayTableViewArray.count)")
        return weekDayTableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TenDaysForecastTableViewCell.identifier, for: indexPath) as! TenDaysForecastTableViewCell
        // 셀을 클릭할 때 아무런 색깔의 변화도 없게 만드는 코드
        cell.selectionStyle = .none
        cell.weekend.text = weekDayTableViewArray[indexPath.row]
        cell.highestTemperature.text = tableHighestCelsisus[indexPath.row]
        cell.lowestTemperature.text = tableLowestCelsisus[indexPath.row]
        cell.backgroundColor = .yellow
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60
     }
    
}


extension TenDaysForecastView: UITableViewDelegate {
    
}
