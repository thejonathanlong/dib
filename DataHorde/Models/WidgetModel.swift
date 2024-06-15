//
//  WidgetModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import PoCampo
import SwiftUI

extension DBWidget: UniqueManagedObject { }

struct WidgetModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBWidget

    enum WidgetType: Identifiable, BackgroundProvider, CustomStringConvertible, CaseIterable {
        static var allCases: [WidgetModel.WidgetType] = [.counter(.init(uniqueId: "")),
                                                         .textOnly(.init()),
                                                         .bookCounter(.init(uniqueId: "",
                                                                            title: "",
                                                                            author: "",
                                                                            endDate: nil))]

        var backgroundColor: Color {
            return Color(uiColor: WidgetColors.seafoam.color)
        }

        var id: String {
            description
        }

        var description: String {
            switch self {
            case .counter:
                return "Counter"
            case .textOnly:
                return "Text Only"
            case .bookCounter:
                return "Books"
            }
        }

        case counter(CounterWidgetModel)
        case textOnly(TextOnlyWidgetModel)
        case bookCounter(BookCounterWidgetModel)
    }

    var uniqueId: String

    static var entityName: String {
        "DBWidget"
    }

    let type: WidgetType

    init(object: ManagedObject) {
        let widgetType: WidgetType?
        if let counterWidget = object.counterWidget {
            widgetType = .counter(CounterWidgetModel(object: counterWidget))
        } else if let textOnlyWidget = object.textOnlyWidget {
            widgetType = .textOnly(TextOnlyWidgetModel(object: textOnlyWidget))
        } else {
            widgetType = nil
        }
        assert(widgetType != nil, "There is no associated value for the WidgetModel, which is invalid.")
        self.init(uniqueId: object.uniqueId!, type: widgetType!)
    }

    init(uniqueId: String, type: WidgetType) {
        self.uniqueId = uniqueId
        self.type = type
    }

    static func update(managedObject: ManagedObject, with model: WidgetModel) {
        guard let context = managedObject.managedObjectContext else {
            print("No managed object context. Failed to update WidgetModel.")
            return
        }
        managedObject.type = model.type.description
        managedObject.uniqueId = model.uniqueId
        switch model.type {
        case .counter(let counterWidgetModel):
            managedObject.counterWidget = counterWidgetModel.managedObject(context: context)
        case .textOnly(let textOnlyWidgetModel):
            managedObject.textOnlyWidget = textOnlyWidgetModel.managedObject(context: context)
        case .bookCounter(let bookCounterWidgetModel):
            managedObject.bookCounterWidget = bookCounterWidgetModel.managedObject(context: context)
        }
    }

}

