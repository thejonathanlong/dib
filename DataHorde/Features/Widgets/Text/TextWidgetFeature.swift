//
//  TextWidgetFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/11/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct TextWidgetFeature {

    @ObservableState
    struct State {
        var date = Date()
        var text = ""
        var lastValue: String?
        var lastValueDate: String?
        var color: Color

        var valueModel: TrackedValueModel {
            .init(type: .text(value: text), date: date)
        }
    }

    enum Action {
        case textChanged(text: String)
        case dateChanged(date: Date)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .dateChanged(let date):
                state.date = date
                return .none
            case .textChanged(let text):
                state.text = text
                return .none
            }
        }
    }
}
