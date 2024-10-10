//
//  ItemFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import Charts
import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct ItemFeature<V: ItemPlottable> {

    @Dependency(\.itemCreationService) var itemCreationService

    @ObservableState
    struct State: Equatable {
        var item: TrackedItemModel
        var widgetType: WidgetModel.WidgetType
        var itemUniqueId: String
        var itemColor: UIColor
        var counterWidgetSate: CounterFeature.State
        var textWidgetState: TextWidgetFeature.State
        var bookCounterWidgetState: MediaCounterWidgetFeature.State
        var lineGraphState: LineGraphFeature<V.Value>.State
        var showInfo: Bool

        init(item: TrackedItemModel) {
            self.itemUniqueId = item.uniqueId
            self.item = item
            self.widgetType = item.widget.type
            self.itemColor = item.color

            switch item.widget.type {
            case .counter(let counterWidgetModel):
                let currentValue = item.values
                    .filter { Calendar.current.isDateInToday($0.date) }
                    .reduce(into: 0) { partialResult, nextValue in
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
                                                         currentValue: 0,
                                                         name: item.name,
                                                         color: Color(uiColor: item.color),
                                                         notes: nil,
                                                         date: Date(),
                                                         dailyValue: "\(currentValue)",
                                                         lastDate: item.values.last?.date,
                                                         isDatePickerEnabled: false)
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
                bookCounterWidgetState = .init(creator: bookCounterWidget.creator,
                                               title: bookCounterWidget.title,
                                               startDate: bookCounterWidget.startDate,
                                               endDate: bookCounterWidget.endDate ?? Date(),
                                               lastValue: (item.values.last?.value as? Media)?.description,
                                               lastDate: nil,//item.values.last?.date,
                                               color: Color(uiColor: item.color))
                // These should not be used in this state.
                counterWidgetSate = .init(incrementValue: 0,
                                          decrementValue: 0,
                                          name: item.name,
                                          color: Color(uiColor: item.color))
                textWidgetState = .init(color: Color(uiColor: item.color))
            }

            let points: [LineGraphFeature<V.Value>.State.Point] = item.values.compactMap {
                guard let value = $0.value as? V else { return nil }
                return .init(x: ($0.description, $0.date),
                             y: ($0.description, value.graphValue),
                      uniqueId: $0.uniqueId)
            }
            lineGraphState = .init(lines: [.init(points: points, uniqueId: item.uniqueId)])
            self.showInfo = false
        }

        static func == (lhs: State, rhs: State) -> Bool {
            lhs.itemUniqueId == rhs.itemUniqueId
        }
    }

    enum Action {
        case counterWidgetAction(CounterFeature.Action)
        case textWidgetAction(TextWidgetFeature.Action)
        case bookCounterWidgetAction(MediaCounterWidgetFeature.Action)
        case lineGraphAction(LineGraphFeature<V.Value>.Action)
//        case selectedItem
        case addValue
        case failedToAddValue(error: Error)
        case showInfo
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.counterWidgetSate, action: \.counterWidgetAction) {
            CounterFeature()
        }
        Scope(state: \.textWidgetState, action: \.textWidgetAction) {
            TextWidgetFeature()
        }
        Scope(state: \.bookCounterWidgetState, action: \.bookCounterWidgetAction) {
            MediaCounterWidgetFeature()
        }
        Scope(state: \.lineGraphState, action: \.lineGraphAction) {
            LineGraphFeature()
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
            case .showInfo:
                state.showInfo.toggle()
                return .none
            default:
                return .none
            }
        }
    }
}
