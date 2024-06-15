//
//  AddItemView.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

import ComposableArchitecture
import SwiftUI

struct AddItemView: View {
    @Bindable var store: StoreOf<AddItemFeature>
    @Environment(\.dismiss) var dismiss

    @State var currentValue = Int.random(in: 0...100)
    @State var lastValue = Int.random(in: 0...100)

    let lastDate = Date().addingTimeInterval(TimeInterval(60 * 30 * -1))

    var body: some View {
        Form {
            Section {
                HStack {
                    Button(role: .cancel) {
//                        self.dismiss()
                        store.send(.cancel)
                    } label: {
                        Image(systemName: "xmark")
                    }
                    // Without buttons tyle all button colsures in this section will be called when interacting with a button...
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                    Button("Done", role: .none) {
                        // Send a save, but also dismiss
                        store.send(.createItem)
//                        self.dismiss()
                    }
                    // Without buttons tyle all button colsures in this section will be called when interacting with a button...
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .listRowBackground(Color.clear)
            Section("Title") {
                NameSelectionView(store: store.scope(state: \.nameSelectionState, action: \.nameAction))
            }
            Section("Tracker Type") {
                OptionSelectionView(store: store.scope(state: \.widgetTypeSelectionState, action: \.widgetTypeSelectionAction))
            }
            Section("Preview") {
                VStack {
                    switch store.state.widgetTypeSelectionState.selectedOption {
                    case .counter:
                        Spacer()
                            .frame(height: 10)
                        CounterGuts(name: nil,
                                    currentValueString: "\(currentValue) \(store.counterOptionsState.itemMeasurementSelectionState.selectedOption.abbreviation(count: currentValue))",
                                    color: Color(uiColor: store.state.colorSelectionState.selectedOption.color),
                                    date: .constant(Date()),
                                    lastValue: "\(lastValue) \(store.counterOptionsState.itemMeasurementSelectionState.selectedOption.abbreviation(count: currentValue))",
                                    lastDate: Date().addingTimeInterval(TimeInterval(60 * 30 * -1)),
                                    onDecrement: { currentValue -= 1 },
                                    onIncrement: { currentValue += 1 })
                    case .textOnly:
                        TextWidgetGuts(text: .constant(""),
                                       date: .constant(Date()),
                                       lastValue: "Lonesome Dove",
                                       lastDate: "\(lastDate)")
                    case .bookCounter:
                        BookCounterGuts(title: .constant(""),
                                        author: .constant(""),
                                        startDate: .constant(Date()),
                                        endDate: .constant(Date()),
                                        lastValue: "",
                                        lastDate: "\(lastDate)")
                    }
                }
                .background(RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(uiColor: store.state.colorSelectionState.selectedOption.color), lineWidth: 3.0))
                .transition(.move(edge: .top))

            }
            Section("Options") {
                VStack(spacing: 12) {
                    switch store.state.widgetTypeSelectionState.selectedOption {
                    case .counter:
                        CounterOptionsFeatureView(store: store.scope(state: \.counterOptionsState, action: \.counterOptionsStateAction))
                    case .textOnly:
                        EmptyView()
                    case .bookCounter:
                        EmptyView()
                    }
                    OptionSelectionView(store: store.scope(state: \.colorSelectionState, action: \.colorAction))
                }
            }
        }
        .navigationTitle("New Tracker")
    }
}
