//
//  CurrencyRatesView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-25.
//

import SwiftUI
import FlagsKit

struct CurrencyRatesView: View {
    let rates:[CurrencyRate]
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        return f
    }()
    
    private var todayString: String {
        Self.dateFormatter.string(from: Date())
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("BOC Exchange Currency Rate as at \(todayString)")
                .font(.headline)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(rates) { rate in
                        currencyRateCard(for: rate)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 140)
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private func currencyRateCard(for rate: CurrencyRate) -> some View {
        let countryCode = Country
            .countryCode(fromCurrencyCode: rate.currencyCode)
        ?? rate.currencyCode  // fallback if not found
        VStack(alignment: .leading, spacing: 10) {
            // Flag + code
            HStack(spacing: 8) {
                FlagView(countryCode: countryCode)
                    .frame(width: 50, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                Text(rate.currencyCode)
                    .font(.headline)
            }
            
            Text("Conversion Rate")
                .font(.subheadline)
                .bold()
            
            Text("LKR \(rate.conversionRate)")
        .font(.body)
    }
    .padding()
    .frame(width: 160, height: 120)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.white)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    )
  }
}

//#Preview {
//    CurrencyRatesView()
//}
