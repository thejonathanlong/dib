//
//  Colors.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/17/24.
//

import Foundation
import SwiftUI
import UIKit

enum WidgetColors: String, Identifiable, CaseIterable, BackgroundProvider, CustomStringConvertible, Equatable {
    case blueGreen
    case blueGreen2
    case darkerBlueGreen
    case darkerPurple
    case darkerYellow
    case darkGreen
    case greenBlue
    case lava
    case lightBlueish
    case lightGreen
    case lightOrange
    case lightPink
    case lightPurple
    case lightRed
    case orange2
    case orangish
    case peach
    case peach2
    case pinkish
    case pinkishRed
    case redish
    case seafoam
    case yellowish

    var color: UIColor {
        UIColor(Color(rawValue, bundle: .main))
    }

    var id: String {
        rawValue
    }

    var backgroundColor: Color {
        Color(uiColor: color)
    }

    var description: String {
        rawValue
    }
}

extension UIColor {

    // MARK: - Initialization
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }

    // MARK: - Convenience Methods

    var hex: String? {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        // Helpers
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        // Create Hex String
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))

        return hex
    }

}
