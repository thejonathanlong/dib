//
//  CounterWidgetModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import PoCampo

extension DBCounterWidget: UniqueManagedObject {
}

struct CounterWidgetModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBCounterWidget

    var uniqueId: String
    var decrementAmount: Double
    var incrementAmount: Double
    var measurement: ItemMeasurements
    var currentValue: Double

    static var entityName: String {
        "DBCounterWidget"
    }

    init(object: ManagedObject) {
        self.uniqueId = object.uniqueId!
        self.decrementAmount = object.decrementAmount
        self.incrementAmount = object.incrementAmount
        self.measurement = ItemMeasurements(rawValue: object.measurement ?? "none") ?? .noMeasurement
        self.currentValue = object.value
    }

    init(uniqueId: String, incrementValue: Double = 0, measurement: ItemMeasurements = .noMeasurement) {
        self.uniqueId = uniqueId
        self.decrementAmount = incrementValue
        self.incrementAmount = incrementValue
        self.measurement = measurement
        self.currentValue = 0
    }

    static func update(managedObject: ManagedObject, with model: Self) {
        managedObject.uniqueId = model.uniqueId
        managedObject.decrementAmount = model.decrementAmount == 0.0 ? 1.0 : model.decrementAmount
        managedObject.incrementAmount = model.incrementAmount == 0.0 ? 1.0 : model.incrementAmount
        managedObject.measurement = model.measurement.rawValue
        managedObject.value = model.currentValue
    }
}
