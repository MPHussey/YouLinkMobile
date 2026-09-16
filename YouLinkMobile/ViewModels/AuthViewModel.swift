//
//  AuthViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import Foundation

class AuthViewModel:ObservableObject{
    @Published var isLoggedIn = false
    @Published var errorMessage:String?
    @Published var isLoading    = false

    //true while the launch-time credential check is running
    @Published var isCheckingSession = true

    init() {
        restoreSession()
    }

    //on launch: silently re-authenticate with the stored credentials
    func restoreSession() {
        isCheckingSession = true
        AuthService.shared.restoreSession { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .active, .offline:
                    self.isLoggedIn = true
                case .inactive, .noCredentials:
                    self.isLoggedIn = false
                }
                self.isCheckingSession = false
            }
        }
    }

    //login function
    func logIn(staffNumber: String,staffPassword:String) {
        guard !staffNumber.isEmpty, !staffPassword.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        AuthService.shared.login(staffNumber: staffNumber, password: staffPassword){res in
            DispatchQueue.main.async{
                self.isLoading = false
                switch res {
                case .success : self.isLoggedIn = true
                case .failure(let error) : self.errorMessage = error.localizedDescription
                }
            }
            
        }
        
    }
    
    //logout function
    func logOut() {
        AuthService.shared.logout()
        isLoggedIn = false
    }
}
