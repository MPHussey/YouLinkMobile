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
    let profilephoto: String?
    let exp: TimeInterval
    let iss: String
    let aud: String
    // profile claims - optional so older tokens without them still decode
    let department: String?
    let email: String?
    let title: String?      // designation shown on the profile
    let mobile: String?     // contact number shown on the profile
}
