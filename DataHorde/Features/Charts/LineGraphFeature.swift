//
//  LineGraphFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/10/24.
//

import Charts
import ComposableArchitecture
import Foundation

@Reducer 
struct LineGraphFeature {

    struct Point: Identifiable, Equatable {
        let x: (valueDescription: String, value: Date)
        let y: (valueDescription: String, value: Double)
        let uniqueId: String

        var id: String {
            return uniqueId
        }

        static func == (lhs: LineGraphFeature.Point, rhs: LineGraphFeature.Point) -> Bool {
            lhs.x == rhs.x && lhs.y == rhs.y && lhs.uniqueId == rhs.uniqueId
        }
    }

    struct Line: Identifiable, Equatable {
        let points: [Point]
        let uniqueId: String

        var id: String {
            return uniqueId
        }
    }

    @ObservableState
    struct State {
        let lines: [Line]
    }

    enum Action {
        
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
