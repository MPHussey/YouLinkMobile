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
    
    /// Comes from the token once the claim is available, otherwise a placeholder.
    var designation: String {
        value(loggedInUserDetails?.designation) ?? "Designation"
    }
    
    /// Comes from the token once the claim is available, otherwise a placeholder.
    var contactNumber: String {
        value(loggedInUserDetails?.contactNumber) ?? "-"
    }
    
    private func value(_ raw: String?) -> String? {
        guard let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
              !trimmed.isEmpty,
              trimmed != "N/A" else { return nil }
        return trimmed
    }
}
