//
//  ApiError.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

//network error section
enum ApiError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case unknown(Error)
}
