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

    struct Point: Identifiable {
        let x: (valueDescription: String, value: Date)
        let y: (valueDescription: String, value: Double)
        let uniqueId: String

        var id: String {
            return uniqueId
        }
    }

    struct Line: Identifiable {
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
