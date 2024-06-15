//
//  CounterFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterWidget: View {
    @Bindable var store: StoreOf<CounterFeature>

    var body: some View {
        CounterGuts(name: store.state.name,
                    currentValueString: store.currentValue.description,
                    color: store.state.color,
                    date: $store.date.sending(\.dateChanged),
                    lastValue: store.state.lastValue,
                    lastDate: store.state.lastDate) {
            store.send(.decrement)
        } onIncrement: {
            store.send(.increment)
        }
    }
}

//#Preview {
//    CounterFeatureView()
//}
