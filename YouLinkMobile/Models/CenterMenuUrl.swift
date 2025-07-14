//
//  CenterMenuUrl.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-09.
//

import Foundation

struct CenterMenuUrl:Identifiable,Codable{
    var id=UUID()
    let label:String
    let url:String
    let keywords:[String]?
    
    private enum CodingKeys:String,CodingKey{
        case label,url,keywords
    }
}

typealias MenuData = [String: [CenterMenuUrl]]

