//
//  FrequentButtons.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation
import SwiftUI

struct FrequentButtons:Identifiable {
    let id=UUID()
    let title:String
    let hex:String
    let image:String
    //label of the matching item under "applications" in the menu service
    let menuLabel:String
    //filled from the menu service, nil until it loads
    var redirectUrl:String? = nil
    
    var borderColor:Color{Color(hex: hex)}
}
