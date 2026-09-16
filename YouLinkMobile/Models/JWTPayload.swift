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
    // Optional for now – the backend is expected to add these claims to the
    // token later; until then they decode as nil and the UI falls back.
    let designation: String?
    let contactNumber: String?
}
