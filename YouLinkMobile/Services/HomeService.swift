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
    
    
    //get flight infomation
    func getFlightInformation(
        bodyData: Data? = nil,
        completion:@escaping (Result<Any, Error>)->Void){
            HTTPClient.shared.sendRawJSON(
                endpoint: .getFlightInfo,
                bodyData: bodyData,
                completion:completion
            )
        }

    //get main carousel slides
    func getMainCarousel(
        bodyData: Data? = nil,
        completion:@escaping (Result<[MainCarousel], Error>)->Void){
            HTTPClient.shared.send(
                endpoint: .mainCarousel,
                bodyData: bodyData,
                decodeTo: [MainCarousel].self,
                completion:completion
            )
        }

    //get the quick links shown in the featured links section
    func getQuickLinks(
        bodyData: Data? = nil,
        completion:@escaping (Result<[FeaturedLink], Error>)->Void){
            HTTPClient.shared.send(
                endpoint: .quickLinks,
                bodyData: bodyData,
                decodeTo: [FeaturedLink].self,
                completion:completion
            )
        }

    //get the center menu links grouped by section (applications, corporate, divisions)
    func getApplicationMenu(
        bodyData: Data? = nil,
        completion:@escaping (Result<MenuData, Error>)->Void){
            HTTPClient.shared.send(
                endpoint: .applicationMenu,
                bodyData: bodyData,
                decodeTo: MenuData.self,
                completion:completion
            )
        }

}

