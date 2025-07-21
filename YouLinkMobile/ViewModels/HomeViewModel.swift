//
//  HomeViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

class HomeViewModel:ObservableObject{
    @Published var featuredLinks:[FeaturedLink]=[
        .init(image: "bia-flight-icon", title:"BIA Flights",redirectUrl: "https://www.airport.lk/"),
        .init(image: "safty-icon", title: "Safty",redirectUrl: "https://youlink.srilankan.com/SafetyInformationCentre"),
        .init(image: "crisis-management-icon", title: "Crisis Management",redirectUrl: "https://intraneti.srilankan.com/eruoneworld/index.html"),
        .init(image: "nivahana-icon", title: "Nivahana",redirectUrl: "https://intraneti.srilankan.com/welfare_society/FullCalendar/Index/B002"),
        .init(image: "welfare-icon", title: "Welfare",redirectUrl: "https://intraneti.srilankan.com/welfare_society/Home/index"),
        .init(image: "magazine-icon", title: "Magazine",redirectUrl: "https://youlink.srilankan.com/News/Pages/Magazines.aspx"),
        .init(image: "monara-icon", title: "Monara",redirectUrl: "https://youlink.srilankan.com/Corporate-Information/Pages/Monara.aspx"),
        
    ]
    
    @Published var highlights:[HighLight] = [
        HighLight(title: "Company Holidays",redirectUrl: "https://youlink.srilankan.com/Corporate-Information/Lists/ULCalendar/calendar.aspx"),
        HighLight(title: "SVN",redirectUrl: "https://intraneti.srilankan.com/svn/"),
        HighLight(title: "Employee Manuals",redirectUrl:"https://youlink.srilankan.com/Pages/Corporate-Policies.aspx"),
        HighLight(title: "Travel Policy",redirectUrl: "https://stafftravel.srilankan.com/"),
        HighLight(title: "IT Support",redirectUrl: "https://youlink.srilankan.com/sites/IT/")
    ]
    
    //Early -> #00914a
    //Delay ->  -> #ff0404
    //OnTime -> #00639c
    
    @Published var fleetCardDataset: [FlightInfo] = [
    ]
    
    @Published var currencyRates: [CurrencyRate] = []
    
    @Published var articles:[Article]=[]
    
    @Published var quickButtons:[FrequentButtons]=[
        FrequentButtons(title: "SARA", hex: "#0247A8", image:"sara-qa-icon",redirectUrl: "https://saraapp.srilankan.com/ux/myitapp/#/catalog/home"),
        FrequentButtons(title: "HR Space", hex: "#EB6127", image:"hrspace-qa-icon",redirectUrl: "https://youlink.srilankan.com/sites/HR/"),
        FrequentButtons(title: "Staff Travel", hex: "#0E9147", image:"staff-travel-qa-icon",redirectUrl: "https://stafftravel.srilankan.com/"),
        FrequentButtons(title: "MediCash", hex: "#D71E43", image:"medi-cash-qa-icon",redirectUrl: "https://intraneti.srilankan.com/medicash/login.asp")
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
    
    
    func getFlightInformation(){
        
        //get the from and to values relative to current datetime
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // subtract 13 hours
        let fromDate = Calendar.current.date(
            byAdding: .hour, value: -13, to: now
        )!
        // add 12 hours
        let toDate   = Calendar.current.date(
            byAdding: .hour, value: 12, to: now
        )!
        
        let fromString = formatter.string(from: fromDate)
        let toString   = formatter.string(from: toDate)
        
        // Build the JSON payload
        let payload: [String:String] = [
            "From": fromString,
            "To":   toString
        ]
        
        //convert it into a json string
        let bodyData = try? JSONSerialization
            .data(withJSONObject: payload, options: [])
        
        homeService.getFlightInformation(bodyData:bodyData){[weak self] result in
            switch result{
            case .success(let rawData):
                guard
                    let dict = rawData as? [String:Any],
                    let rawArray = dict["data"] as? [[String:Any]]
                else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Unexpected JSON format"
                    }
                    return
                }
                
                let utcFmt = DateFormatter()
                utcFmt.dateFormat = "yyyy-MM-dd HH.mm.ss"
                utcFmt.locale     = Locale(identifier: "en_US_POSIX")
                utcFmt.timeZone   = TimeZone(abbreviation: "UTC")
                
                let outFmt = DateFormatter()
                outFmt.dateFormat = "d MMM yyyy HH:mm"
                outFmt.locale     = Locale(identifier: "en_US_POSIX")
                
                let mapped: [FlightInfo] = rawArray.compactMap{ flightDict in
                    guard
                        let rawCallSign = flightDict["AC"] as? String,
                        !rawCallSign.contains("XXXX")
                    else { return nil }
                    
                    guard
                        let flightNumber = (flightDict["FLTID"] as? String)?
                            .replacingOccurrences(of: " ", with: ""),
                        let callSign     = flightDict["AC"]       as? String,
                        let depCode      = flightDict["DEPSTN"]   as? String,
                        let arrCode      = flightDict["ARRSTN"]   as? String,
                        let stdUTC       = flightDict["STD_UTC"]  as? String,
                        let atdUTC       = flightDict["ATD_UTC"]  as? String,
                        let staUTC       = flightDict["STA_UTC"]  as? String,
                        let ataUTC       = flightDict["ATA_UTC"]  as? String,
                        let stdDate      = utcFmt.date(from: stdUTC),
                        let atdDate      = utcFmt.date(from: atdUTC),
                        let staDate      = utcFmt.date(from: staUTC),
                        let ataDate      = utcFmt.date(from: ataUTC)
                    else{
                        return nil
                    }
                    
                    // departure delay in minutes
                    let depDiff  = Int(atdDate.timeIntervalSince(stdDate) / 60)
                    let depStatus: String
                    if depDiff < 0 {
                        depStatus = "Early"
                    } else if depDiff == 0 || depDiff < 15 {
                        depStatus = "OnTime"
                    } else {
                        depStatus = "Delay"
                    }
                    let depTimeStr = String(abs(depDiff))
                    
                    // arrival delay in minutes
                    let arrDiff  = Int(ataDate.timeIntervalSince(staDate) / 60)
                    let arrStatus: String
                    if arrDiff < 0 {
                        arrStatus = "Early"
                    } else if arrDiff == 0 || arrDiff < 15 {
                        arrStatus = "OnTime"
                    } else {
                        arrStatus = "Delay"
                    }
                    let arrTimeStr = String(abs(arrDiff))
                    
                    // formatted departure date for display
                    let departureDisplay = outFmt.string(from: stdDate)
                    
                    return FlightInfo(
                        flightNumber:     flightNumber,
                        callSign:         callSign,
                        departureDate:    departureDisplay,
                        departureCode:    depCode,
                        departureStatus:  depStatus,
                        departureStatusTime: depTimeStr,
                        arrivalCode:      arrCode,
                        arrivalStatus:    arrStatus,
                        arrivalStatusTime:   arrTimeStr
                    )
                        
                }
                DispatchQueue.main.async {
                    self?.fleetCardDataset = mapped
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
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


