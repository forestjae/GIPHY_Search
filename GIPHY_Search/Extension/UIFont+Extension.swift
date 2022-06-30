//
//  UIFont+Extension.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/30.
//

import UIKit

extension UIFont {
    func metrics(for textStyle: UIFont.TextStyle) -> UIFont {
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: self)
    }
}
