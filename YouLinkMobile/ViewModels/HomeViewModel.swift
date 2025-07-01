//
//  HomeViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

class HomeViewModel:ObservableObject{
    @Published var featuredLinks:[FeaturedLink]=[
        .init(image: "bia-flight-icon", title:"BIA Flights"),
        .init(image: "safty-icon", title: "Safty"),
        .init(image: "crisis-management-icon", title: "Crisis Management")
    ]
    
    @Published var highlights:[HighLight] = [
        HighLight(title: "Company Holidays"),
        HighLight(title: "SVN"),
        HighLight(title: "Employee Manuals"),
        HighLight(title: "Travel Policy"),
        HighLight(title: "IT Support")
    ]
    
    @Published var fleetCardDataset: [FlightInfo] = [
        FlightInfo(
            flightNumber: "UL101",
            callSign: "A33-ALN",
            departureDate: "12 Jun 2025 22:22",
            departureCode: "CMB",
            departureStatus: "OnTime",
            departureStatusTime: "0",
            arrivalCode: "DXB",
            arrivalStatus: "Delay",
            arrivalStatusTime: "20"
        ),
        FlightInfo(
            flightNumber: "UL229",
            callSign: "A33-ALN",
            departureDate: "12 Jun 2025 22:22",
            departureCode: "CMB",
            departureStatus: "Delay",
            departureStatusTime: "15",
            arrivalCode: "SIN",
            arrivalStatus: "OnTime",
            arrivalStatusTime: "0"
        ),
        FlightInfo(
            flightNumber: "UL305",
            callSign: "A33-ALN",
            departureDate: "12 Jun 2025 22:22",
            departureCode: "CMB",
            departureStatus: "Early",
            departureStatusTime: "5",
            arrivalCode: "BKK",
            arrivalStatus: "OnTime",
            arrivalStatusTime: "0"
        ),
        FlightInfo(
            flightNumber: "UL503",
            callSign: "A33-ALN",
            departureDate: "12 Jun 2025 22:22",
            departureCode: "CMB",
            departureStatus: "OnTime",
            departureStatusTime: "0",
            arrivalCode: "LHR",
            arrivalStatus: "Early",
            arrivalStatusTime: "10"
        )
    ]
    
    @Published var currencyRates: [CurrencyRate] = []
    
    @Published var articles:[Article]=[]
    
    @Published var quickButtons:[FrequentButtons]=[
        FrequentButtons(title: "SARA", hex: "#0247A8", image:"sara-qa-icon"),
        FrequentButtons(title: "HR Space", hex: "#EB6127", image:"hrspace-qa-icon"),
        FrequentButtons(title: "Staff Travel", hex: "#0E9147", image:"staff-travel-qa-icon"),
        FrequentButtons(title: "medi-cash-qa-icon", hex: "#D71E43", image:"medi-cash-qa-icon")
    ]
    
    @Published var mainCarouselItems:[MainCarousel]=[
        MainCarousel(image: "slide-1"),
        MainCarousel(image: "slide-2"),
        MainCarousel(image: "slide-3")
    ]
    
    @Published var loggedInUserDetails:JWTPayload? = AuthService.shared.decodePayload()
    
    @Published var rawJson: Any?
    @Published var isLoading = false
    @Published var errorMessage:String?
    
    private let homeService = HomeService.shared
    
    func getExchangeRates(){
        let requestBody="{}".data(using:.utf8)
        
        homeService.getExchangeRates(bodyData:requestBody){[weak self] result in
            switch result{
            case .success(let json):
                guard let exchangeRateRawData=json as? [[String:Any]] else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Unexpected JSON format"
                    }
                    return
                }
                let mappedDataset=exchangeRateRawData.compactMap{dict -> CurrencyRate? in
                    guard
                        let fromCurrency = dict["from_Currency"] as? String,
                        let conversionRate = dict["conversion_Rate"] as? Double
                    else {return nil}
                    
                    return CurrencyRate(
                        currencyCode: fromCurrency,
                        conversionRate: String(format: "%.4f", conversionRate)
                    )
                }
                DispatchQueue.main.async{
                    self?.currencyRates=mappedDataset
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    //get official articles for the current year
    func getCompanyEvent() {
        
        //send empty body
        let requestBody = "{}".data(using: .utf8)
        
        homeService.getCompanyEvent(bodyData: requestBody) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            switch result {
            case .success(let json):
                guard let array = json as? [[String:Any]] else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Unexpected JSON format"
                    }
                    return
                }
                let mapped = array.compactMap { dict -> Article? in
                    guard
                        let heading       = dict["heading"]    as? String,
                        let subheading    = dict["subheading"] as? String,
                        let rawDateString = dict["createDateTime"] as? String
                    else { return nil }
                    
                    let inputFormatter = DateFormatter()
                    inputFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ss"
                    inputFormatter.locale        = Locale(identifier: "en_US_POSIX")
                    guard let date = inputFormatter.date(from: rawDateString)
                    else { return nil }
                    
                    let outputFormatter = DateFormatter()
                    outputFormatter.dateFormat = "dd-MM-yyyy"
                    let formattedDate = outputFormatter.string(from: date)
                    
                    return Article(
                        date: formattedDate,
                        title: subheading,
                        subHeading: heading
                    )
                }
                DispatchQueue.main.async {
                    self?.articles = mapped
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}


