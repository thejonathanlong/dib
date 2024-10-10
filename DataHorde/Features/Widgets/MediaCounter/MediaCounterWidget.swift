//
//  BookCounterWidget.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import ComposableArchitecture
import SwiftUI

struct MediaCounterWidget: View {
    @Bindable var store: StoreOf<MediaCounterWidgetFeature>

    var body: some View {
        MediaCounterGuts(title: $store.title.sending(\.titleChanged),
                        author: $store.creator.sending(\.creatorChanged),
                        startDate: $store.startDate.sending(\.startDateChanged),
                        endDate: $store.endDate.sending(\.endDateChanged),
                        lastValue: store.state.lastValue,
                        lastDate: store.state.lastDate)
    }
}
