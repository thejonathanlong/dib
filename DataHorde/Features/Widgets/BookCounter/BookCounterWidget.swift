//
//  BookCounterWidget.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import ComposableArchitecture
import SwiftUI

struct BookCounterWidget: View {
    @Bindable var store: StoreOf<BookCounterWidgetFeature>

    var body: some View {
        BookCounterGuts(title: $store.title.sending(\.titleChanged),
                        author: $store.author.sending(\.authorChanged),
                        startDate: $store.startDate.sending(\.startDateChanged),
                        endDate: $store.endDate.sending(\.endDateChanged),
                        lastValue: store.state.lastValue,
                        lastDate: store.state.lastDate)
    }
}
