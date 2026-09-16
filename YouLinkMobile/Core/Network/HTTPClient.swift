//
//  HTTPClient.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

//a file to upload as part of a multipart/form-data request
struct MultipartFile: Identifiable {
    let id = UUID()
    var fieldName: String = "Attachments"
    let fileName: String
    let mimeType: String
    let data: Data
}

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

    /// Sends a request and decodes the JSON response into a `Decodable` type.
    /// - Parameters:
    ///   - endpoint: the API endpoint enum
    ///   - bodyData: optional JSON body (use nil for GET or no body)
    ///   - type: the `Decodable` type to decode the response into
    ///   - completion: result contains the decoded value or an Error
    func send<T: Decodable>(
        endpoint: Endpoint,
        bodyData: Data? = nil,
        decodeTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
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
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()

        } catch {
            completion(.failure(error))
        }
    }

    /// Sends a request and returns the raw response bytes (for binary downloads).
    /// - Parameters:
    ///   - endpoint: the API endpoint enum
    ///   - bodyData: optional JSON body
    ///   - completion: result contains the raw `Data` or an Error
    func downloadData(
        endpoint: Endpoint,
        bodyData: Data? = nil,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        do {
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
                completion(.success(data))
            }
            .resume()

        } catch {
            completion(.failure(error))
        }
    }

    /// Sends a multipart/form-data request (text fields + file uploads) and
    /// decodes the JSON response into a `Decodable` type.
    func sendMultipart<T: Decodable>(
        endpoint: Endpoint,
        fields: [String: String],
        files: [MultipartFile],
        decodeTo type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        do {
            //build the request without a JSON body, then attach the multipart body
            var request = try RequestBuilder.makeRequest(for: endpoint, bodyData: nil)
            let boundary = "Boundary-\(UUID().uuidString)"
            request.setValue(
                "multipart/form-data; boundary=\(boundary)",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpBody = Self.multipartBody(boundary: boundary, fields: fields, files: files)

            session.dataTask(with: request) { data, _, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let data = data else {
                    return completion(.failure(ApiError.noData))
                }
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            }
            .resume()

        } catch {
            completion(.failure(error))
        }
    }

    private static func multipartBody(
        boundary: String,
        fields: [String: String],
        files: [MultipartFile]
    ) -> Data {
        var body = Data()
        let lineBreak = "\r\n"

        for (key, value) in fields {
            body.appendString("--\(boundary)\(lineBreak)")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak)\(lineBreak)")
            body.appendString("\(value)\(lineBreak)")
        }

        for file in files {
            body.appendString("--\(boundary)\(lineBreak)")
            body.appendString("Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\(lineBreak)")
            body.appendString("Content-Type: \(file.mimeType)\(lineBreak)\(lineBreak)")
            body.append(file.data)
            body.appendString(lineBreak)
        }

        body.appendString("--\(boundary)--\(lineBreak)")
        return body
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
