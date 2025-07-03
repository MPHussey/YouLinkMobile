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
    let redirectUrl:String
    
    var borderColor:Color{Color(hex: hex)}
}
