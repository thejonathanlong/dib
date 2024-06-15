//
//  NameSelectionFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/16/24.
//

import ComposableArchitecture
import Foundation
import PoCampo

@Reducer
struct NameSelectionFeature {
    @ObservableState
    struct State: Equatable {
        var name: String
    }

    enum Action {
        case nameChanged(name: String)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case let .nameChanged(name: name):
                    state.name = name
                    return .none
            }
        }
    }
}
