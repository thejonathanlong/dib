//
//  BookCounterWidgetFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

@Reducer
struct MediaCounterWidgetFeature {

    @ObservableState
    struct State {
        var creator = ""
        var title = ""
        var startDate = Date()
        var endDate: Date
        let lastValue: String?
        let lastDate: String?
        var color: Color
        let uuid = UUID()

        var uniqueId: String {
            uuid.uuidString + "." + DateUtilities.defaultDateFormatter.string(from: startDate) + "." + "\(book.description)"
        }

        var book: Media {
            Media(title: title, creator: creator)
        }

        var valueModel: TrackedValueModel {
            return TrackedValueModel(type: .book, value: book, uniqueId: uniqueId, date: startDate)
        }
    }

    enum Action {
        case creatorChanged(creator: String)
        case titleChanged(title: String)
        case startDateChanged(date: Date)
        case endDateChanged(date: Date)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .creatorChanged(let creator):
                state.creator = creator
                return .none
            case .titleChanged(let title):
                state.title = title
                return .none
            case let .startDateChanged(date: date):
                state.startDate = date
                return .none
            case let .endDateChanged(date: date):
                state.endDate = date
                return .none
            }
        }
    }
}

