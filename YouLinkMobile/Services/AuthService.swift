//
//  AuthService.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-01.
//

import Foundation
class AuthService{
    static let shared = AuthService()
    private init() {}
    
    private let service = "com.srilankan.YouLinkMobile"
    private let account = "authToken"
    
    var currentToken: String? {
        get {
            (try? KeychainHelper.read(service: service, account: account))
                .flatMap { String(data: $0, encoding: .utf8) }
        }
        set {
            do {
                if let tok = newValue {
                    try KeychainHelper.save(
                        Data(tok.utf8),
                        service: service,
                        account: account
                    )
                } else {
                    try KeychainHelper.delete(service: service, account: account)
                }
            } catch {
                print("� Keychain error: \(error)")
            }
        }
    }

    //on login button press triggers the function
    func login(
        staffNumber: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let p: [String:Any] = ["staffNumber": staffNumber, "password": password]
        let d = try? JSONSerialization.data(withJSONObject: p)
        HTTPClient.shared.sendRawJSON(endpoint: .login, bodyData: d) { res in
            switch res {
            case .success(let any):
                guard
                    let dict = any as? [String:Any],
                    let tok  = dict["token"] as? String,
                    dict["isValid"] as? Bool == true
                else {
                    return completion(.failure(AuthError.invalidResponse))
                }
                self.currentToken = tok
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    //check currect user has the access for login
    var isLoggedIn: Bool {
        guard let payload = decodePayload() else { return false }
        return Date().timeIntervalSince1970 < payload.exp
    }
    
    //decode current token details
    func decodePayload() -> JWTPayload? {
        guard let token = currentToken else { return nil }
        let parts = token.split(separator: ".")
        guard parts.count == 3 else { return nil }
        var b64 = String(parts[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let mod = b64.count % 4
        if mod > 0 { b64 += String(repeating: "=", count: 4 - mod) }
        guard let d = Data(base64Encoded: b64),
              let pl = try? JSONDecoder().decode(JWTPayload.self, from: d)
        else { return nil }
        return pl
    }
    
    //logout the user by clearing current token
    func logout() {
        currentToken = nil
    }
    
}
