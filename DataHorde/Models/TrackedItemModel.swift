//
//  TrackedItemModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo

struct TrackedItemModel: AsyncDataStorableModel {
    
    typealias ManagedObject = TrackedItem

    var uniqueId: String

    let name: String

    let values: [TrackedValueModel]

    static var entityName: String {
        "TrackedItem"
    }

    init(object: TrackedItem) {
        self.uniqueId = object.id ?? "NoId"
        self.name = object.name ?? "NoName"
        self.values = (object.values ?? [])
            .compactMap {
                guard let item = $0 as? TrackedValue else { return nil }
                return TrackedValueModel(object: item)
            }
    }

    static func update(managedObject: TrackedItem, with model: TrackedItemModel) {
        managedObject.id = model.uniqueId
        managedObject.name = model.name
        if let context = managedObject.managedObjectContext {
            managedObject.values = NSSet(array: model.values.compactMap { $0.managedObject(context: context) })
        }
    }
}
