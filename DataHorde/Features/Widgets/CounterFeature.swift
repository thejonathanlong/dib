//
//  CounterFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import ComposableArchitecture
import Foundation
import PoCampo

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var trackedItem: TrackedItemModel
        var currentValue: any Countable
    }

    enum Action {
        case increment
        case decrement
        case addValue
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .increment:
                    state.currentValue = state.currentValue.increment()
                    return .none
                case .decrement:
                    state.currentValue = state.currentValue.decrement()
                    return .none
                case .addValue:
                    let _ = state.currentValue.trackedValue()
                    // Store in database for the trackedItem
                    return .none

            }
        }
    }

//    @Dependency(\.questCreationService) var questCreationService
}
