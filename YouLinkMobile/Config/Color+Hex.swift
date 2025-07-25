//
//  Color+Hex.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-21.
//

import SwiftUI

extension Color {
    /// Initialize with hex string, e.g. "#FF0000" or "00FF00FF" (ARGB) or "ABC"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int:  UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit): e.g. "ABC" => AA, BB, CC
            (a, r, g, b) = (255,
                            (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit): "RRGGBB"
            (a, r, g, b) = (255,
                            int >> 16,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit): "AARRGGBB"
            (a, r, g, b) = (int >> 24,
                            (int >> 16) & 0xFF,
                            (int >> 8) & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

