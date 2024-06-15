//
//  AddItemFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/24/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct AddItemFeature {

    @Dependency(\.itemCreationService) var itemCreationService
    @Dependency(\.widgetCreationService) var widgetCreationService

    @ObservableState
    struct State: Equatable {
        var nameSelectionState = NameSelectionFeature.State(name: "")
        var colorSelectionState = OptionSelectionFeature<WidgetColors>.State(options: WidgetColors.allCases, selectedOption: .blueGreen, isRounded: true)
        var widgetTypeSelectionState = OptionSelectionFeature<WidgetModel.WidgetType>.State(options: WidgetModel.WidgetType.allCases, selectedOption: WidgetModel.WidgetType.allCases[0])
        var counterOptionsState = CounterOptionsFeature.State()
    }

    enum Action {
        case nameAction(action: NameSelectionFeature.Action)
        case widgetAction(action: WidgetSelectorFeature.Action)
        case colorAction(action: OptionSelectionFeature<WidgetColors>.Action)
        case widgetTypeSelectionAction(action: OptionSelectionFeature<WidgetModel.WidgetType>.Action)
        case counterOptionsStateAction(action: CounterOptionsFeature.Action)
        case createItem
        case cancel
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.nameSelectionState, action: \.nameAction) {
            NameSelectionFeature()
        }
        Scope(state: \.colorSelectionState, action: \.colorAction) {
            OptionSelectionFeature<WidgetColors>()
        }
        Scope(state: \.widgetTypeSelectionState, action: \.widgetTypeSelectionAction) {
            OptionSelectionFeature<WidgetModel.WidgetType>()
        }
        Scope(state: \.counterOptionsState, action: \.counterOptionsStateAction) {
            CounterOptionsFeature()
        }

        Reduce { state, action in
            switch action {
            case .createItem:
//                let uniqueId = UUID().uuidString
//                let selectedWidgetType = state.widgetTypeSelectionState.selectedOption
//                let widgetType: WidgetModel.WidgetType
//
//                switch selectedWidgetType {
//                case .textOnly:
//                    widgetType = .textOnly(TextOnlyWidgetModel(uniqueId: uniqueId))
//                case .counter:
//                    widgetType = .counter(CounterWidgetModel(uniqueId: uniqueId,
//                                                             incrementValue: state.counterOptionsState.incrementValueSelectionState.selectedOption.rawValue,
//                                                             measurement: state.counterOptionsState.itemMeasurementSelectionState.selectedOption))
//                case .bookCounter:
//                    widgetType = .bookCounter(.init(uniqueId: uniqueId, title: "", author: ""))
//                }
//
//                let widget = WidgetModel(uniqueId: uniqueId, type: widgetType)
//                let name = state.nameSelectionState.name
//                let color = state.colorSelectionState.selectedOption
//                return .run { _ in
//                    let widgetModel = try await self.widgetCreationService.createWidget(widgetModel: widget)
//                    let _ = try await self.itemCreationService.createItem(name: name,
//                                                                          color: color,
//                                                                          widgetModel: widgetModel)
//                }
                return .none
            case .nameAction,
                    .widgetAction,
                    .widgetTypeSelectionAction,
                    .counterOptionsStateAction,
                    .colorAction,
                    .cancel:
                return .none
            }
        }
    }
}
