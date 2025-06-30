//
//  HomeService.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation
class HomeService{
    static let shared = HomeService()
    private init() {
        
    }
    
    //get all company data
    func getCompanyEvent(
        bodyData: Data? = nil,
        completion: @escaping (Result<Any, Error>) -> Void
    ) {
        HTTPClient.shared.sendRawJSON(
            endpoint: .getAllEvents,
            bodyData: bodyData,
            completion: completion
        )
    }
    
    //get exchange rates
    func getExchangeRates(
        bodyData: Data? = nil,
        completion:@escaping (Result<Any, Error>)->Void){
            HTTPClient.shared.sendRawJSON(
                endpoint: .exchangeRates,
                bodyData: bodyData,
                completion:completion
            )
        }
    
}

