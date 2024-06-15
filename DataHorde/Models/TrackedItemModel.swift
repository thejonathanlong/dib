//
//  TrackedItemModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo
import SwiftUI
import UIKit

extension DBTrackedItem: UniqueManagedObject { }

struct TrackedItemModel: AsyncDataStorableModel, Equatable {
    
    typealias ManagedObject = DBTrackedItem

    var uniqueId: String

    let name: String

    let values: [TrackedValueModel]

    let widget: WidgetModel

    static var entityName: String {
        "DBTrackedItem"
    }

    let currentValue: String?

    let currentNumberValue: Double?

    let lastValueDateString: String?

    let color: UIColor

    init(object: ManagedObject) {
        let color: UIColor
        if let hex = object.hexColor, let uiColor = UIColor(hex: hex) {
            color = uiColor
        } else {
            color = WidgetColors.darkGreen.color
        }
        let values = (object.values ?? [])
            .compactMap {
                return TrackedValueModel(object: $0 as! DBValue)
            }
            .sorted(by: { $0.date > $1.date })

        self.init(uniqueId: object.uniqueId!,
                  name: object.name!,
                  widget: WidgetModel(object: object.widget!),
                  color: color,
                  values: values)
    }

    init(uniqueId: String, name: String, widget: WidgetModel, color: UIColor, values: [TrackedValueModel] = []) {
        self.uniqueId = uniqueId
        self.name = name
        self.widget = widget
        self.color = color
        self.values = values
        let numberValues = self.values.filter { $0.type.isNumber && Calendar.current.isDateInToday($0.date) }
        let currentDoubleValue = numberValues.reduce(0.0) {
            switch $1.type {
            case .number(let value):
                return $0 + value
            case .text, .book:
                return $0
            }
        }
        self.currentNumberValue = numberValues.isEmpty ? nil : currentDoubleValue
        self.currentValue = numberValues.isEmpty ? self.values.first(where: { Calendar.current.isDateInToday($0.date) })?.value : "\(currentDoubleValue)"

        if let date = values.first?.date {
            lastValueDateString = DateUtilities.defaultDateFormatter.string(from: date)
        } else {
            lastValueDateString = nil
        }


    }

    static func update(managedObject: DBTrackedItem, with model: TrackedItemModel) {
        managedObject.uniqueId = model.uniqueId
        managedObject.name = model.name
        managedObject.hexColor = model.color.hex
        if let context = managedObject.managedObjectContext {
            managedObject.values = NSSet(array: model.values.compactMap { $0.managedObject(context: context) })
            managedObject.widget = model.widget.managedObject(context: context)
        }
    }
}

struct TrackedItemCountable: Countable {
    var display: String {
        String(currentValue)
    }

    var currentValue: Double
    var incrementAmount: Double
    var decrementAmount: Double

    mutating func increment() -> TrackedItemCountable {
        let newValue = currentValue + incrementAmount
        return TrackedItemCountable(currentValue: newValue, incrementAmount: incrementAmount, decrementAmount: decrementAmount)
    }
    
    mutating func decrement() -> TrackedItemCountable {
        let newValue = currentValue - decrementAmount
        return TrackedItemCountable(currentValue: newValue, incrementAmount: incrementAmount, decrementAmount: decrementAmount)
    }
    
    func trackedValue() -> TrackedValueModel {
        return TrackedValueModel(type: .number(value: currentValue))
    }
}
