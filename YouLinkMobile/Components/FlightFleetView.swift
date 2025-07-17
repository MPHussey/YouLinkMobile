//
//  FlightFleetView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

struct FlightFleetView: View {
    @Environment(\.openURL) private var openURL
    
    let flightFleetDataset:[FlightInfo]
    
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            HStack{
                Text("Flight Fleet")
                    .font(.headline)
                Spacer()
                Button("i-Fleet"){
                    if let url = URL(string:"http://intraneti.srilankan.com/ifv") {
                        openURL(url)
                    }
                }
                .font(.subheadline)
            }
            .padding(.horizontal,20)
            
            //horizontal card slider
            ScrollView(.horizontal,showsIndicators: false){
                LazyHStack(spacing:16){
                    ForEach(flightFleetDataset){flight in
                        flightCard(for:flight)
                    }
                }
                .padding(.horizontal,20)
                .padding(.vertical,10)
            }
        }
    }
    
    
    @ViewBuilder
    private func flightCard(for f:FlightInfo)->some  View{
        
        ZStack{
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1),
                        radius: 4, x: 0, y: 2)
            VStack(spacing: 12) {
                // Top row: logo + flight number | date/time
                HStack {
                    HStack(spacing: 8) {
                        Image("sl-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(4)  // add some breathing room
                            .background(Color.white)  // make sure the border shows against any bg
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                        Text(f.callSign)
                            .font(.subheadline)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Text(f.departureDate)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                // Bottom row: departure | connector | arrival
                HStack{
                    // Departure column
                    VStack(alignment: .leading, spacing: 4) {
                        Text(f.departureCode)
                            .font(.title3)
                            .bold()
                        Text(f.departureStatus)
                            .font(.caption)
                            .foregroundColor(f.departureColor)
                        Text("(\(f.departureStatusTime)min)")
                            .font(.caption)
                            .foregroundColor(f.departureColor)
                    }
                    Spacer()
                    // Connector with dots, lines, and airplane
                    VStack(spacing: 4) {
                        
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 6, height: 6)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width:35, height: 1)
                            Image("aircraft")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height:20)
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 35, height: 1)
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 6, height: 6)
                        }
                        // Now the flight number under the plane
                        Text(f.flightNumber)
                            .font(.subheadline)
                            .bold()
                    }
                    Spacer()
                    // Arrival column
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(f.arrivalCode)
                            .font(.title3)
                            .bold()
                        Text(f.arrivalStatus)
                            .font(.caption)
                            .foregroundColor(f.arrivalColor)
                        Text("(\(f.arrivalStatusTime)min)")
                            .font(.caption)
                            .foregroundColor(f.arrivalColor)
                    }
                }
            }
            .padding(12)

        }
        .frame(width: 330, height: 140)
    }
}



//#Preview {
//    FlightFleetView()
//}
