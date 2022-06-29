//
//  Color.swift
//  GIPHY_Search
//
//  Created by Lee Seung-Jae on 2022/06/29.
//

import UIKit

private enum Color {
    case mainBackground

    var color: UIColor {
        guard let color = UIColor(named: String(describing: self)) else {
            return .white
        }

        return color
    }
}

extension UIColor {
    static let mainBackground = Color.mainBackground.color
}
