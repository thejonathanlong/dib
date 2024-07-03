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
//        let item: TrackedItemModel

        let canShowLineGraph: Bool

        let canShowBarGraph: Bool

        let canShowHeatMap: Bool

//        let line: LineGraphFeature.Line

        init(item: TrackedItemModel) {
//            self.item = item
            canShowLineGraph = true//item.values.allSatisfy({ $0.isNumber })
            canShowBarGraph = false// canShowLineGraph
            canShowHeatMap = false// item.values.count > 0
//            line = LineGraphFeature.Line(points: item
//                .values
//                .compactMap({
//                    guard let number = $0.numberValue else { return nil }
//                    return .init(x: (valueDescription: "Date", value: $0.date),
//                                 y: (valueDescription: "value", value: number),
//                                 uniqueId: $0.uniqueId) }),
//                                         uniqueId: item.uniqueId)
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
