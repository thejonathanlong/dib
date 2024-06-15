//
//  TextOnlyWidgetModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import PoCampo
extension DBTextOnlyWidget: UniqueManagedObject { }

struct TextOnlyWidgetModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBTextOnlyWidget

    var uniqueId: String
    let value: String?

    static var entityName: String {
        "DBTextOnlyWidget"
    }

    init(object: DBTextOnlyWidget) {
        self.init(uniqueId: object.uniqueId!, value: object.value)
    }

    init(uniqueId: String, value: String? = nil) {
        self.uniqueId = uniqueId
        self.value = value
    }

    init() {
        uniqueId = ""
        value = nil
    }

    static func update(managedObject: DBTextOnlyWidget, with model: TextOnlyWidgetModel) {
        managedObject.uniqueId = model.uniqueId
        managedObject.value = model.value
    }
}
