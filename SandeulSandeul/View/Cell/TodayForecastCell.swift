//
//  TodayForecastCell.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/09.
//

import UIKit
import SnapKit

final class TodayForecastCell: UICollectionViewCell {
    
    static let identifier = "TodayForecastCell"
    
    let time: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let weatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
        
    let temperature: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    // MARK: - StackView
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [time, weatherImage, temperature])
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(stackView)
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.leading).offset(20)
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    
}


