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

protocol TrackedItemModelInterface {
    var widgetType: WidgetModel.WidgetType { get }
}

struct TrackedItemModel: AsyncDataStorableModel, Equatable, TrackedItemModelInterface {
    typealias ManagedObject = DBTrackedItem

    var uniqueId: String

    let name: String

    let values: [TrackedValueModel]

    let valueType: TrackedValueType

    let widget: WidgetModel

    var widgetType: WidgetModel.WidgetType {
        widget.type
    }

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

        let values = (object.values ?? [])
            .compactMap { TrackedValueModel(object: $0 as! DBValue) }

        self.init(uniqueId: object.uniqueId!,
                  name: object.name!,
                  widget: WidgetModel(object: object.widget!),
                  color: color,
                  valueType: type ?? .number,
                  values: values)
    }

    init(uniqueId: String,
         name: String,
         widget: WidgetModel,
         color: UIColor,
         valueType: TrackedValueType,
         values: [TrackedValueModel] = []) {
        self.uniqueId = uniqueId
        self.name = name
        self.widget = widget
        self.color = color
        self.valueType = valueType
        self.values = values.sorted(by: { $0.date.timeIntervalSince1970 > $1.date.timeIntervalSince1970 })
    }

    static func update(managedObject: DBTrackedItem, with model: TrackedItemModel) {
        managedObject.uniqueId = model.uniqueId
        managedObject.name = model.name
        managedObject.hexColor = model.color.hex
        if let context = managedObject.managedObjectContext {
            managedObject.values = Set(model.values.compactMap { $0.managedObject(context: context) }) as NSSet
            managedObject.widget = model.widget.managedObject(context: context)
        }
    }
}
