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
    case getEmailList
    case markAsRead
    case emailAttachmentList
    case downloadAttachment
    case composeEmail
    case emailReply
    case mainCarousel
    
    //bind endpoint name with real endpoints
    var path:String{
        switch self{
        case .login: return "YouLinkMobileAPI/api/Auth/login"
        case .getAllEvents: return "YouLinkAPI/api/Event/GetAllEvents"
        case .exchangeRates: return "YouLinkAPI/api/ExchangeRates/ExchangeRates"
        case .getFlightInfo: return "CMB_FlightInfoAll_API/api/FlightSchedule/GetFlights"
        case .getEmailList:return "YouLinkMobileAPI/api/Email/read"
        case .markAsRead:return "YouLinkMobileAPI/api/Email/mark-as-read"
        case .emailAttachmentList:return "YouLinkMobileAPI/api/Email/attachments-list"
        case .downloadAttachment:return "YouLinkMobileAPI/api/Email/download-attachment"
        case .composeEmail:return "YouLinkMobileAPI/api/Email/send"
        case .emailReply:return "YouLinkMobileAPI/api/Email/reply"
        case .mainCarousel:return "YouLinkMobileAPI/api/Menu/main-carousel"
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
        case .mainCarousel : return "GET"
        default : return "POST"
        }
    }
}

