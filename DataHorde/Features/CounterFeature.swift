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
    struct State: Equatable {
        var name: String
        var currentValue: any Countable

        static func == (lhs: CounterFeature.State, rhs: CounterFeature.State) -> Bool {
            lhs.name == rhs.name && lhs.currentValue.display == rhs.currentValue.display
        }
    }

    enum Action {
        case increment
        case decrement
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
            }
        }
    }

//    @Dependency(\.questCreationService) var questCreationService
}
