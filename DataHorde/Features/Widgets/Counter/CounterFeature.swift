//
//  CounterFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        let incrementValue: Double
        let decrementValue: Double
        var currentValue: Double = 0.0
        var name: String
        var color: Color
        var notes: String?
        var date: Date = Date()
        var dailyValue: String? = nil
        var lastDate: Date?
        var isDatePickerEnabled: Bool = true

        let uuid = UUID()

        var uniqueId: String {
            uuid.uuidString + "." + DateUtilities.defaultDateFormatter.string(from: date) + "." + "\(currentValue)"
        }

        var valueModel: TrackedValueModel {
            .init(type: .number, value: currentValue, uniqueId: uniqueId, date: date)
        }
    }

    enum Action {
        case increment
        case decrement
        case addValue
        case notesChanged(notes: String)
        case dateChanged(date: Date)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .increment:
                state.currentValue += state.incrementValue
                    return .none
                case .decrement:
                    state.currentValue -= state.decrementValue
                    return .none
                case .addValue:
                    let _ = state.currentValue
                    // Store in database for the trackedItem
                    return .none
            case .notesChanged(let notes):
                state.notes = notes
                return .none
            case .dateChanged(let date):
                state.date = date
                return .none

            }
        }
    }

//    @Dependency(\.questCreationService) var questCreationService
}
