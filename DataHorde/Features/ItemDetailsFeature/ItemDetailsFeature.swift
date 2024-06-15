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

        let canShowLineGraph: Bool

        let canShowBarGraph: Bool

        let canShowHeatMap: Bool

        init(item: TrackedItemModel) {
            self.item = item
            canShowLineGraph = item.values.allSatisfy({ $0.type.isNumber })
            canShowBarGraph = canShowLineGraph
            canShowHeatMap = item.values.count > 0
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
