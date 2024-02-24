//
//  ItemFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import Foundation
import PoCampo

@Reducer
struct ItemFeature {
    @ObservableState
    struct State: Equatable {
        var item: TrackedItemModel
    }

    enum Action {
        case modifyValue(a)
    }

//    @Reducer
//    enum Destination {
//      case addItem(ItemFeature)
//    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }

//    @Dependency(\.questCreationService) var questCreationService
}
