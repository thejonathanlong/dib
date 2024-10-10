//
//  ItemDetailsFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/10/24.
//

import ComposableArchitecture

@Reducer
struct ItemDetailsFeature {
    
    @ObservableState
    struct State: Equatable {
        let item: TrackedItemModel

        init(item: TrackedItemModel) {
            self.item = item
        }
    }

    enum Action {
        case showSomething
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showSomething:
                return .none
            }
        }
    }
}
