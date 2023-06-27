//
//  QueryParameter.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/05.
//

import Foundation


extension String {
    
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}
