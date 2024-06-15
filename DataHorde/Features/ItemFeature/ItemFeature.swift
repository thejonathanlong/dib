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
        var counterWidgetSate: CounterFeature.State
        var textWidgetState: TextWidgetFeature.State
        var bookCounterWidgetState: BookCounterWidgetFeature.State

        init(item: TrackedItemModel) {
            self.item = item

            switch item.widget.type {
            case .counter(let counterWidgetModel):
                counterWidgetSate = CounterFeature.State(incrementValue: counterWidgetModel.incrementAmount,
                                                         decrementValue: counterWidgetModel.decrementAmount,
                                                         currentValue: item.currentNumberValue ?? 0.0,
                                                         name: item.name,
                                                         color: Color(uiColor: item.color),
                                                         notes: nil,
                                                         date: Date(),
                                                         lastValue: item.values.last?.value,
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
                                        lastValue: item.currentValue,
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
                                               lastValue: item.currentValue,
                                               lastDate: item.lastValueDateString,
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
            lhs.item == rhs.item
        }
    }

    enum Action {
        case counterWidgetAction(CounterFeature.Action)
        case textWidgetAction(TextWidgetFeature.Action)
        case bookCounterWidgetAction(BookCounterWidgetFeature.Action)
        case selectedItem(TrackedItemModel)
        case addValue(item: TrackedItemModel)
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
            case let .addValue(item: item):
                let newValue: TrackedValueModel
                switch item.widget.type {
                case .bookCounter:
                    newValue = state.bookCounterWidgetState.valueModel
                case .counter:
                    newValue = state.counterWidgetSate.valueModel
                case .textOnly:
                    newValue = state.textWidgetState.valueModel
                }

                return .run { send in
                    do {
                        try await itemCreationService.add(value: newValue, to: item)
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