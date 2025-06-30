//
//  HTTPClient.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

class HTTPClient {
    static let shared = HTTPClient()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = NetworkConfig.requestTimeout
        session = URLSession(configuration: config)
    }
    
    /// Sends a request and returns a raw JSON object (Dictionary or Array)
    /// - Parameters:
    ///   - endpoint: the API endpoint enum
    ///   - bodyData: optional JSON body (use nil for GET or no body)
    ///   - completion: result contains `Any` JSON or an Error
    func sendRawJSON(
        endpoint: Endpoint,
        bodyData: Data? = nil,
        completion: @escaping (Result<Any, Error>) -> Void
    ) {
        do {
            // Build URLRequest (handles GET/POST, headers, API-keys)
            let request = try RequestBuilder.makeRequest(
                for: endpoint,
                bodyData: bodyData
            )
            
            session.dataTask(with: request) { data, _, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let data = data else {
                    return completion(.failure(ApiError.noData))
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()
            
        } catch {
            completion(.failure(error))
        }
    }
}
