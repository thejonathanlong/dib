//
//  ItemsListFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import Foundation
import PoCampo

@Reducer
struct ItemsListFeature {
    @ObservableState
    struct State {
        var items: [TrackedItemModel]
        @Presents var itemDetails: ItemFeature.State?
    }

    enum Action {
        case itemDetails(PresentationAction<ItemFeature.Action>)
        case itemTapped(item: TrackedItemModel)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case let .itemTapped(item: item):
                    state.itemDetails = .init(item: item)
                    return .none
                case .itemDetails:
                    return .none
            }

        }
        .ifLet(\.$itemDetails, action: \.itemDetails) {
            ItemFeature()
        }
    }

//    @Dependency(\.questCreationService) var questCreationService
}

