//
//  AuthViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import Foundation

class AuthViewModel:ObservableObject{
    @Published var isLoggedIn = AuthService.shared.isLoggedIn
    @Published var errorMessage:String?
    @Published var isLoading    = false
    
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
