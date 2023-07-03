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




// MARK: - 미세먼지 농도를 측정하기 위해 필요한 지역 이름을 담은 메소드

func searchLocation(location: String) -> String{
    switch location {
    case daegu:
        return "daegu"
    case chungnam:
        return "chungnam"
    case incheon:
        return "incheon"
    case daejeon:
        return "daejeon"
    case gyeongbuk:
        return "gyeongbuk"
    case sejong:
        return "sejong"
    case gwangju:
        return "gwangju"
    case jeonbuk:
        return "jeonbuk"
    case gangwon:
        return "gangwon"
    case ulsan:
        return "ulsan"
    case jeonnam:
        return "jeonnam"
    case seoul:
        return "seoul"
    case busan:
        return "busan"
    case jeju:
        return "jeju"
    case chungbuk:
        return "chungbuk"
    case gyeongnam:
        return "gyeongnam"
    case gyeonggi:
        return "gyeonggi"
    default: return ""
    }
}




// MARK: - 우리나라 Region Code

// 이 함수의 결과값을 변수에 일단 담고 그 변수를 regionCode의 주소값에 넣어주면 된다.
func searchRegionCode(location: String) -> String {
    
    if location.contains("백령도") {
        return "11A00101"
    } else if location.contains("서울") {
        return "11B10101"
    } else if location.contains("과천") {
        return "11B10102"
    } else if location.contains("광명") {
        return "11B10103"
    } else if location.contains("강화") {
        return "11B20101"
    } else if location.contains("김포") {
        return "11B20102"
    } else if location.contains("인천") {
        return "11B20201"
    } else if location.contains("시흥") {
        return "11B20202"
    } else if location.contains("안산") {
        return "11B20203"
    } else if location.contains("부천") {
        return "11B20204"
    } else if location.contains("의정부") {
        return "11B20301"
    } else if location.contains("고양") {
        return "11B20302"
    } else if location.contains("양주") {
        return "11B20304"
    } else if location.contains("파주") {
        return "11B20305"
    } else if location.contains("동두천") {
        return "11B20401"
    } else if location.contains("연천") {
        return "11B20402"
    } else if location.contains("포천") {
        return "11B20403"
    } else if location.contains("가평") {
        return "11B20404"
    } else if location.contains("구리") {
        return "11B20501"
    } else if location.contains("남양주") {
        return "11B20502"
    } else if location.contains("양평") {
        return "11B20503"
    } else if location.contains("하남") {
        return "11B20504"
    } else if location.contains("수원") {
        return "11B20601"
    } else if location.contains("안양") {
        return "11B20602"
    } else if location.contains("오산") {
        return "11B20603"
    } else if location.contains("화성") {
        return "11B20604"
    } else if location.contains("성남") {
        return "11B20605"
    } else if location.contains("평택") {
        return "11B20606"
    } else if location.contains("의왕") {
        return "11B20609"
    } else if location.contains("군포") {
        return "11B20610"
    } else if location.contains("안성") {
        return "11B20611"
    } else if location.contains("용인") {
        return "11B20612"
    } else if location.contains("이천") {
        return "11B20701"
    } else if location.contains("광주") {
        return "11B20702"
    } else if location.contains("여주") {
        return "11B20703"
    } else if location.contains("충주") {
        return "11C10101"
    } else if location.contains("진천") {
        return "11C10102"
    } else if location.contains("음성") {
        return "11C10103"
    } else if location.contains("제천") {
        return "11C10201"
    } else if location.contains("단양") {
        return "11C10202"
    } else if location.contains("청주") {
        return "11C10301"
    } else if location.contains("보은") {
        return "11C10302"
    } else if location.contains("괴산") {
        return "11C10303"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("추풍령") {
        return "11C10401"
    } else if location.contains("영동") {
        return "11C10402"
    } else if location.contains("옥천") {
        return "11C10403"
    } else if location.contains("서산") {
        return "11C20101"
    } else if location.contains("태안") {
        return "11C20102"
    } else if location.contains("당진") {
        return "11C20103"
    } else if location.contains("홍성") {
        return "11C20104"
    } else if location.contains("보령") {
        return "11C20201"
    } else if location.contains("서천") {
        return "11C20202"
    } else if location.contains("천안") {
        return "11C20301"
    } else if location.contains("아산") {
        return "11C20302"
    } else if location.contains("예산") {
        return "11C20303"
    } else if location.contains("대전") {
        return "11C20401"
    } else if location.contains("공주") {
        return "11C20402"
    } else if location.contains("계룡") {
        return "11C20403"
    } else if location.contains("세종") {
        return "11C20404"
    } else if location.contains("부여") {
        return "11C20501"
    } else if location.contains("청양") {
        return "11C20502"
    } else if location.contains("금산") {
        return "11C20601"
    } else if location.contains("논산") {
        return "11C20602"
    } else if location.contains("철원") {
        return "11D10101"
    } else if location.contains("화천") {
        return "11D10102"
    } else if location.contains("인제") {
        return "11D10201"
    } else if location.contains("양구") {
        return "11D10202"
    } else if location.contains("춘천") {
        return "11D10301"
    } else if location.contains("홍천") {
        return "11D10302"
    } else if location.contains("원주") {
        return "11D10401"
    } else if location.contains("횡성") {
        return "11D10402"
    } else if location.contains("영월") {
        return "11D10501"
    } else if location.contains("정선") {
        return "11D10502"
    } else if location.contains("평창") {
        return "11D10503"
    } else if location.contains("대관령") {
        return "11D20201"
    } else if location.contains("태백") {
        return "11D20301"
    } else if location.contains("속초") {
        return "11D20401"
    } else if location.contains("고성") {
        return "11D20402"
    } else if location.contains("양양") {
        return "11D20403"
    } else if location.contains("강릉") {
        return "11D20501"
    } else if location.contains("동해") {
        return "11D20601"
    } else if location.contains("삼척") {
        return "11D20602"
    } else if location.contains("울릉도") {
        return "1.10E+102"
    } else if location.contains("독도") {
        return "1.10E+103"
    } else if location.contains("전주") {
        return "11F10201"
    } else if location.contains("익산") {
        return "11F10202"
    } else if location.contains("정읍") {
        return "11F10203"
    } else if location.contains("완주") {
        return "11F10204"
    } else if location.contains("장수") {
        return "11F10301"
    } else if location.contains("무주") {
        return "11F10302"
    } else if location.contains("진안") {
        return "11F10303"
    } else if location.contains("남원") {
        return "11F10401"
    } else if location.contains("임실") {
        return "11F10402"
    } else if location.contains("순창") {
        return "11F10403"
    } else if location.contains("군산") {
        return "21F10501"
    } else if location.contains("김제") {
        return "21F10502"
    } else if location.contains("고창") {
        return "21F10601"
    } else if location.contains("부안") {
        return "21F10602"
    } else if location.contains("함평") {
        return "21F20101"
    } else if location.contains("영광") {
        return "21F20102"
    } else if location.contains("진도") {
        return "21F20201"
    } else if location.contains("완도") {
        return "11F20301"
    } else if location.contains("해남") {
        return "11F20302"
    } else if location.contains("강진") {
        return "11F20303"
    } else if location.contains("장흥") {
        return "11F20304"
    } else if location.contains("여수") {
        return "11F20401"
    } else if location.contains("광양") {
        return "11F20402"
    } else if location.contains("고흥") {
        return "11F20403"
    } else if location.contains("보성") {
        return "11F20404"
    } else if location.contains("순천시") {
        return "11F20405"
    } else if location.contains("광주") {
        return "11F20501"
    } else if location.contains("장성") {
        return "11F20502"
    } else if location.contains("나주") {
        return "11F20503"
    } else if location.contains("담양") {
        return "11F20504"
    } else if location.contains("화순") {
        return "11F20505"
    } else if location.contains("구례") {
        return "11F20601"
    } else if location.contains("곡성") {
        return "11F20602"
    } else if location.contains("순천") {
        return "11F20603"
    } else if location.contains("흑산도") {
        return "11F20701"
    } else if location.contains("목포") {
        return "21F20801"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    } else if location.contains("증평") {
        return "11C10304"
    }
        
        
    else if location.contains("용인") {
        return "11B20612"
    }
    
    return ""
}

