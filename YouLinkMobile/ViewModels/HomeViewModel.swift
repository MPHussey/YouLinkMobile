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
    
    @Published var currencyRates: [CurrencyRate] = [
        .init(currencyCode: "AUD", conversionRate:"179.1814"),
        .init(currencyCode: "KWD", conversionRate:"870.1864"),
        .init(currencyCode: "GBP", conversionRate:"300.123"),
    ]

    
    
}
