//
//  AuthService.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-01.
//

import Foundation

//credentials the user typed at sign-in, kept in the keychain for silent re-auth
struct StoredCredentials: Codable {
    let staffNumber: String
    let password: String
}

//outcome of the launch-time session restore
enum SessionResult {
    case active         // re-auth succeeded -> token refreshed
    case offline        // re-auth failed on network, but local token still valid
    case inactive       // server rejected the user -> logged out
    case noCredentials  // nothing stored -> show login
}

class AuthService{
    static let shared = AuthService()
    private init() {}

    private let service = "com.srilankan.YouLinkMobile"
    private let account = "authToken"
    private let credentialsAccount = "credentials"

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

    //user credentials stored as JSON in the keychain
    var storedCredentials: StoredCredentials? {
        get {
            guard
                let data = try? KeychainHelper.read(service: service, account: credentialsAccount)
            else { return nil }
            return try? JSONDecoder().decode(StoredCredentials.self, from: data)
        }
        set {
            do {
                if let creds = newValue {
                    let data = try JSONEncoder().encode(creds)
                    try KeychainHelper.save(data, service: service, account: credentialsAccount)
                } else {
                    try KeychainHelper.delete(service: service, account: credentialsAccount)
                }
            } catch {
                print("� Keychain credentials error: \(error)")
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
                //keep the credentials for silent re-auth on the next launch
                self.storedCredentials = StoredCredentials(
                    staffNumber: staffNumber,
                    password: password
                )
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    //on launch: re-send stored credentials to confirm the user is still active
    func restoreSession(completion: @escaping (SessionResult) -> Void) {
        guard let creds = storedCredentials else {
            return completion(.noCredentials)
        }

        login(staffNumber: creds.staffNumber, password: creds.password) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                completion(.active)
            case .failure(let error):
                if let authError = error as? AuthError,
                   case .invalidResponse = authError {
                    //server responded but rejected the user -> no longer active
                    self.logout()
                    completion(.inactive)
                } else {
                    //network / transport error -> allow offline access if token still valid
                    if self.isLoggedIn {
                        completion(.offline)
                    } else {
                        self.logout()
                        completion(.inactive)
                    }
                }
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
    
    //logout the user by clearing the token and stored credentials
    func logout() {
        currentToken = nil
        storedCredentials = nil
    }
    
}
