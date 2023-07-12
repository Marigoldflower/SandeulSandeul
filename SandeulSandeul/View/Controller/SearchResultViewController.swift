//
//  SearchResultController.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/07/10.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var searchTerm: String? {
        didSet {
            setupDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func setupDatas() {
        
    }
}
