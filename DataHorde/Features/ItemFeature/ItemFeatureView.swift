//
//  ItemFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import SwiftUI

struct ItemFeatureView: View {
    @Bindable var store: StoreOf<ItemFeature>

    var item: TrackedItemModel {
        store.state.item
    }

    var body: some View {
        switch item.widget.type {
            case .counter:
                CounterWidget(name: item.name,
                              currentValue: item.currentValue) {
                    // on increment what do we do...
                } onDecrement: {
                    // on decrement... what do we do...
                }

            case .nothing:
                Text("Uhoh, this doesn't seem right.")
        }
    }
}

//#Preview {
//    ItemFeatureView()
//}
