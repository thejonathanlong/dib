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
    func createItem(name: String, color: WidgetColors, widgetModel: WidgetModel) async throws -> TrackedItemModel
    func add(value: TrackedValueModel, to item: TrackedItemModel) async throws
}

struct ItemCreationService: ItemCreatable {
    @Dependency(\.dataStore) var dataStore

    func createItem(name: String, color: WidgetColors, widgetModel: WidgetModel) async throws -> TrackedItemModel {
        let uniqueId = UUID().uuidString
        let trackedItem = TrackedItemModel(uniqueId: uniqueId, name: name, widget: widgetModel, color: color.color)
        return try! await dataStore.add(model: trackedItem)
    }

    func add(value: TrackedValueModel, to item: TrackedItemModel) async throws {
        var newValues = item.values
        newValues.append(value)
        let newItem = TrackedItemModel(uniqueId: item.uniqueId,
                                       name: item.name,
                                       widget: item.widget,
                                       color: item.color, values: newValues)
        try! await dataStore.update(newModel: newItem)
    }
}
