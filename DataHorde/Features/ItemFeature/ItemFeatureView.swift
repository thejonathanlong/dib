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
        VStack {
            widget
            Button(action: {
                store.send(.addValue(item: item))
            }, label: {
                Text("Add Value")
            })
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .overlay (RoundedRectangle(cornerRadius: 12.0)
            .stroke(Color(uiColor: item.color), lineWidth: 4.0)
        )
    }

    var widget: some View {
        Group {
            switch item.widget.type {
            case .counter:
                CounterWidget(store: store.scope(state: \.counterWidgetSate, action: \.counterWidgetAction))
            case .textOnly:
                TextWidget(store: store.scope(state: \.textWidgetState, action: \.textWidgetAction))
            case .bookCounter:
                BookCounterWidget(store: store.scope(state: \.bookCounterWidgetState, action: \.bookCounterWidgetAction))
            }
        }
    }
}

//#Preview {
//    ItemFeatureView()
//}
