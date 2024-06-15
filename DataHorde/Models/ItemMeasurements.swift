//
//  ItemMeasurements.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/15/24.
//

import SwiftUI

enum ItemMeasurements: String, Identifiable, CaseIterable, BackgroundProvider, CustomStringConvertible {
    case noMeasurement = "none"
    case ounces
    case mililiters
    case liters
    case grams
    case pounds
    case meters
    case feet
    case inches
    case centimeters

    func abbreviation(count: Int) -> String {
        switch self {
        case .noMeasurement:
            return ""
        case .ounces:
            return "oz"
        case .mililiters:
            return "ml"
        case .liters:
            return "l"
        case .grams:
            return "g"
        case .pounds where count <= 1:
            return "lb"
        case .pounds:
            return "lbs"
        case .meters:
            return "m"
        case .feet:
            return "ft"
        case .inches:
            return "in"
        case .centimeters:
            return "cm"
        }
    }

    var backgroundColor: Color {
        Color(uiColor: WidgetColors.peach.color)
    }

    var id: String {
        rawValue
    }

    var description: String {
        rawValue
    }
}
