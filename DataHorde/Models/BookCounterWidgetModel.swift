//
//  BookCounterWidgetModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import Foundation
import PoCampo

extension DBBookCounterWidget: UniqueManagedObject { }

struct BookCounterWidgetModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBBookCounterWidget

    var uniqueId: String
    var creator: String
    var title: String
    var startDate: Date
    var endDate: Date?
    var hasMarkedAsFinished: Bool

    static var entityName: String {
        "DBBookCounterWidget"
    }

    init(object: DBBookCounterWidget) {
        self.init(uniqueId: object.uniqueId!,
                  title: object.title!,
                  creator: object.author!,
                  startDate: object.startDate ?? Date(),
                  endDate: object.endDate,
                  hasMarkedAsFinished: object.hasMarkedAsFinished)
    }

    init(uniqueId: String, title: String, creator: String, startDate: Date = Date(), endDate: Date? = nil, hasMarkedAsFinished: Bool = false) {
        self.uniqueId = uniqueId
        self.title = title
        self.creator = creator
        self.startDate = startDate
        self.endDate = endDate
        self.hasMarkedAsFinished = hasMarkedAsFinished
    }

    static func update(managedObject: DBBookCounterWidget, with model: BookCounterWidgetModel) {
        managedObject.uniqueId = model.uniqueId
        managedObject.author = model.creator
        managedObject.startDate = model.startDate
        managedObject.endDate = model.endDate
        managedObject.title = model.title
        managedObject.hasMarkedAsFinished = model.hasMarkedAsFinished
    }


}
