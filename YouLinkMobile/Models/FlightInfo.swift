//
//  FlightInfo.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import Foundation
import SwiftUI

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
    
    // get the colors according to the status
    var departureColor: Color { FlightInfo.color(for: departureStatus) }
    var arrivalColor:   Color { FlightInfo.color(for: arrivalStatus) }
    
    //get the arrival and departure status colors
    private static func color(for status: String) -> Color {
        switch status {
        case "Early":  return Color(hex: "#00914a")
        case "Delay":  return Color(hex: "#ff0404")
        case "OnTime": return Color(hex: "#00639c")
        default:       return .primary
        }
    }
}
