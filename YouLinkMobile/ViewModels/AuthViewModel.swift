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
    
    
    //login function
    func logIn(staffNumber: String,StaffPassword:String) {
        AuthService.shared.login(staffNumber: staffNumber, password: StaffPassword){res in
            DispatchQueue.main.async{
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
