//
//  FeaturedLink.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import Foundation

//one quick link returned by the quick-links endpoint
struct FeaturedLink:Identifiable, Decodable{
    let id:String
    let shortcutName:String?
    let shortcutDesc:String?
    let shortcutImgUrl:String?
    let shortcutUrl:String?

    //the description is what the app shows as the link title
    var title:String{
        shortcutDesc ?? shortcutName ?? ""
    }

    var imageURL:URL?{
        URL(apiString: shortcutImgUrl)
    }

    var redirectURL:URL?{
        URL(apiString: shortcutUrl)
    }
}
