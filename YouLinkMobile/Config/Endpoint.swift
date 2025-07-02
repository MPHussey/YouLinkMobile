//
//  Endpoint.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

enum Endpoint{
    //endpoint names to use throughout of the applciation
    case login
    case getAllEvents
    case exchangeRates
    case getFlightInfo
    
    //bind endpoint name with real endpoints
    var path:String{
        switch self{
        case .login: return "YouLinkAPI/api/Auth/login"
        case .getAllEvents: return "YouLinkAPI/api/Event/GetAllEvents"
        case .exchangeRates: return "YouLinkAPI/api/ExchangeRates/ExchangeRates"
        case .getFlightInfo: return "CMB_FlightInfoAll_API/api/FlightSchedule/GetFlights"
        }
    }
    
    //define bypass authentication requests
    var requiresAuth:Bool{
        switch self{
        default : return false
        }
    }
    
    //define require api-key or not
    var requiresApirKey:Bool{
        switch self{
        case .getFlightInfo : return true
        default : return false
        }
    }
    
    //define the request method GET, POST
    // case .getAllEvents : return "POST"
    var method:String{
        switch self{
        default : return "POST"
        }
    }
}

