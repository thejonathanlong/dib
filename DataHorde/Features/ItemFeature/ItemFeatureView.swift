//
//  ItemFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import Charts
import ComposableArchitecture
import SwiftUI

protocol ItemPlottable: Equatable {
    associatedtype Value: Plottable & Equatable

    var graphValue: Value { get }
}

struct ItemFeatureView<V: ItemPlottable>: View {
    @Bindable var store: StoreOf<ItemFeature<V>>
    var onTap: () -> Void
    var onInfo: () -> Void

    var body: some View {

        VStack(spacing: 16) {
            HStack {
                Spacer()
                Text(store.state.item.name)
                    .font(.title2)
                    .fontWeight(.medium)
                Spacer()
                if !store.state.item.values.isEmpty {
                    Button {
                        store.send(.showInfo, animation: .smooth)
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .padding(16.0)
            if store.state.showInfo {
                infoView
                    .padding(16.0)
                lastValue
                Button(action: onTap) {
                    Text("All Values")
                        .foregroundColor(.blue)
                }
            } else {
                widget
//                lastValue
                HStack{
                    Button(action: {
                        store.send(.addValue)
                    }, label: {
                        Text("Add Value")
                            .foregroundColor(.blue)
                    })
                }
                .padding([.leading, .trailing], 16.0)
                .foregroundColor(Color.black)
                .fontWeight(.semibold)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .overlay (RoundedRectangle(cornerRadius: 12.0)
            .stroke(Color(uiColor: store.state.itemColor), lineWidth: 4.0)
        )
    }

    var lastValue: some View {
        if let lastValue = store.state.item.values.last {
            Text("**\(lastValue.description)** at **\(DateUtilities.defaultDateFormatter.string(from: lastValue.date))**")
                .font(.subheadline)
        } else {
            Text("No values recorded yet.")
                .font(.subheadline)
        }
    }

    var infoView: some View {
        VStack {
            chart
        }
    }

    var widgetView: some View {
        VStack {
            widget
            HStack{
                Button(action: {
                    store.send(.addValue)
                }, label: {
                    Text("Add Value")
                })
                Spacer()
                Button(action: onTap) {
                    Text("All Values")
                }
            }
            .padding([.leading, .trailing], 16.0)
            .foregroundColor(Color.black)
            .fontWeight(.semibold)
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .overlay (RoundedRectangle(cornerRadius: 12.0)
            .stroke(Color(uiColor: store.state.itemColor), lineWidth: 4.0)
        )
    }

    var widget: some View {
        Group {
            switch store.state.widgetType {
            case .counter:
                CounterWidget(store: store.scope(state: \.counterWidgetSate, action: \.counterWidgetAction), onInfo: {
                    store.send(.showInfo)
                })
            case .textOnly:
                TextWidget(store: store.scope(state: \.textWidgetState, action: \.textWidgetAction))
            case .bookCounter:
                MediaCounterWidget(store: store.scope(state: \.bookCounterWidgetState, action: \.bookCounterWidgetAction))
            }
        }
    }

    var chart: some View {
        Group {
            switch store.state.widgetType {
            default:
                LineGraph<V.Value>(store: store.scope(state: \.lineGraphState, action: \.lineGraphAction))
            }
        }
    }
}

//#Preview {
//    ItemFeatureView()
//}
