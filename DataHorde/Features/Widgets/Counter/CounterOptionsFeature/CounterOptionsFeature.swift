//
//  CounterOptionsFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import ComposableArchitecture
import Foundation
import SwiftUI

enum CounterIncrementOptions: Double, OptionSelection, CaseIterable {
    case oneTenth = 0.1
    case oneHalf = 0.5
    case one = 1.0
    case two = 2.0
    case five = 5.0
    case ten = 10.0
    case oneHundred = 100.0

    var backgroundColor: Color {
        Color(uiColor: WidgetColors.lightPink.color)
    }

    var id: Double {
        rawValue
    }

    var description: String {
        "\(rawValue)"
    }
}

@Reducer
struct CounterOptionsFeature {
    @ObservableState
    struct State: Equatable {
        var incrementValueSelectionState = OptionSelectionFeature<CounterIncrementOptions>.State(options: CounterIncrementOptions.allCases, selectedOption: .one)
        var itemMeasurementSelectionState = OptionSelectionFeature<ItemMeasurements>.State(options: ItemMeasurements.allCases, selectedOption: .noMeasurement)
    }

    enum Action {
        case itemMeasurementSelectionAction(action: OptionSelectionFeature<ItemMeasurements>.Action)
        case incrementOptionSelectionAction(action: OptionSelectionFeature<CounterIncrementOptions>.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.itemMeasurementSelectionState, action: \.itemMeasurementSelectionAction) {
            OptionSelectionFeature<ItemMeasurements>()
        }
        Scope(state: \.incrementValueSelectionState, action: \.incrementOptionSelectionAction) {
            OptionSelectionFeature<CounterIncrementOptions>()
        }
        Reduce { state, action in
            return .none
        }
    }
}
