//
//  FlightInfo.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import Foundation

struct FlightInfo:Identifiable{
    let id=UUID()
    let flightNumber:String
    let callSign:String
    let departureDate:String
    let departureCode:String
    let departureStatus:String
    let departureStatusTime:String
    let arrivalCode:String
    let arrivalStatus:String
    let arrivalStatusTime:String
}
