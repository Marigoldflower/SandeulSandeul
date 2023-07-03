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
    
    
    
    // MARK: - 요일 데이터
    
    var weekday = "" {
        didSet {
            print("현재 들어온 요일 값은 \(weekday)입니다")
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
            make.leading.equalTo(self.snp.leading)
            make.top.equalTo(self.snp.top)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TenDaysForecastTableViewCell.identifier, for: indexPath) as! TenDaysForecastTableViewCell
        // 셀을 클릭할 때 아무런 색깔의 변화도 없게 만드는 코드
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60
     }
    
}


extension TenDaysForecastView: UITableViewDelegate {
    
}
