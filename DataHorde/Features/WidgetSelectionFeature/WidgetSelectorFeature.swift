//
//  WidgetSelectorFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct WidgetSelectorFeature {
    @ObservableState
    struct State: Equatable {
        var color: Color
        var widget: WidgetModel?
        let widgetList: [WidgetModel.WidgetType] = WidgetModel.WidgetType.allCases
        var selectedWidget: Int
        var selectedMeasurement: ItemMeasurements = .noMeasurement

        let uniqueId = UUID().uuidString
    }

    enum Action {
        case widgetTypeChanged(index: Int)
        case didSelectedMeasurement(selectedMeasurement: ItemMeasurements)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .widgetTypeChanged(index: index):
                print("JLO: index \(index)")
                if index != state.selectedWidget {
                    state.selectedWidget = index
                    state.widget = WidgetModel(uniqueId: state.uniqueId,
                                               type: state.widgetList[index])
                }
                return .none
            case let .didSelectedMeasurement(selectedMeasurement: selectedMeasurement):
                state.selectedMeasurement = selectedMeasurement
                return .none
            }
        }
    }
}

