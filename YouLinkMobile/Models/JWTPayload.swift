//
//  JWTPayload.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-01.
//

import Foundation

struct JWTPayload:Decodable{
    let sub: String
    let staffNumber: String
    let staffName: String
    let profilephoto: String
    let exp: TimeInterval
    let iss: String
    let aud: String
}
