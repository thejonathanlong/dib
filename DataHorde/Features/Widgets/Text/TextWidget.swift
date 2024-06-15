//
//  TextWidget.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/13/24.
//

import ComposableArchitecture
import SwiftUI

struct TextWidget: View {
    @Bindable var store: StoreOf<TextWidgetFeature>

    var body: some View {
        TextWidgetGuts(text: $store.text.sending(\.textChanged),
                       date: $store.date.sending(\.dateChanged),
                       lastValue: store.state.lastValue,
                       lastDate: store.state.lastValueDate)
    }
}
