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

//    
//    func login(
//        staffNumber: String,
//        password: String,
//        completion: @escaping (Result<Void, Error>) -> Void
//    ) {
//        let p: [String:Any] = ["staffNumber": staffNumber, "password": password]
//        let d = try? JSONSerialization.data(withJSONObject: p)
//        HTTPClient.shared.sendRawJSON(endpoint: .login, bodyData: d) { res in
//            switch res {
//            case .success(let any):
//                guard
//                    let dict = any as? [String:Any],
//                    let tok  = dict["token"] as? String,
//                    dict["isValid"] as? Bool == true
//                else {
//                   // return completion(.failure(AuthError.invalidResponse))
//                }
//                self.currentToken = tok
//                completion(.success(()))
//            case .failure(let err):
//                completion(.failure(err))
//            }
//        }
//    }
    
}
