//
//  ItemFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct ItemFeature {

    @Dependency(\.itemCreationService) var itemCreationService

    @ObservableState
    struct State: Equatable {
        var item: TrackedItemModel
        var widgetType: WidgetModel.WidgetType
        var itemUniqueId: String
        var itemColor: UIColor
        var counterWidgetSate: CounterFeature.State
        var textWidgetState: TextWidgetFeature.State
        var bookCounterWidgetState: BookCounterWidgetFeature.State

        init(item: TrackedItemModel) {
            self.itemUniqueId = item.uniqueId
            self.item = item
            self.widgetType = item.widget.type
            self.itemColor = item.color

            switch item.widget.type {
            case .counter(let counterWidgetModel):
                let currentValuse = item.values.filter { Calendar.current.isDateInToday($0.date) }.reduce(into: 0) { partialResult, nextValue in
                    switch nextValue.type {
                    case .number:
                        if let value = nextValue.value as? Double? {
                            partialResult = partialResult + (value ?? 0)
                        }
                    default:
                        break
                    }

                }
                counterWidgetSate = CounterFeature.State(incrementValue: counterWidgetModel.incrementAmount,
                                                         decrementValue: counterWidgetModel.decrementAmount,
                                                         currentValue: currentValuse,
                                                         name: item.name,
                                                         color: Color(uiColor: item.color),
                                                         notes: nil,
                                                         date: Date(),
                                                         lastValue: "\(item.values.last?.value ?? 0.0)",
                                                         lastDate: Date())
                // These should not be used in this state.
                textWidgetState = .init(color: Color(uiColor: item.color))
                bookCounterWidgetState = .init(endDate: Date(),
                                               lastValue: nil,
                                               lastDate: nil,
                                               color: Color(uiColor: item.color))
            case .textOnly(let textOnlyWidgetModel):
                textWidgetState = .init(date: Date(),
                                        text: textOnlyWidgetModel.value ?? "",
                                        lastValue: item.values.last?.value as? String,
                                        lastValueDate: "Date()",
                                        color: Color(uiColor: item.color))
                // These should not be used in this state.
                counterWidgetSate = .init(incrementValue: 0,
                                          decrementValue: 0,
                                          name: item.name,
                                          color: Color(uiColor: item.color))
                bookCounterWidgetState = .init(endDate: Date(),
                                               lastValue: nil,
                                               lastDate: nil,
                                               color: Color(uiColor: item.color))
            case .bookCounter(let bookCounterWidget):
                bookCounterWidgetState = .init(author: bookCounterWidget.author,
                                               title: bookCounterWidget.title,
                                               startDate: bookCounterWidget.startDate,
                                               endDate: bookCounterWidget.endDate ?? Date(),
                                               lastValue: (item.values.last?.value as? Book)?.description,
                                               lastDate: nil,//item.values.last?.date,
                                               color: Color(uiColor: item.color))
                // These should not be used in this state.
                counterWidgetSate = .init(incrementValue: 0,
                                          decrementValue: 0,
                                          name: item.name,
                                          color: Color(uiColor: item.color))
                textWidgetState = .init(color: Color(uiColor: item.color))
            }
        }

        static func == (lhs: State, rhs: State) -> Bool {
            lhs.itemUniqueId == rhs.itemUniqueId
        }
    }

    enum Action {
        case counterWidgetAction(CounterFeature.Action)
        case textWidgetAction(TextWidgetFeature.Action)
        case bookCounterWidgetAction(BookCounterWidgetFeature.Action)
        case selectedItem
        case addValue
        case failedToAddValue(error: Error)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.counterWidgetSate, action: \.counterWidgetAction) {
            CounterFeature()
        }
        Scope(state: \.textWidgetState, action: \.textWidgetAction) {
            TextWidgetFeature()
        }
        Scope(state: \.bookCounterWidgetState, action: \.bookCounterWidgetAction) {
            BookCounterWidgetFeature()
        }
        Reduce { state, action in
            switch action {
            case .addValue:
                let bookValueModel = state.bookCounterWidgetState.valueModel
                let counterModel = state.counterWidgetSate.valueModel
                let textModel = state.textWidgetState.valueModel
//                let widgetType = state.widgetType
                let itemClosure = state.item

                return .run { send in
                    do {
                        switch itemClosure.valueType {
                        case .number:
                            try await itemCreationService.add(value: counterModel, to: itemClosure)
                        case .book:
                            try await itemCreationService.add(value: bookValueModel, to: itemClosure)
                        case .text:
                            try await itemCreationService.add(value: textModel, to: itemClosure)
                        }

                    } catch let error {
                        await send(.failedToAddValue(error: error))
                    }
                }
            case let .failedToAddValue(error: error):
                // TODO: Handle error.
                return .none
            default:
                return .none
            }
        }
    }
}
