//
//  ItemCreationService.swift
//  DataHorde
//
//  Created by Jonathan Long on 4/3/24.
//

import Dependencies
import Foundation
import PoCampo
import OSLog

protocol ItemCreatable {
    func createItem(name: String, color: WidgetColors, widgetModel: WidgetModel, valueType: TrackedValueType) async throws -> TrackedItemModel
    func add(value: TrackedValueModel, to item: TrackedItemModel) async throws
}

struct ItemCreationService: ItemCreatable {
    @Dependency(\.dataStore) var dataStore

    let logger = Logger(subsystem: "com.jlo.ItemCreationService", category: "ItemCreation")
    func createItem(name: String,
                    color: WidgetColors,
                    widgetModel: WidgetModel,
                    valueType: TrackedValueType) async throws -> TrackedItemModel {
        logger.log("ItemCreationService: Adding item named \(name)")
        let uniqueId = UUID().uuidString
        let trackedItem = TrackedItemModel(uniqueId: uniqueId,
                                           name: name,
                                           widget: widgetModel,
                                           color: color.color, valueType: valueType)
        return try! await dataStore.add(model: trackedItem)
    }

    func add(value: TrackedValueModel, to item: TrackedItemModel) async throws {
        logger.log("ItemCreationService: Adding value \(value.description) to item named \(item.name)")
        var newValues = item.values
        newValues.append(value)
        let newItem = TrackedItemModel(uniqueId: item.uniqueId,
                                       name: item.name,
                                       widget: item.widget,
                                       color: item.color,
                                       valueType: item.valueType,
                                       values: newValues)
        try! await dataStore.update(newModel: newItem)
    }
}
