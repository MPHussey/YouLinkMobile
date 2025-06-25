//
//  CurrencyRate.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-25.
//

import Foundation

struct CurrencyRate:Identifiable{
    let id = UUID()
    let currencyCode: String
    let conversionRate: String
}
