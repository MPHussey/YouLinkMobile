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
    
    var staffName: String {
        loggedInUserDetails?.staffName ?? ""
    }
    
    var staffNumber: String {
        loggedInUserDetails?.staffNumber ?? ""
    }
    
    /// "title" claim of the token
    var designation: String {
        value(loggedInUserDetails?.title) ?? "-"
    }
    
    /// "mobile" claim of the token
    var contactNumber: String {
        value(loggedInUserDetails?.mobile) ?? "-"
    }
    
    private func value(_ raw: String?) -> String? {
        guard let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty,
              trimmed != "N/A" else { return nil }
        return trimmed
    }
}
