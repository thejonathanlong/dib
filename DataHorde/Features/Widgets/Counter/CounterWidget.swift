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
    var onInfo: () -> Void

    var body: some View {
        CounterGuts(name: store.state.name,
                    currentValueString: store.currentValue.description,
                    color: store.state.color,
                    date: $store.date.sending(\.dateChanged),
                    dailyValue: store.state.dailyValue,
                    lastDate: store.state.lastDate) {
            store.send(.decrement)
        } onIncrement: {
            store.send(.increment)
        } onInfo: {
            onInfo()
        }
    }
}

//#Preview {
//    CounterFeatureView()
//}
