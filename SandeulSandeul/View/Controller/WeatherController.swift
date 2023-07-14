//
//  ViewController.swift
//  SandeulSandeul
//
//  Created by 황홍필 on 2023/05/19.
//

import UIKit
import CoreLocation
import SnapKit
import Combine


class WeatherController: UIViewController {
    
    
    // MARK: - UI 객체
    
    
    let mainInformationView: MainInformationView = {
        let view = MainInformationView()
        view.backgroundColor = .dayBackground
        return view
    }()
    
    
    let todayForecastView: TodayForecastView = {
        let view = TodayForecastView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    
    
    let tenDaysForecastView: TenDaysForecastView = {
        let view = TenDaysForecastView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        view.backgroundColor = .yellow
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
    
    
    
    
    // MARK: - LocationManager
    let locationManager = CLLocationManager()
    
    
    
    // MARK: - ViewModel
    
    
    let shortTermForecastWeatherViewModel = ShortTermForecastWeatherViewModel()
    let longTermForecastWeatherViewModel = LongTermForecastWeatherViewModel()
    let particulateMatterViewModel = ParticulateMatterViewModel()
    let ultraParticulateMatterViewModel = UltraParticulateMatterViewModel()
    let sunsetAndSunriseViewModel = SunsetAndSunriseViewModel()
    
    
    
    
    // MARK: - ViewModel Publisher
    
    
    lazy var shortTermForecastWeatherPublisher = shortTermForecastWeatherViewModel.$shortTermForecastPublisher
    lazy var longTermForecastWeatherPublisher = longTermForecastWeatherViewModel.$longtermForecastPublisher
    lazy var particulateMatterPublisher = particulateMatterViewModel.$particulateMatterPublisher
    lazy var ultraParticulateMatterPublisher = ultraParticulateMatterViewModel.$ultraParticulateMatterPublisher
    lazy var sunsetAndSunrisePublisher = sunsetAndSunriseViewModel.$sunsetAndSunrisePublisher
    
    
    
    
    // MARK: - 미세먼지 네트워크 통신이 한 번만 일어나게끔 하는 저장용 변수
    
    var particulateMatterFetchCount = 0
    var ultraParticulateMatterFetchCount = 0
    
    
    
    
    // MARK: - 최고 & 최저 온도 통신이 한 번만 일어나게끔 하는 저장용 변수
    
    
    
    // MARK: - Cancellable
    
    // Subscriber가 받은 값을 저장해놓는 역할. 이 저장소가 없어지면 Publisher로부터 값을 받을 수 없게 된다.
    var cancellables: Set<AnyCancellable> = []
    
    
    // MARK: - Locations
    
    var myCoordinate: CLLocationCoordinate2D? {
        didSet {
            guard let myCoordinate = myCoordinate else { return }
            
            let latitude = Double(myCoordinate.latitude)
            let longitude = Double(myCoordinate.longitude)
            print("위도 값이 담겼습니다 \(latitude)")
            print("경도 값이 담겼습니다 \(longitude)")
            
            let latLong = convertGRID_GPS(lat_X: latitude, lng_Y: longitude)
            
            print("x값은 \(latLong.x)")
            print("y값은 \(latLong.y)")
            
            let currentTimeformatter = DateFormatter()
            currentTimeformatter.dateFormat = "HHmm"
//            let currentTime = currentTimeformatter.string(from: Date())
            
            // 3일 간의 예측 데이터를 가져옴 (구름 상태, 최고 온도 & 최저 온도)
            fetchShortTermForecastNetwork(x: latLong.x, y: latLong.y)
            
            let latitudeString = String(latitude)
            let longtitudeString = String(longitude)
            
            // 일출, 일몰을 네트워크를 통해 받아옴
            fetchSunsetAndSunriseNetwork(latitude: latitudeString, longtitude: longtitudeString)

        }
    }
    
    
    // 현재 위치를 알아내기 위해 필요한 변수
    var myCityLocation = "" {
        didSet {
            print("myCityLocation에 값이 담겼습니다! \(myCityLocation)")
            mainInformationView.currentLocation.text = "\(myCityLocation), "
            
            let cityCode = searchRegionCode(location: myCityLocation)
            print("지금 현재 도시의 CityCode는 \(cityCode)")
            
            fetchLongTermForecastNetwork(regionID: cityCode)
        }
    }
    
    
    // 미세먼지 농도를 알아내야 할 때 필요한 변수
    var myStateLocation = "" {
        didSet {
            print("myStateLocation에 값이 담겼습니다! \(myStateLocation)")
            // gyeonggi라는 결과값을 particulateMatterData에 할당한다.
            particulateMatterLocation = searchLocation(location: myStateLocation)
            ultraParticulateMatterLocation = searchLocation(location: myStateLocation)
            
        }
    }
    
    
    // gyeonggi 라는 값이 현재 담겨 있음. 추후에 switch문을 통해 gyeonggi 라는 값과 일치하는 값을 출력하도록 만들 것임
    var particulateMatterLocation = "" {
        didSet {
            fetchParticulateMatterNetwork(density: "PM10")
            bindCurrentData()
            print("particulateMatter 부분이 실행되었습니다")
        }
    }
    
    
    
    var ultraParticulateMatterLocation = "" {
        didSet {
            fetchUltraParticulateMatterNetwork(density: "PM25")
            bindCurrentData()
            print("ultraParticulateMatter 부분이 실행되었습니다.")
        }
    }
    
    // MARK: - 서치 컨트롤러
    
    let searchController = UISearchController(searchResultsController: SearchResultViewController())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .dayBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupLayout()
        fillStackView()
        setupLocation()
        searchResultControllerSetup()
        
        
    }
    
   
    
    
    func searchResultControllerSetup() {
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        
        // 서치 바의 색깔을 지정하는 방법
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.layer.cornerRadius = 10
        searchController.searchBar.searchTextField.backgroundColor = .searchControllerWhite
        
        
        searchController.searchBar.placeholder = "지역을 입력해주세요"
        
        // 서치 바의 높이를 사용자 임의로 지정하는 방법
        searchController.searchBar.updateHeight(height: 46)
        
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
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
        let companyArray = [mainInformationView, todayForecastView, tenDaysForecastView]
        for company in companyArray {
            var elementView = UIView()
            elementView = company
            elementView.translatesAutoresizingMaskIntoConstraints = false
            // ⭐️ 스크롤 방향이 세로 방향이면 widthAnchor에 값을 할당하는 부분은 지워도 된다.
            // elementView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            // ⭐️ 스크롤 방향이 가로 방향이면 heightAnchor에 값을 할당하는 부분은 지워도 된다.
            elementView.heightAnchor.constraint(equalToConstant: 1000).isActive = true
            stackView.addArrangedSubview(elementView)
        }
    }
    
    
    // 이 메소드가 실행되면 locationManager로 하여금 현재 위치를 업데이트 하도록 만든다.
    func setupLocation() {
        locationManager.delegate = self
        
        // 해당 앱이 사용자의 위치를 사용하도록 허용할지 물어보는 창을 띄운다.
        // (한 번 허용, 앱을 사용하는 동안 허용, 허용 안 함) 문구가 적혀있는 창을 띄움
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        locationManager.requestLocation()
        
    }
    
    
    
    // MARK: - DispatchGroup (Zip Operator를 사용하여)
    
    // 미세먼지 농도, 최고 & 최저 온도, 일출 & 일몰 시간을 다루는 Binding
    func bindCurrentData() {
        Publishers.Zip4(particulateMatterPublisher, ultraParticulateMatterPublisher, shortTermForecastWeatherPublisher, sunsetAndSunrisePublisher).receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .finished:
                print("모든 데이터가 잘 들어왔습니다")
            }
        
        } receiveValue: { [weak self] particulate, ultraParticulate, temperature, sunset in
            
            
            // MARK: - 일출 & 일몰 영역
            
            // 오늘 날짜 중 일출 & 일몰 시간 구하기
            
            guard let sunriseString = sunset?.results.sunrise else { return }
            guard let sunsetString = sunset?.results.sunset else { return }
            
            
            // 1. 먼저 Sunrise, Sunset을 Date 타입으로 만들어 UTC 시간보다 9시간 더 빠르게 만들 것이다.
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            
            guard let sunriseDate = formatter.date(from: sunriseString) else { return }
            guard let sunsetDate = formatter.date(from: sunsetString) else { return }
            
            let sunriseData = sunriseDate.addingTimeInterval(32400)
            let sunsetData = sunsetDate.addingTimeInterval(32400)
            
            
            // 2. 만들어진 Date 타입을 String 값으로 다시 변환하여 View에서 사용할 수 있도록 만들어준다.
            let sunDateFormatter = DateFormatter()
            sunDateFormatter.dateFormat = "HH:mm"
            
            let sunrise = sunDateFormatter.string(from: sunriseData)
            let sunset = sunDateFormatter.string(from: sunsetData)
            
            
            
            
//                    self?.mainInformationView.sunrise.attributedText = coloringTextMethod(text: "일출", colorText: sunrise, color: .nightDataText)
//                    self?.mainInformationView.sunset.attributedText = coloringTextMethod(text: "일몰", colorText: sunset, color: .nightDataText)
            
            
            // MARK: - 미세먼지 처리 영역
            
            
            guard let particulateMatterData = particulate?.particulateMatterResponse?.body?.items else { return }
            
            
            // particulateMatterLocation에는 "gyeonggi"가 들어가 있음
            guard let particulateMatterLocation = self?.particulateMatterLocation else { return }
//            self?.particulateMatterCalculatorAccordingToLocation(location: particulateMatterLocation, particulateData: particulateMatterData)
            
            
            
            // MARK: - 초미세먼지 처리 영역
            
            guard let ultraParticulateMatterData = ultraParticulate?.particulateMatterResponse?.body?.items else { return }
            
            // ultraParticulateMatterLocation에는 "gyeonggi"가 들어가 있음
            guard let ultraParticulateMatterLocation = self?.ultraParticulateMatterLocation else { return }
//            self?.particulateMatterCalculatorAccordingToLocation(location: ultraParticulateMatterLocation, particulateData: ultraParticulateMatterData)
            
            
            
            
            // MARK: - 현재 온도 처리 영역
            
            guard let temperatureData = temperature?.forecastResponse.forecastBody.forecastItems.forecastItem else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let today = dateFormatter.string(from: Date())
            
            
            
            for currentData in temperatureData {
                // 현재 날짜가 오늘 날짜인 경우
                if currentData.fcstDate == today {
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH"
                    let currentTime = timeFormatter.string(from: Date())
                    
                    // 현재 시간이 currentTime의 HH 값을 포함하고 있다면 (현재 시간에 속한다면)
                    if currentData.fcstTime.contains(currentTime) {
                        // TMP 코드 (현재 시간의 온도)만 골라서
                        if currentData.category.rawValue == "TMP" {
                            // 그 값을 todayWeatherCelsius 값에 할당한다.
                            self?.mainInformationView.todayWeatherCelsius.text = currentData.fcstValue
                            // 여기다가 현재 날씨 상태에 따라서 todayWeatherCelsius의 색깔을 변경시켜줘야 한다. (mainLabel)
                            self?.todayForecastView.todayTime = currentData.fcstTime
                            self?.todayForecastView.todayTemperature = currentData.fcstValue
                        }
                    }
                    
                    // MARK: - 날씨 상태 영역
                    
                    // 오늘의 강수 상태를 알아보는 영역
                    if currentData.category.rawValue == "PTY" {
                        
                        // PTY(강수상태)가 "0"이 아닐 때에만 실행하도록 함. 그렇지 않으면 이 코드는 그냥 지나간다.
                        if currentData.fcstValue != "0" {
                            let rain = "1"
                            let rainAndSnow = "2"
                            let snow = "3"
                            let sonagi = "4"
                            
                            // "이 영역에서" 각 날씨 별 적절한 색깔을 정해줘야 한다. 날씨 상태를 구분할 수 있는 곳이 이 곳밖에 없기 때문이다.
                            if currentData.fcstValue == rain {
                                self?.mainInformationView.currentSky.text = "비옴"
                                self?.changeColorAndUIAccordingToCurrentData(backgroundColor: .rainyBackground, imageColor: .rainyImage, mainLabelColor: .rainyMainLabel, sideLabelColor: .rainySideLabel, imageName: "cloud.rain.fill", sunset: sunset, sunrise: sunrise)

                            } else if currentData.fcstValue == rainAndSnow {
                                self?.mainInformationView.currentSky.text = "비와눈"
                            } else if currentData.fcstValue == snow {
                                self?.mainInformationView.currentSky.text = "눈옴"
                                self?.view.backgroundColor = .snowyBackground
                                self?.mainInformationView.backgroundColor = .snowyBackground
                            } else if currentData.fcstValue == sonagi {
                                self?.mainInformationView.currentSky.text = "소나기"
                                self?.view.backgroundColor = .rainyBackground
                                self?.mainInformationView.backgroundColor = .rainyBackground
                            }
                        }
                    }
                    
                    
                    // 그 후 SKY 코드를 읽게 한다.
                    if currentData.category.rawValue == "SKY" {
                        
                        // 오늘 날짜의 날씨를 보냄 (배열에서 사용할 것)
                        self?.todayForecastView.todayWeather = currentData.fcstValue
                        
                        let sunny = "1"
                        let cloudy = "3"
                        let blur = "4"
                        
                        if currentData.fcstValue == sunny {
                            self?.mainInformationView.currentSky.text = "맑음"
                        } else if currentData.fcstValue == cloudy {
                            self?.mainInformationView.currentSky.text = "구름많음"
                        } else if currentData.fcstValue == blur {
                            self?.mainInformationView.currentSky.text = "흐림"
                        }
                        
                    }
                    // MARK: - 최고 & 최저 온도 영역
                    
                    // 오늘 날짜 중 최고 온도일 경우
                    if currentData.category.rawValue == "TMX" {
                        
                        guard let todayWeather = self?.mainInformationView.todayWeatherCelsius.text else { return }
                        print("todayWeather의 값은 \(todayWeather)")
                        
                        let currentTemperature = Double(todayWeather) ?? 0.0
                        let highestTemperature = Double(currentData.fcstValue) ?? 0.0
                        
                        print("현재 온도는 \(currentTemperature)")
                        print("최고 온도는 \(highestTemperature)")
                        
                        // 현재 온도와 최고 온도를 비교해서 최고 온도가 더 적으면 현재 온도를 최고 온도로 할당한다.
                        if currentTemperature > highestTemperature {
                            let stringHighestTemperature = String(currentTemperature)
                            UserDefaults.standard.currentTemperature = stringHighestTemperature
//                            self?.mainInformationView.highestCelsius.attributedText = coloringTextMethod(text: "최고", colorText: UserDefaults.standard.currentTemperature + "°", color: .nightDataText)
                            
                        } else {
//                            self?.mainInformationView.highestCelsius.attributedText = coloringTextMethod(text: "최고", colorText: currentData.fcstValue + "°", color: .nightDataText)
                        }
                    }
                    
                    // 오늘 날짜 중 최저 온도일 경우
                    if currentData.category.rawValue == "TMN" {
//                        self?.mainInformationView.lowestCelsius.attributedText = coloringTextMethod(text: "최저", colorText: currentData.fcstValue + "°", color: .nightDataText)
                    }
                   
                    
                    
                    
                    
                    
                } // today
    
            } // currentData
            
        }.store(in: &cancellables)

    }
    
    
    
    
    
    
//    func collectAllFetchDataInThreeDays() {
//            Publishers.Zip3(shortTermForecastWeatherPublisher, particulateMatterPublisher, sunsetAndSunrisePublisher).receive(on: DispatchQueue.main).sink { completion in
//                switch completion {
//                case .finished:
//                    print("모든 데이터가 잘 들어왔습니다")
//                }
//            } receiveValue: { [weak self] shortTerm, particulate, sunset in // self의 RC값을 올리지 않음
//
//    //
//    //
//    //            // MARK: - Forecast 영역 (3일간의 모든 날씨 데이터를 가져오기 위한 영역)
//    //
//                guard let weatherData = shortTerm?.forecastResponse.forecastBody.forecastItems.forecastItem else { return }
//
//
//                // 단기 예보를 이용해 3일간 최고 기온과 최저 기온을 따옴
//                for currentWeather in weatherData {
//
//
//                    // MARK: - 오늘의 날짜 "yyyyMMdd" 형태로 변환
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "yyyyMMdd"
//                    let today = dateFormatter.string(from: Date())
//                    print("현재 날짜는 \(today)")
//
//                    let formatterTime = DateFormatter()
//                    formatterTime.dateFormat = "HHmm"
//                    let currentTimeCompare = formatterTime.string(from: Date())
//
//
//                    let newFormatter = DateFormatter()
//                    newFormatter.dateFormat = "HHmm "
//                    let dateToString = newFormatter.date(from: currentWeather.fcstTime)
//
//
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "HH"
//                    let date = formatter.string(from: dateToString ?? Date())
//                    print("현재 변환된 날짜는 \(date)")
//
//                    // MARK: - 온도 데이터를 배열에 담기 위함
//
//                    // 오늘 날짜라면
//                    if currentWeather.fcstDate.contains(today) {
//
//
//                        // 상태 코드를 TMP로 골라서
//                        if currentWeather.category.rawValue == "TMP" {
//
//                            // 현재 시간보다 더 뒤에 있는 시간만 코드 블럭을 실행하도록 한다.
//                            if currentTimeCompare < currentWeather.fcstTime {
//                                self?.todayForecastView.temperatureArray.append(currentWeather.fcstValue)
//                                self?.todayForecastView.timeArray.append(date)
//                            }
//                        }
//
//
//                    } else { // 오늘 날짜가 아니라면
//
//                        // 상태 코드가 TMP로 골라서
//                        if currentWeather.category.rawValue == "TMP" {
//                            self?.todayForecastView.temperatureArray.append(currentWeather.fcstValue)
//                            self?.todayForecastView.timeArray.append(date)
//                        }
//                    }
//
//
//
//                    // MARK: - 날씨 데이터를 배열에 담기 위함 (추후에 날씨 이미지를 할당하는 데에 사용)
//
//                    // 오늘 날짜라면
//                    if currentWeather.fcstDate.contains(today) {
//
//                        // 상태코드를 SKY로 골라서
//                        if currentWeather.category.rawValue == "SKY" {
//
//                            // 현재 시간보다 더 뒤에 있는 시간만 코드 블럭을 실행하도록 한다. (24시간 날씨 예측)
//                            if currentTimeCompare < currentWeather.fcstTime {
//                                self?.todayForecastView.weatherArray.append(currentWeather.fcstValue)
//                            }
//                        }
//                    } else { // 오늘 날짜가 아니라면
//
//                        // 상태코드를 SKY로 골라서
//                        if currentWeather.category.rawValue == "SKY" {
//                            self?.todayForecastView.weatherArray.append(currentWeather.fcstValue)
//                        }
//                    }
//
//
//
//                    // 예보날짜를 오늘로 설정 (오늘의 최고 온도와 최저 온도를 파악하기 위해 만듬 ⭐️)
//                    if currentWeather.fcstDate == today {
//
//                        let timeFormatter = DateFormatter()
//                        timeFormatter.dateFormat = "HH"
//                        let currentTime = timeFormatter.string(from: Date())
//                        print("현재 시간은 \(currentTime)")
//
//                        // 현재 시간이 currentTime의 HH 값을 포함하고 있다면
//                        if currentWeather.fcstTime.contains(currentTime) {
//                            // TMP 코드만 골라서
//                            if currentWeather.category.rawValue == "TMP" {
//                                // 그 값을 todayWeatherCelsius 값에 할당한다.
//                                self?.mainInformationView.todayWeatherCelsius.text = currentWeather.fcstValue
//
//
//                                // MARK: - 오늘 날짜의 시간과 온도를 보냄
//                                self?.todayForecastView.todayTime = currentWeather.fcstTime
//                                self?.todayForecastView.todayTemperature = currentWeather.fcstValue
//                            }
//
//
//                            // SKY 코드(구름상태) 보다 PTY 코드(강수상태) 를 먼저 컴파일러가 읽게 한다.
//                            if currentWeather.category.rawValue == "PTY" {
//
//                                // PTY(강수상태)가 "0"이 아닐 때에만 실행하도록 함. 그렇지 않으면 이 코드는 그냥 지나간다.
//                                if currentWeather.fcstValue != "0" {
//                                    let rain = "1"
//                                    let rainAndSnow = "2"
//                                    let snow = "3"
//                                    let sonagi = "4"
//
//                                    if currentWeather.fcstValue == rain {
//                                        self?.mainInformationView.currentSky.text = "비옴"
//                                    } else if currentWeather.fcstValue == rainAndSnow {
//                                        self?.mainInformationView.currentSky.text = "비와눈"
//                                    } else if currentWeather.fcstValue == snow {
//                                        self?.mainInformationView.currentSky.text = "눈옴"
//                                    } else if currentWeather.fcstValue == sonagi {
//                                        self?.mainInformationView.currentSky.text = "소나기"
//                                    }
//                                }
//                            }
//
//
//                            // 그 후 SKY 코드를 읽게 한다.
//                            if currentWeather.category.rawValue == "SKY" {
//
//                                // MARK: - 오늘 날짜의 날씨를 보냄
//                                self?.todayForecastView.todayWeather = currentWeather.fcstValue
//
//                                let sunny = "1"
//                                let cloudy = "3"
//                                let blur = "4"
//
//                                if currentWeather.fcstValue == sunny {
//                                    self?.mainInformationView.currentSky.text = "맑음"
//                                } else if currentWeather.fcstValue == cloudy {
//                                    self?.mainInformationView.currentSky.text = "구름많음"
//                                } else if currentWeather.fcstValue == blur {
//                                    self?.mainInformationView.currentSky.text = "흐림"
//                                }
//
//                            }
//                        }
//
//                        // 오늘을 기준으로 최고 온도일 경우 📌⭐️
//                        if currentWeather.category.rawValue == "TMX" {
//
//                            guard let todayWeather = self?.mainInformationView.todayWeatherCelsius.text else { return }
//                            print("todayWeather의 값은 \(todayWeather)")
//
//                            let currentTemperature = Double(todayWeather) ?? 0.0
//                            let highestTemperature = Double(currentWeather.fcstValue) ?? 0.0
//
//                            print("현재 온도는 \(currentTemperature)")
//                            print("최고 온도는 \(highestTemperature)")
//
//                            if currentTemperature > highestTemperature {
//                                let stringHighestTemperature = String(currentTemperature)
//                                UserDefaults.standard.currentTemperature = stringHighestTemperature
//                                self?.mainInformationView.highestCelsius.text = "최고: " + UserDefaults.standard.currentTemperature + "°"
//                                print("현재 온도가 실행되었습니다")
//                            } else {
//                                self?.mainInformationView.highestCelsius.text = "최고: " + currentWeather.fcstValue + "°"
//                                print("최고 온도가 실행되었습니다")
//                            }
//                        }
//
//                        // 오늘을 기준으로 최저 기온일 경우
//                        if currentWeather.category.rawValue == "TMN" {
//                            self?.mainInformationView.lowestCelsius.text = "최저: " + currentWeather.fcstValue + "°"
//                        }
//                    }
//                }
//
//
//                // MARK: - Sunset & Sunrise 영역 (일출과 일몰 시간을 파악하기 위함)
//
//                guard let sunriseString = sunset?.results.sunrise else { return }
//                guard let sunsetString = sunset?.results.sunset else { return }
//
//
//                // 1. 먼저 Sunrise, Sunset을 Date 타입으로 만들어 UTC 시간보다 9시간 더 빠르게 만들 것이다.
//                let formatter = DateFormatter()
//                formatter.timeStyle = .medium
//
//                guard let sunriseDate = formatter.date(from: sunriseString) else { return }
//                guard let sunsetDate = formatter.date(from: sunsetString) else { return }
//
//                let sunriseData = sunriseDate.addingTimeInterval(32400)
//                let sunsetData = sunsetDate.addingTimeInterval(32400)
//
//
//                // 2. 만들어진 Date 타입을 String 값으로 다시 변환하여 View에서 사용할 수 있도록 만들어준다.
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "HH:mm"
//
//                let sunrise = dateFormatter.string(from: sunriseData)
//                let sunset = dateFormatter.string(from: sunsetData)
//
//
//                self?.mainInformationView.sunrise.text = "일출: \(sunrise)"
//                self?.mainInformationView.sunset.text = "일몰: \(sunset)"
//
//            }.store(in: &cancellables)
//
//        }
//
//
//        func collectAllFetchDataInTenDays() {
//            Publishers.Zip(shortTermForecastWeatherPublisher, longTermForecastWeatherPublisher).receive(on: DispatchQueue.main).sink { completion in
//                switch completion {
//                case .finished:
//                    print("모든 데이터가 잘 들어왔습니다")
//                }
//            } receiveValue: { [weak self] shortTerm, longTerm in // self의 RC값을 올리지 않음
//
//                // MARK: - 3일간의 날씨 및 날짜 데이터
//
//                guard let shortTermData = shortTerm?.forecastResponse.forecastBody.forecastItems.forecastItem else { return }
//
//                for shortTerm in shortTermData {
//                    let newFormatter = DateFormatter()
//                    newFormatter.dateFormat = "yyyyMMdd"
//                    let shortTermDate = newFormatter.date(from: shortTerm.fcstDate)!
//
//                    let weekday: Int = Calendar.current.component(.weekday, from: shortTermDate)
//                    print("현재의 요일은 \(weekday)입니다.")
//
//
//                    // 3일간 최저 온도 데이터
//                    if shortTerm.category.rawValue == "TMN" {
//                        switch weekday {
//                        case 1:
//                            self?.tenDaysForecastView.weekDayArray.append("일")
//                        case 2:
//                            self?.tenDaysForecastView.weekDayArray.append("월")
//                        case 3:
//                            self?.tenDaysForecastView.weekDayArray.append("화")
//                        case 4:
//                            self?.tenDaysForecastView.weekDayArray.append("수")
//                        case 5:
//                            self?.tenDaysForecastView.weekDayArray.append("목")
//                        case 6:
//                            self?.tenDaysForecastView.weekDayArray.append("금")
//                        case 7:
//                            self?.tenDaysForecastView.weekDayArray.append("토")
//                        default:
//                            break
//                        }
//
//                        self?.tenDaysForecastView.threeDaysLowestCelsius.append(shortTerm.fcstValue)
//                    }
//
//
//                    // 3일 간 최고 온도 데이터
//                    if shortTerm.category.rawValue == "TMX" {
//                        self?.tenDaysForecastView.threeDaysHighestCelsius.append(shortTerm.fcstValue)
//                    }
//                }
//
//
//
//                // MARK: - 3~10일 사이의 날씨 및 날짜 데이터
//
//                guard let longTermData = longTerm?.response?.body?.items.item else { return }
//
//
//                for longTerm in longTermData {
//
//    //                let threeLow = "\(longTerm.taMin3)"
//                    let fourLow = "\(Double(longTerm.taMin4))"
//                    let fiveLow = "\(Double(longTerm.taMin5))"
//                    let sixLow = "\(Double(longTerm.taMin6))"
//                    let sevenLow = "\(Double(longTerm.taMin7))"
//                    let eigthLow = "\(Double(longTerm.taMin8))"
//                    let nineLow = "\(Double(longTerm.taMin9))"
//                    let tenLow =  "\(Double(longTerm.taMin10))"
//
//                    self?.tenDaysForecastView.tenDaysLowestCelsius.append(contentsOf: [fourLow, fiveLow, sixLow, sevenLow, eigthLow, nineLow, tenLow])
//
//
//    //                let threeHigh = "\(longTerm.taMax3)"
//                    let fourHigh = "\(Double(longTerm.taMax4))"
//                    let fiveHigh = "\(Double(longTerm.taMax5))"
//                    let sixHigh = "\(Double(longTerm.taMax6))"
//                    let sevenHigh = "\(Double(longTerm.taMax7))"
//                    let eightHigh = "\(Double(longTerm.taMax8))"
//                    let nineHigh = "\(Double(longTerm.taMax9))"
//                    let tenHigh = "\(Double(longTerm.taMax10))"
//
//                    self?.tenDaysForecastView.tenDaysHighestCelsius.append(contentsOf: [fourHigh, fiveHigh, sixHigh, sevenHigh, eightHigh, nineHigh, tenHigh])
//
//
//                }
//
//
//
//            }.store(in: &cancellables)
//        }
    
    
    // MARK: - Fetch Network
    
    
    func fetchShortTermForecastNetwork(x: Int, y: Int) {
        shortTermForecastWeatherViewModel.fetchWeatherNetwork(x: x, y: y)
    }
    
    func fetchLongTermForecastNetwork(regionID: String) {
        longTermForecastWeatherViewModel.fetchWeatherNetwork(regionID: regionID)
    }
    
    
    func fetchParticulateMatterNetwork(density: String) {
        particulateMatterViewModel.fetchWeatherNetwork(density: density)
    }
    
    
    func fetchUltraParticulateMatterNetwork(density: String) {
        ultraParticulateMatterViewModel.fetchWeatherNetwork(density: density)
    }
    
    
    func fetchSunsetAndSunriseNetwork(latitude: String, longtitude: String) {
        sunsetAndSunriseViewModel.fetchWeatherNetwork(latitude: latitude, longtitude: longtitude)
    }
    
    
    
    
    // MARK: - 지역에 따라 미세먼지 농도 데이터를 다르게 가져오는 메소드
    
    func particulateMatterCalculatorAccordingToLocation(location: String, particulateData: [ParticulateMatterItem], currentSky: String) {
        switch location {
        case "daegu":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daegu, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daegu, currentSky: currentSky)
                }
            }
        case "chungnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungnam, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungnam, currentSky: currentSky)
                }
            }
        case "incheon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].incheon, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].incheon, currentSky: currentSky)
                }
            }
        case "daejeon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].daejeon, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].daejeon, currentSky: currentSky)
                }
            }
        case "gyeongbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongbuk, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongbuk, currentSky: currentSky)
                }
            }
        case "sejong":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].sejong, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].sejong, currentSky: currentSky)
                }
            }
        case "gwangju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gwangju, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gwangju, currentSky: currentSky)
                }
            }
        case "jeonbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonbuk, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonbuk, currentSky: currentSky)
                }
            }
        case "gangwon":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gangwon, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gangwon, currentSky: currentSky)
                }
            }
        case "ulsan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].ulsan, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].ulsan, currentSky: currentSky)
                }
            }
        case "jeonnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeonnam, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeonnam, currentSky: currentSky)
                }
            }
        case "seoul":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].seoul, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].seoul, currentSky: currentSky)
                }
            }
        case "busan":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].busan, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].busan, currentSky: currentSky)
                }
            }
        case "jeju":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].jeju, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].jeju, currentSky: currentSky)
                }
            }
        case "chungbuk":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].chungbuk, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].chungbuk, currentSky: currentSky)
                }
            }
        case "gyeongnam":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeongnam, currentSky: currentSky)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeongnam, currentSky: currentSky)
                }
            }
        case "gyeonggi":
            for data in particulateData {
                if data.itemCode == "PM10" {
                    distributeParticulateMatter(density: particulateData[0].gyeonggi, currentSky: currentSky)
//                    distributeUltraParticulateMatter(location: particulateData[0].gyeonggi)
                } else {
                    distributeUltraParticulateMatter(density: particulateData[0].gyeonggi, currentSky: currentSky)
//                    distributeParticulateMatter(location: particulateData[0].gyeonggi)
                }
            }
        default: return

        }
    }
    
    
    // MARK: - 미세먼지 농도에 따라 좋음, 보통, 나쁨, 매우나쁨으로 나누는 메소드
    
    func distributeParticulateMatter(density: String, currentSky: String) {
        
        particulateMatterFetchCount += 1
        
        if particulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("미세먼지의 값은 \(myCurrentLocation)")
            
            
            switch myCurrentLocation {
            case ...30:
                
                if currentSky == "맑음" {
                    print("지금 이거 실행된 거 맞긴하냐?!")
                    self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorDay)
                    print("오키도키요~")
                } else if currentSky == "구름많음"  {
                    
                    print("지금 이거 실행된 거 맞긴하냐?!")
                    self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorDay)
                    print("오키도키요~")
                  
                } else {
                    print("지금 이거 실행된 거 맞긴하냐?!")
                    self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorNight)
                    print("잘됐으~")
                }
                
                // 밝은 날씨라면
//                if self.view.backgroundColor == .dayBackground {
//                    self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorNight)
//                // 어두운 날씨라면
//                } else {
//                    self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorNight)
//                }
            case 31...80:
                self.mainInformationView.particulateMatter.text = "미세: 보통"
//                self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "보통", color: .particulateNormalColorDay)
            case 81...150:
                self.mainInformationView.particulateMatter.text = "미세: 나쁨"
//                self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "나쁨", color: .particulateBadColorDay)
//                self.mainInformationView.particulateMatterStore = "미세: 나쁨"
            case 151...:
                self.mainInformationView.particulateMatter.text = "미세: 매우나쁨"
//                self.mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "매우나쁨", color: .particulateVeryBadColorDay)
//                self.mainInformationView.particulateMatterStore = "미세: 매우나쁨"
            default: return
            }
        }
    }
    
    
    func distributeUltraParticulateMatter(density: String, currentSky: String) {
        
        ultraParticulateMatterFetchCount += 1
        
        if ultraParticulateMatterFetchCount == 1 {
            guard let myCurrentLocation = Int(density) else { return }
            print("초미세먼지의 값은 \(myCurrentLocation)")
            switch myCurrentLocation {
            case ...15:
                self.mainInformationView.ultraParticulateMatter.text = "초미세: 좋음"
//                self.mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "좋음", color: .particulateGoodColorDay)
    //            self.mainInformationView.ultraParticulateMatterStore = "초미세: 좋음"
            case 16...35:
                self.mainInformationView.ultraParticulateMatter.text = "초미세: 보통"
//                self.mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "보통", color: .particulateNormalColorDay)
    //            self.mainInformationView.ultraParticulateMatterStore = "초미세: 보통"
            case 36...75:
                self.mainInformationView.ultraParticulateMatter.text = "초미세: 나쁨"
//                self.mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "나쁨", color: .particulateBadColorDay)
    //            self.mainInformationView.ultraParticulateMatterStore = "초미세: 나쁨"
            case 76...:
                self.mainInformationView.ultraParticulateMatter.text = "초미세: 매우나쁨"
//                self.mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "매우나쁨", color: .particulateVeryBadColorDay)
    //            self.mainInformationView.ultraParticulateMatterStore = "초미세: 매우나쁨"
            default: return
            }
        }
    }

    
    
    // MARK: - 현재 위치의 날씨에 따라 앱의 색깔 및 UI를 바꾸는 메소드
    
    
    // 미세먼지 색깔을 정하는 순서
    // 1. 우선 미세먼지의 농도 (좋음, 보통, 나쁨, 매우나쁨) 에 따라서 색깔을 정한다.
    // 2. 그 후, 날씨의 상태에 따라서 미세먼지의 농도의 색깔의 짙음과 옅음의 차이를 정해줘야 한다.
    
//                                self?.particulateMatterCalculatorAccordingToLocation(location: particulateMatterLocation, particulateData: particulateMatterData, currentSky: "비옴")
    
    // 이 메소드를 사용하기 위해서
    // 1. 우선 미세먼지의 농도 (좋음, 보통, 나쁨, 매우나쁨)을 구분할 수 있도록 변환해줘야 한다.
    // 그 과정은 다음과 같다.
    // 1-1) 나의 위치 에를 들면 경기도가 영어로 우선 변환된다. ("gyeonggi")
    // 1-2) "gyeonggi"라는 값을 가지고 Publisher와 함께 네트워크 메소드를 실행하여 해당 위치의 0번째 값을 리턴한다.
    // 1-3) 0번째 값에는 특정 숫자가 적혀 있으며 우리는 이 숫자를 switch하여 미세먼지의 농도를 구분한다.
    
    
    
    func changeColorAndUIAccordingToCurrentData(backgroundColor: UIColor, imageColor: UIColor, mainLabelColor: UIColor, sideLabelColor: UIColor, imageName: String, sunset: String, sunrise: String) {
        
        // backgroundColor
        view.backgroundColor = backgroundColor
        mainInformationView.backgroundColor = backgroundColor
        
        // imageName
        mainInformationView.todayWeatherImage.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate)
        
        // imageColor
        mainInformationView.todayWeatherImage.tintColor = imageColor
        
        // mainLabelColor
        mainInformationView.todayWeatherCelsius.textColor = mainLabelColor
        mainInformationView.celsiusLabel.textColor = mainLabelColor
        mainInformationView.currentLocation.textColor = mainLabelColor
        mainInformationView.currentSky.textColor = mainLabelColor
        
        // sideLabelColor
        mainInformationView.particulateMatter.textColor = sideLabelColor
        mainInformationView.particulateMatter.attributedText = coloringTextMethod(text: "미세", colorText: "좋음", color: .particulateGoodColorNight)
        mainInformationView.ultraParticulateMatter.textColor = sideLabelColor
        mainInformationView.ultraParticulateMatter.attributedText = coloringTextMethod(text: "초미세", colorText: "나쁨", color: .particulateVeryBadColorNight)
        
        
        mainInformationView.highestCelsius.textColor = sideLabelColor
        // 이 메소드를 사용하기 위해서 ForecastItem 타입인 파라미터를 가지고 있는 메소드를 하나 만들어야 한다.
        mainInformationView.highestCelsius.attributedText = coloringTextMethod(text: "최고", colorText: "26", color: .nightDataText)
        
        mainInformationView.lowestCelsius.textColor = sideLabelColor
        // 이 메소드를 사용하기 위해서 ForecastItem 타입인 파라미터를 가지고 있는 메소드를 하나 만들어야 한다.
        mainInformationView.lowestCelsius.attributedText = coloringTextMethod(text: "최저", colorText: "24", color: .nightDataText)
        
        mainInformationView.sunset.textColor = sideLabelColor
        mainInformationView.sunset.attributedText = coloringTextMethod(text: "일출", colorText: sunset, color: .nightDataText)
        
        mainInformationView.sunrise.textColor = sideLabelColor
        mainInformationView.sunrise.attributedText = coloringTextMethod(text: "일몰", colorText: sunrise, color: .nightDataText)

    }
    
    
}



extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // "앱을 사용하는 동안 허용", "한 번 허용" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 설정됨")
//            self.locationManager.requestLocation()
            self.locationManager.startUpdatingLocation() // 중요!
            self.locationManager.stopUpdatingLocation()
        case .restricted, .notDetermined:
            // 아직 사용자의 위치가 설정되지 않았을 때 이 부분이 실행된다.
            print("GPS 권한 설정되지 않음")
//            self.locationManager.requestLocation()
            setupLocation()
            self.locationManager.stopUpdatingLocation()
        case .denied:
            // "허용 안 함" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 요청 거부됨")
//            self.locationManager.requestLocation()
            setupLocation()
            self.locationManager.stopUpdatingLocation()
        default:
            print("GPS: Default")
        }
    }
    
    
    // 위도, 경도 정보를 얻는 메소드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 가장 최근 업데이트 된 위치를 설정
        //        guard let currentLocation = locations.first else { return }
        
        // 가장 최근 업데이트 된 위치를 설정
        let currentLocation = locations[locations.count - 1]
        
        // 최근 업데이트 된 위치의 위도와 경도를 설정
        let latitude = currentLocation.coordinate.latitude
        let longtitude = currentLocation.coordinate.longitude
        print("위도: \(latitude) | 경도: \(longtitude)")
        
        self.myCoordinate = currentLocation.coordinate
        
        
        let location = CLLocation(latitude: latitude, longitude: longtitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                print("Error:", error ?? "nil")
                return
            }
            print("지금 내가 살고 있는 지역은 \(placemark.city ?? "값이 없는데?")")
            self.myCityLocation = placemark.city ?? ""
            
            
            print("지금 내가 살고 있는 지역은 \(placemark.state ?? "값이 없는데?")")
            self.myStateLocation = placemark.state ?? ""
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        
    }
}


extension WeatherController: UISearchResultsUpdating {
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 ===> 일반적으로 다른 화면을 보여줄때 구현
    func updateSearchResults(for searchController: UISearchController) {
        print("서치바에 입력되는 단어", searchController.searchBar.text ?? "")
        // 글자를 치는 순간에 다른 화면을 보여주고 싶다면 (컬렉션뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        // 컬렉션뷰에 찾으려는 단어 전달
        // SearchResultController에 반드시 searchTerm 변수가 존재해야 한다.
        vc.searchTerm = searchController.searchBar.text ?? ""
    }
}

