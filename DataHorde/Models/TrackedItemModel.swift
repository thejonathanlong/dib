//
//  TrackedItemModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo

struct TrackedItemModel: AsyncDataStorableModel, Equatable {
    
    typealias ManagedObject = TrackedItem

    var uniqueId: String

    let name: String

    let values: [TrackedValueModel]

    let colorName: String

    let widget: WidgetModel

    static var entityName: String {
        "TrackedItem"
    }

    let currentValue: String

    let lastValueDateString: String?

    init(object: TrackedItem) {
        self.uniqueId = object.id ?? "NoId"
        self.name = object.name ?? "NoName"
        self.values = (object.values ?? [])
            .compactMap {
                guard let item = $0 as? TrackedValue else { return nil }
                return TrackedValueModel(object: item)
            }
            .sorted(by: { $0.date > $1.date })
        self.colorName = object.colorName ?? "default"
        self.widget = WidgetModel(object: object.widget!)
        // This isn't right. We need a time range and need to use that to compute the current value.
        self.currentValue = self.values.first?.currentValue ?? "None"

        if let date = values.first?.date {
            lastValueDateString = DateUtilities.defaultDateFormatter.string(from: date)
        } else {
            lastValueDateString = nil
        }
    }

    static func update(managedObject: TrackedItem, with model: TrackedItemModel) {
        managedObject.id = model.uniqueId
        managedObject.name = model.name
        managedObject.colorName = model.colorName
        if let context = managedObject.managedObjectContext {
            managedObject.values = NSSet(array: model.values.compactMap { $0.managedObject(context: context) })
        }
    }
}
