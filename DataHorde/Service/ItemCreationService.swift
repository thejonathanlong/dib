//
//  ItemCreationService.swift
//  DataHorde
//
//  Created by Jonathan Long on 4/3/24.
//

import Dependencies
import Foundation
import PoCampo

protocol ItemCreatable {
    func createItem(name: String, color: WidgetColors, widgetModel: WidgetModel, valueType: TrackedValueType) async throws -> TrackedItemModel
    func add<V>(value: TrackedValueModel<V>, to item: TrackedItemModel) async throws
}

struct ItemCreationService: ItemCreatable {
    @Dependency(\.dataStore) var dataStore

    func createItem(name: String, color: WidgetColors, widgetModel: WidgetModel, valueType: TrackedValueType) async throws -> TrackedItemModel {
        let uniqueId = UUID().uuidString
        let trackedItem = TrackedItemModel(uniqueId: uniqueId, name: name, widget: widgetModel, color: color.color, valueType: valueType)
        return try! await dataStore.add(model: trackedItem)
    }

    func add<V>(value: TrackedValueModel<V>, to item: TrackedItemModel) async throws {
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
