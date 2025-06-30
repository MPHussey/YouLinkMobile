//
//  Endpoint.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

enum Endpoint{
    //deckare endpoint names to use throughout of the applciation
    case login
    case getAllEvents
    case exchangeRates
    
    //bind endpoint name with real endpoints
    var path:String{
        switch self{
        case .login: return "YouLinkAPI/api/Auth/login"
        case .getAllEvents: return "YouLinkAPI/api/Event/GetAllEvents"
        case .exchangeRates: return "YouLinkAPI/api/ExchangeRates/ExchangeRates"
        }
    }
    
    //define bypass requests
    var requiresAuth:Bool{
        switch self{
        default : return false
        }
    }
    
    //define require api-key or not
    var requiresApirKey:Bool{
        switch self{
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

