//
//  RequestBuilder.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation
struct RequestBuilder{
    
    static func makeRequest(
        for endpoint: Endpoint,
        bodyData:Data?
    ) throws -> URLRequest {
        //  Construct full URL
        let url = NetworkConfig.baseURL
            .appendingPathComponent(endpoint.path)
        
        //  Create request with your cache & timeout settings
        var req = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: NetworkConfig.requestTimeout
        )
        
        // Set HTTP method
        req.httpMethod = endpoint.method
        
        // add body if needed
        if let body = bodyData {
            req.httpBody = body
            req.setValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        }
        
        
        
        // Inject token if needed
//        if endpoint.requiresAuth,
//           let token = AuthService.shared.currentToken {
//            req.setValue("Bearer \(token)",
//                         forHTTPHeaderField: "Authorization")
//        }
        
        //  Inject API key if needed
        if endpoint.requiresApirKey {
            req.setValue(NetworkConfig.apiKey,
                         forHTTPHeaderField: "x-api-key")
        }
        
        return req
    }
    
    
    
}
