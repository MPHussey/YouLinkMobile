//
//  HomeViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

class HomeViewModel:ObservableObject{
    @Published var featuredLinks:[FeaturedLink]=[
        .init(image: "bia-flight-icon", title:"BIA Flights"),
        .init(image: "safty-icon", title: "Safty"),
        .init(image: "crisis-management-icon", title: "Crisis Management")
    ]
    
    @Published var highlights:[HighLight] = [
        HighLight(title: "Company Holidays"),
        HighLight(title: "SVN"),
        HighLight(title: "Employee Manuals"),
        HighLight(title: "Travel Policy"),
        HighLight(title: "IT Support")
    ]
}
