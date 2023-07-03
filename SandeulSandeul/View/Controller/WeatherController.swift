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
        view.backgroundColor = .morningHoly
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
        view.backgroundColor = .red
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
    let sunsetAndSunriseViewModel = SunsetAndSunriseViewModel()
    
    
    
    
    
    
    // MARK: - ViewModel Publisher
    
    
    lazy var shortTermForecastWeatherPublisher = shortTermForecastWeatherViewModel.$shortTermForecastPublisher
    lazy var longTermForecastWeatherPublisher = longTermForecastWeatherViewModel.$longtermForecastPublisher
    lazy var particulateMatterPublisher = particulateMatterViewModel.$particulateMatterPublisher
    lazy var sunsetAndSunrisePublisher = sunsetAndSunriseViewModel.$sunsetAndSunrisePublisher
    
    
    
    
    
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
            let currentTime = currentTimeformatter.string(from: Date())
            
            // "오전 2시"를 기점으로 3일 간의 예측 데이터를 가져옴 (구름 상태, 최고 온도 & 최저 온도)
            fetchShortTermForecastNetwork(x: latLong.x, y: latLong.y, baseTime: "0200")
            
            
            let latitudeString = String(latitude)
            let longtitudeString = String(longitude)
            
            
            // 일출, 일몰을 네트워크를 통해 받아옴
            fetchSunsetAndSunriseNetwork(latitude: latitudeString, longtitude: longtitudeString)
            
            collectAllFetchDataInThreeDays()
            
        }
    }
    
    
    // 현재 위치를 알아내기 위해 필요한 변수
    var myCityLocation = "" {
        didSet {
            print("myCityLocation에 값이 담겼습니다! \(myCityLocation)")
            mainInformationView.todayWeatherIs.text = "현재 \(myCityLocation)는"
            
            var cityCode = searchRegionCode(location: myCityLocation)
            print("지금 현재 도시의 CityCode는 \(cityCode)")
            
            
        }
    }
    
    
    // 미세먼지 농도를 알아내야 할 때 필요한 변수
    var myStateLocation = "" {
        didSet {
            print("myStateLocation에 값이 담겼습니다! \(myStateLocation)")
            
            particulateMatterData = searchLocation(location: myStateLocation)
            ultraParticulateMatterData = searchLocation(location: myStateLocation)
            
        }
    }
    
    
    var particulateMatterData = "" {
        didSet {
            fetchParticulateMatterNetwork(density: "PM10")
            collectAllFetchDataInThreeDays()
        }
    }
    
    var ultraParticulateMatterData = "" {
        didSet {
            fetchParticulateMatterNetwork(density: "PM25")
            collectAllFetchDataInThreeDays()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .morningHoly
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        setupLayout()
        fillStackView()
        setupLocation()
        collectAllFetchDataInTenDays()
    }
    
    
    func setupLayout() {
        
        // MARK: - 뷰 레이아웃
        
        mainInformationView.snp.makeConstraints { make in
            make.height.equalTo(300)
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
        
    }
    
    
    
    // MARK: - DispatchGroup (Zip Operator를 사용하여)
    
    // 일단 Zip을 사용하니까 동시에 데이터가 들어오기는 한다.
    // Zip을 사용하면 데이터를 튜플 형태로 받아서 처리할 수 있다.
    // MergeMany는 튜플 형태는 아니고 각각 다른 Publisher 타입의 sink를 사용할 수 있다.
    func collectAllFetchDataInThreeDays() {
        Publishers.Zip3(shortTermForecastWeatherPublisher, particulateMatterPublisher, sunsetAndSunrisePublisher).receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .finished:
                print("모든 데이터가 잘 들어왔습니다")
            }
        } receiveValue: { [weak self] shortTerm, particulate, sunset in // self의 RC값을 올리지 않음
           
            
       
            // MARK: - Forecast 영역 (3일간의 모든 날씨 데이터를 가져오기 위한 영역)
            
            guard let weatherData = shortTerm?.forecastResponse.forecastBody.forecastItems.forecastItem else { return }
            
            
            // 단기 예보를 이용해 3일간 최고 기온과 최저 기온을 따옴
            for currentWeather in weatherData {
                
                
                // MARK: - 오늘의 날짜 "yyyyMMdd" 형태로 변환
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let today = dateFormatter.string(from: Date())
                print("현재 날짜는 \(today)")
                
                let formatterTime = DateFormatter()
                formatterTime.dateFormat = "HHmm"
                let currentTimeCompare = formatterTime.string(from: Date())
                
                
                let newFormatter = DateFormatter()
                newFormatter.dateFormat = "HHmm "
                let dateToString = newFormatter.date(from: currentWeather.fcstTime)
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH"
                let date = formatter.string(from: dateToString ?? Date())
                print("현재 변환된 날짜는 \(date)")
                
                // MARK: - 온도 데이터를 배열에 담기 위함
                
                // 오늘 날짜라면
                if currentWeather.fcstDate.contains(today) {
                    
                    
                    // 상태 코드를 TMP로 골라서
                    if currentWeather.category.rawValue == "TMP" {
                        
                        // 현재 시간보다 더 뒤에 있는 시간만 코드 블럭을 실행하도록 한다.
                        if currentTimeCompare < currentWeather.fcstTime {
                            self?.todayForecastView.temperatureArray.append(currentWeather.fcstValue)
                            self?.todayForecastView.timeArray.append(date)
                        }
                    }
                    
                    
                } else { // 오늘 날짜가 아니라면
                    
                    // 상태 코드가 TMP로 골라서
                    if currentWeather.category.rawValue == "TMP" {
                        self?.todayForecastView.temperatureArray.append(currentWeather.fcstValue)
                        self?.todayForecastView.timeArray.append(date)
                    }
                }
                
                
                
                // MARK: - 날씨 데이터를 배열에 담기 위함 (추후에 날씨 이미지를 할당하는 데에 사용)
                
                // 오늘 날짜라면
                if currentWeather.fcstDate.contains(today) {
                    
                    // 상태코드를 SKY로 골라서
                    if currentWeather.category.rawValue == "SKY" {
                        
                        // 현재 시간보다 더 뒤에 있는 시간만 코드 블럭을 실행하도록 한다. (24시간 날씨 예측)
                        if currentTimeCompare < currentWeather.fcstTime {
                            self?.todayForecastView.weatherArray.append(currentWeather.fcstValue)
                        }
                    }
                } else { // 오늘 날짜가 아니라면
                    
                    // 상태코드를 SKY로 골라서
                    if currentWeather.category.rawValue == "SKY" {
                        self?.todayForecastView.weatherArray.append(currentWeather.fcstValue)
                    }
                }
                
                
                
                // 예보날짜를 오늘로 설정 (오늘의 최고 온도와 최저 온도를 파악하기 위해 만듬 ⭐️)
                if currentWeather.fcstDate == today {
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH"
                    let currentTime = timeFormatter.string(from: Date())
                    print("현재 시간은 \(currentTime)")
                    
                    // 현재 시간이 currentTime의 HH 값을 포함하고 있다면
                    if currentWeather.fcstTime.contains(currentTime) {
                        // TMP 코드만 골라서
                        if currentWeather.category.rawValue == "TMP" {
                            // 그 값을 todayWeatherCelsius 값에 할당한다.
                            self?.mainInformationView.todayWeatherCelsius.text = currentWeather.fcstValue
                            
                            
                            // MARK: - 오늘 날짜의 시간과 온도를 보냄
                            self?.todayForecastView.todayTime = currentWeather.fcstTime
                            self?.todayForecastView.todayTemperature = currentWeather.fcstValue
                        }
         
                        
                        // SKY 코드(구름상태) 보다 PTY 코드(강수상태) 를 먼저 컴파일러가 읽게 한다.
                        if currentWeather.category.rawValue == "PTY" {
                            
                            // PTY(강수상태)가 "0"이 아닐 때에만 실행하도록 함. 그렇지 않으면 이 코드는 그냥 지나간다.
                            if currentWeather.fcstValue != "0" {
                                let rain = "1"
                                let rainAndSnow = "2"
                                let snow = "3"
                                let sonagi = "4"
                                
                                if currentWeather.fcstValue == rain {
                                    self?.mainInformationView.todaySky.text = "비옴"
                                } else if currentWeather.fcstValue == rainAndSnow {
                                    self?.mainInformationView.todaySky.text = "비와눈"
                                } else if currentWeather.fcstValue == snow {
                                    self?.mainInformationView.todaySky.text = "눈옴"
                                } else if currentWeather.fcstValue == sonagi {
                                    self?.mainInformationView.todaySky.text = "소나기"
                                }
                            }
                        }
                        
                        
                        // 그 후 SKY 코드를 읽게 한다.
                        if currentWeather.category.rawValue == "SKY" {

                            // MARK: - 오늘 날짜의 날씨를 보냄
                            self?.todayForecastView.todayWeather = currentWeather.fcstValue

                            let sunny = "1"
                            let cloudy = "3"
                            let blur = "4"

                            if currentWeather.fcstValue == sunny {
                                self?.mainInformationView.todaySky.text = "맑음"
                            } else if currentWeather.fcstValue == cloudy {
                                self?.mainInformationView.todaySky.text = "구름많음"
                            } else if currentWeather.fcstValue == blur {
                                self?.mainInformationView.todaySky.text = "흐림"
                            }

                        }
                    }
                    
                    // 오늘을 기준으로 최고 온도일 경우
                    if currentWeather.category.rawValue == "TMX" {
                        
                        guard let todayWeather = self?.mainInformationView.todayWeatherCelsius.text else { return }
                        print("todayWeather의 값은 \(todayWeather)")
                        
                        let currentTemperature = Double(todayWeather) ?? 0.0
                        let highestTemperature = Double(currentWeather.fcstValue) ?? 0.0
                        
                        print("현재 온도는 \(currentTemperature)")
                        print("최고 온도는 \(highestTemperature)")
                        
                        if currentTemperature > highestTemperature {
                            let stringHighestTemperature = String(currentTemperature)
                            UserDefaults.standard.currentTemperature = stringHighestTemperature
                            self?.mainInformationView.highestCelsius.text = "최고: " + UserDefaults.standard.currentTemperature + "°"
                            print("현재 온도가 실행되었습니다")
                        } else {
                            self?.mainInformationView.highestCelsius.text = "최고: " + currentWeather.fcstValue + "°"
                            print("최고 온도가 실행되었습니다")
                        }
                    }
                    
                    // 오늘을 기준으로 최저 기온일 경우
                    if currentWeather.category.rawValue == "TMN" {
                        self?.mainInformationView.lowestCelsius.text = "최저: " + currentWeather.fcstValue + "°"
                    }
                }
            }
            
            
            // MARK: - Particulate 영역 (미세먼지 농도를 파악하기 위함)
            
            
            // 이 영역을 메소드로 분리해서 파라미터로 넘겨주기 
            
            guard let particulateMatterData = particulate?.particulateMatterResponse.body.items else { return }
            
            // 미세먼지 농도
            // ~30: 좋음  ~80: 보통  ~150: 나쁨  151~: 매우나쁨
            
            
            print("현재 미세먼지의 값은 \(self?.particulateMatterData)")
            switch self?.particulateMatterData {
                
            case "daegu":
                self?.distributeParticulateMatter(location: particulateMatterData[0].daegu)
            case "chungnam":
                self?.distributeParticulateMatter(location: particulateMatterData[0].chungnam)
            case "incheon":
                self?.distributeParticulateMatter(location: particulateMatterData[0].incheon)
            case "daejeon":
                self?.distributeParticulateMatter(location: particulateMatterData[0].daejeon)
            case "gyeongbuk":
                self?.distributeParticulateMatter(location: particulateMatterData[0].gyeongbuk)
            case "sejong":
                self?.distributeParticulateMatter(location: particulateMatterData[0].sejong)
            case "gwangju":
                self?.distributeParticulateMatter(location: particulateMatterData[0].gwangju)
            case "jeonbuk":
                self?.distributeParticulateMatter(location: particulateMatterData[0].jeonbuk)
            case "gangwon":
                self?.distributeParticulateMatter(location: particulateMatterData[0].gangwon)
            case "ulsan":
                self?.distributeParticulateMatter(location: particulateMatterData[0].ulsan)
            case "jeonnam":
                self?.distributeParticulateMatter(location: particulateMatterData[0].jeonnam)
            case "seoul":
                self?.distributeParticulateMatter(location: particulateMatterData[0].seoul)
            case "busan":
                self?.distributeParticulateMatter(location: particulateMatterData[0].busan)
            case "jeju":
                self?.distributeParticulateMatter(location: particulateMatterData[0].jeju)
            case "chungbuk":
                self?.distributeParticulateMatter(location: particulateMatterData[0].chungbuk)
            case "gyeongnam":
                self?.distributeParticulateMatter(location: particulateMatterData[0].gyeongnam)
            case "gyeonggi":
                self?.distributeParticulateMatter(location: particulateMatterData[0].gyeonggi)
            default: return
                
            }
            
            print("현재 초미세먼지의 값은 \(self?.ultraParticulateMatterData)")
            switch self?.ultraParticulateMatterData {
                
                
            case "daegu":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].daegu)
            case "chungnam":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].chungnam)
            case "incheon":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].incheon)
            case "daejeon":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].daejeon)
            case "gyeongbuk":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].gyeongbuk)
            case "sejong":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].sejong)
            case "gwangju":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].gwangju)
            case "jeonbuk":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].jeonbuk)
            case "gangwon":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].gangwon)
            case "ulsan":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].ulsan)
            case "jeonnam":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].jeonnam)
            case "seoul":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].seoul)
            case "busan":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].busan)
            case "jeju":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].jeju)
            case "chungbuk":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].chungbuk)
            case "gyeongnam":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].gyeongnam)
            case "gyeonggi":
                self?.distributeUltraParticulateMatter(location: particulateMatterData[0].gyeonggi)
                print("지금 이 초미세먼지 메소드가 실행된 게 맞아?")
            default: return
                
            }
            
            
            
         
            // MARK: - Sunset & Sunrise 영역 (일출과 일몰 시간을 파악하기 위함)
            
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
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let sunrise = dateFormatter.string(from: sunriseData)
            let sunset = dateFormatter.string(from: sunsetData)
            
            
            self?.mainInformationView.sunrise.text = "일출: \(sunrise)"
            self?.mainInformationView.sunset.text = "일몰: \(sunset)"

        }.store(in: &cancellables)

    }
    
    
    func collectAllFetchDataInTenDays() {
        Publishers.Zip(shortTermForecastWeatherPublisher, longTermForecastWeatherPublisher).receive(on: DispatchQueue.main).sink { completion in
            switch completion {
            case .finished:
                print("모든 데이터가 잘 들어왔습니다")
            }
        } receiveValue: { [weak self] shortTerm, longterm in // self의 RC값을 올리지 않음
            
            guard let shortTermData = shortTerm?.forecastResponse.forecastBody.forecastItems.forecastItem else { return }
            
            for shortTerm in shortTermData {
                let newFormatter = DateFormatter()
                newFormatter.dateFormat = "yyyyMMdd"
                let shortTermDate = newFormatter.date(from: shortTerm.fcstDate)!
                
                let weekday: Int = Calendar.current.component(.weekday, from: shortTermDate)
                print("현재의 요일은 \(weekday)입니다.")
                
                switch weekday {
                case 1:
                    self?.tenDaysForecastView.weekday = "일"
                case 2:
                    self?.tenDaysForecastView.weekday = "월"
                case 3:
                    self?.tenDaysForecastView.weekday = "화"
                case 4:
                    self?.tenDaysForecastView.weekday = "수"
                case 5:
                    self?.tenDaysForecastView.weekday = "목"
                case 6:
                    self?.tenDaysForecastView.weekday = "금"
                case 7:
                    self?.tenDaysForecastView.weekday = "토"
                default:
                    break
                }
                
                
            }
            
            
        }
    }
    
    
    
    // MARK: - Fetch Network
    
    
    func fetchShortTermForecastNetwork(x: Int, y: Int, baseTime: String) {
        shortTermForecastWeatherViewModel.fetchWeatherNetwork(x: x, y: y, baseTime: baseTime)
    }
    
    func fetchLongTermForecastNetwork(regionID: String) {
        longTermForecastWeatherViewModel.fetchWeatherNetwork(regionID: regionID)
    }
    
    
    func fetchParticulateMatterNetwork(density: String) {
        particulateMatterViewModel.fetchWeatherNetwork(density: density)
    }
    
    
    func fetchSunsetAndSunriseNetwork(latitude: String, longtitude: String) {
        sunsetAndSunriseViewModel.fetchWeatherNetwork(latitude: latitude, longtitude: longtitude)
    }
    
    
    
    // MARK: - 미세먼지 농도에 따라 좋음, 보통, 나쁨, 매우나쁨으로 나누는 메소드
    
    func distributeParticulateMatter(location: String) {
        guard let myCurrentLocation = Int(location) else { return }
        print("미세먼지의 값은 \(myCurrentLocation)") // 미세먼지와 초미세먼지 값이 똑같은 값이 들어오고 있는 게 문제
        switch myCurrentLocation {
        case ...30:
            self.mainInformationView.particulateMatter.text = "미세: 좋음"
//            self.mainInformationView.particulateMatterStore = "미세: 좋음"
        case 31...80:
            self.mainInformationView.particulateMatter.text = "미세: 보통"
//            self.mainInformationView.particulateMatterStore = "미세: 보통"
        case 81...150:
            self.mainInformationView.particulateMatter.text = "미세: 나쁨"
//            self.mainInformationView.particulateMatterStore = "미세: 나쁨"
        case 151...:
            self.mainInformationView.particulateMatter.text = "미세: 매우나쁨"
//            self.mainInformationView.particulateMatterStore = "미세: 매우나쁨"
        default: return
        }
    }
    
    
    func distributeUltraParticulateMatter(location: String) {
        guard let myCurrentLocation = Int(location) else { return }
        print("초미세먼지의 값은 \(myCurrentLocation)")
        switch myCurrentLocation {
        case ...15:
            self.mainInformationView.ultraParticulateMatter.text = "초미세: 좋음"
//            self.mainInformationView.ultraParticulateMatterStore = "초미세: 좋음"
        case 16...35:
            self.mainInformationView.ultraParticulateMatter.text = "초미세: 보통"
//            self.mainInformationView.ultraParticulateMatterStore = "초미세: 보통"
        case 36...75:
            self.mainInformationView.ultraParticulateMatter.text = "초미세: 나쁨"
//            self.mainInformationView.ultraParticulateMatterStore = "초미세: 나쁨"
        case 76...:
            self.mainInformationView.ultraParticulateMatter.text = "초미세: 매우나쁨"
//            self.mainInformationView.ultraParticulateMatterStore = "초미세: 매우나쁨"
        default: return
        }
    }
    
}



extension WeatherController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // "앱을 사용하는 동안 허용", "한 번 허용" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 설정됨")
            self.locationManager.startUpdatingLocation() // 중요!
            
            self.locationManager.stopUpdatingLocation()
        case .restricted, .notDetermined:
            // 아직 사용자의 위치가 설정되지 않았을 때 이 부분이 실행된다.
            print("GPS 권한 설정되지 않음")
            setupLocation()
        case .denied:
            // "허용 안 함" 버튼을 클릭하면 이 부분이 실행된다.
            print("GPS 권한 요청 거부됨")
            setupLocation()
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
        
        
    }
}
