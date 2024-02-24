//
//  WidgetModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import PoCampo

struct WidgetModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = Widget

    var uniqueId: String
    
    static var entityName: String {
        "Widget"
    }

    let incrementValue: Double?

    let decrementValue: Double?

    let type: WidgetType

    enum WidgetType: String {
        case counter
        case nothing
    }

    init(object: Widget) {
        self.incrementValue = object.incrementValue
        self.decrementValue = object.decrementValue
        self.type =  WidgetType(rawValue: object.type ?? "nothing") ?? .nothing
        self.uniqueId = object.id ?? "NoId"
    }

    static func update(managedObject: Widget, with model: WidgetModel) {
        managedObject.id = model.uniqueId
        managedObject.type = model.type.rawValue
        managedObject.incrementValue = model.incrementValue ?? 0
        managedObject.decrementValue = model.decrementValue ?? 0
    }

}

