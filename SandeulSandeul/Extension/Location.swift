//
//  CLLocation.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/06/05.
//

import Foundation
import CoreLocation
import Contacts


extension CLLocation {
    
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
    
}


extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
    @available(iOS 11.0, *)
    var postalAddressFormatted: String? {
        guard let postalAddress = postalAddress else { return nil }
        return CNPostalAddressFormatter().string(from: postalAddress)
    }
    
}


// MARK: - 우리나라 시도 명칭

var daegu: String { "대구광역시" }
var chungnam: String { "충청남도" }
var incheon: String { "인천광역시" }
var daejeon: String { "대전광역시" }
var gyeongbuk: String { "경상북도" }
var sejong: String { "세종특별자치시" }
var gwangju: String { "광주광역시" }
var jeonbuk: String { "전라북도" }
var gangwon: String { "강원도" }
var ulsan: String { "울산광역시" }
var jeonnam: String { "전라남도" }
var seoul: String { "서울특별시" }
var busan: String { "부산광역시" }
var jeju: String { "제주특별자치도" }
var chungbuk: String { "충청북도" }
var gyeongnam: String { "경상남도" }
var gyeonggi: String { "경기도" }

