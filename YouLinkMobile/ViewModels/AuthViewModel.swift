//
//  AuthViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import Foundation

class AuthViewModel:ObservableObject{
    @Published var isLoggedIn: Bool = false
    
    //login function
    func logIn() {
        isLoggedIn = true
    }
    
    //logout function
    func logOut() {
        isLoggedIn = false
    }
}
