//
//  KeyboardUtil.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-03.
//

import Foundation
import UIKit

extension UIApplication{
    func endEditing() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
