//
//  AuthError.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-01.
//

import Foundation

enum AuthError:Error{
    case noData
    case invalidResponse
    case decodingError(Error)
    case tokenExpired
}
