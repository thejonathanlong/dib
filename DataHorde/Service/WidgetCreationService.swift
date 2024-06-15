//
//  WidgetCreationService.swift
//  DataHorde
//
//  Created by Jonathan Long on 4/6/24.
//

import Dependencies
import Foundation
import PoCampo

protocol WidgetCreatable {
    func createWidget(widgetModel: WidgetModel) async throws -> WidgetModel
}

struct WidgetCreationService: WidgetCreatable {
    @Dependency(\.dataStore) var dataStore

    func createWidget(widgetModel: WidgetModel) async throws -> WidgetModel {
        return try await dataStore.add(model: widgetModel)
    }
}
