//
//  TrackedItemModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import CoreData
import Foundation
import PoCampo
import SwiftUI
import UIKit

extension DBTrackedItem: UniqueManagedObject { }

protocol ItemValueProvider: Equatable {
    associatedtype ManagedObject: NSManagedObject
    
    var uniqueId: String { get }
    var date: Date { get }

    func managedObject(context: NSManagedObjectContext) -> ManagedObject?
}

struct TrackedItemModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBTrackedItem

    var uniqueId: String

    let name: String

    let values: [any ItemValueProvider]

    let valueType: TrackedValueType

    let widget: WidgetModel

    static var entityName: String {
        "DBTrackedItem"
    }

    let color: UIColor

    init(object: ManagedObject) {
        let color: UIColor
        if let hex = object.hexColor, let uiColor = UIColor(hex: hex) {
            color = uiColor
        } else {
            color = WidgetColors.darkGreen.color
        }

        let type = TrackedValueType(rawValue: object.valueType ?? TrackedValueModelConstants.double)

        let values: [any ItemValueProvider]
        switch type {
        case .number:
            values = (object.values ?? [])
                .compactMap {
                    let dbValue = $0 as! DBValue
                    return TrackedValueModel<Double>(object: $0 as! DBValue)
                }
        case .text:
            values = (object.values ?? [])
                .compactMap {
                    let dbValue = $0 as! DBValue
                    return TrackedValueModel<String>(object: $0 as! DBValue)
                }
        case .book:
            values = (object.values ?? [])
                .compactMap {
                    let dbValue = $0 as! DBValue
                    return TrackedValueModel<Book>(object: $0 as! DBValue)
                }
        case nil:
            values = []
        }

        self.init(uniqueId: object.uniqueId!,
                  name: object.name!,
                  widget: WidgetModel(object: object.widget!),
                  color: color,
                  valueType: type ?? .number,
                  values: values)
    }

    init(uniqueId: String, name: String, widget: WidgetModel, color: UIColor, valueType: TrackedValueType, values: [any ItemValueProvider] = []) {
        self.uniqueId = uniqueId
        self.name = name
        self.widget = widget
        self.color = color
        self.valueType = valueType
        self.values = values.sorted(by: { $0.date > $1.date })
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

    static func == (lhs: TrackedItemModel, rhs: TrackedItemModel) -> Bool {
        let defaultEquality = lhs.uniqueId == rhs.uniqueId && lhs.name == rhs.name && lhs.valueType == rhs.valueType && lhs.widget == rhs.widget
        if defaultEquality {
            switch lhs.valueType {
            case .number:
                guard let lhsValues = lhs.values as? [TrackedValueModel<Double>],
                      let rhsValues = rhs.values as? [TrackedValueModel<Double>] else { return false }
                return lhsValues == rhsValues
            case .text:
                guard let lhsValues = lhs.values as? [TrackedValueModel<String>],
                      let rhsValues = rhs.values as? [TrackedValueModel<String>] else { return false }
                return lhsValues == rhsValues
            case .book:
                guard let lhsValues = lhs.values as? [TrackedValueModel<Book>],
                      let rhsValues = rhs.values as? [TrackedValueModel<Book>] else { return false }
                return lhsValues == rhsValues
            }
        }
        return defaultEquality
    }
}


//struct TrackedItemCountable: Countable {
//    var display: String {
//        String(currentValue)
//    }
//
//    var currentValue: Double
//    var incrementAmount: Double
//    var decrementAmount: Double
//
//    mutating func increment() -> TrackedItemCountable {
//        let newValue = currentValue + incrementAmount
//        return TrackedItemCountable(currentValue: newValue, incrementAmount: incrementAmount, decrementAmount: decrementAmount)
//    }
//    
//    mutating func decrement() -> TrackedItemCountable {
//        let newValue = currentValue - decrementAmount
//        return TrackedItemCountable(currentValue: newValue, incrementAmount: incrementAmount, decrementAmount: decrementAmount)
//    }
//    
//    func trackedValue() -> TrackedValueModel<V> {
//        return TrackedValueModel(type: .number(value: currentValue))
//    }
//}
