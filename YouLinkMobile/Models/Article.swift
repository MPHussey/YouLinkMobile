//
//  Article.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import Foundation
struct Article:Identifiable{
    let id=UUID()
    let date:String
    let title:String
    let subHeading:String
}

struct CompanyEvents{
    let eventId:String
    let heading:String
    let subheading:String
    let image:String
    let moreInfoLink:String
    let createDateTime:String
}


