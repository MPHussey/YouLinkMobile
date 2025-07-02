//
//  ProfileViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-02.
//

import Foundation
import SwiftUI

class ProfileViewModel:ObservableObject{
    
    @Published var loggedInUserDetails:JWTPayload? = AuthService.shared.decodePayload()
}
