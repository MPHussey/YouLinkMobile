//
//  MainCarousel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-27.
//

import Foundation

struct MainCarousel:Identifiable, Hashable, Equatable, Decodable{
    let id=UUID()
    //remote image of the slide
    let src:String
    //optional link to open when the slide is tapped
    let url:String?

    //id is generated locally, so only the api fields are decoded
    enum CodingKeys:String, CodingKey{
        case src
        case url
    }

    var imageURL:URL?{
        URL(apiString: src)
    }

    var linkURL:URL?{
        URL(apiString: url)
    }
}

extension URL{
    //build a url and percent-encode it when the api sends unescaped characters
    init?(apiString raw:String?){
        guard
            let trimmed = raw?.trimmingCharacters(in: .whitespacesAndNewlines),
            !trimmed.isEmpty
        else { return nil }

        if let url = URL(string: trimmed){
            self = url
            return
        }

        guard
            let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: encoded)
        else { return nil }
        self = url
    }
}
