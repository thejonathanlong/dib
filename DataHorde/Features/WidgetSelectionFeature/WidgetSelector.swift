//
//  WidgetSelector.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

import ComposableArchitecture
import SwiftUI

struct WidgetSelector: View {
    @Bindable var store: StoreOf<WidgetSelectorFeature>

    @State var currentValue = Int.random(in: 0...100)
    @State var lastValue = Int.random(in: 0...100)

    let lastDate = Date().addingTimeInterval(TimeInterval(60 * 30 * -1))

    var body: some View {
        TabView(selection: $store.selectedWidget.sending(\.widgetTypeChanged)) {
            ForEach(0..<store.state.widgetList.count, id: \.self) { index in
                switch store.state.widgetList[index] {
                case .counter:
                    VStack {
                        CounterGuts(name: nil,
                                    currentValueString: "\(currentValue) \(store.selectedMeasurement.abbreviation(count: currentValue))",
                                    color: store.state.color,
                                    date: .constant(Date()),
                                    dailyValue: "\(lastValue) \(store.selectedMeasurement.abbreviation(count: currentValue))",
                                    lastDate: Date().addingTimeInterval(TimeInterval(60 * 30 * -1)),
                                    onDecrement: { currentValue -= 1 },
                                    onIncrement: { currentValue += 1 },
                                    onInfo: {})
                        .background(RoundedRectangle(cornerRadius: 12).stroke(store.state.color, lineWidth: 3.0))
                    }
                    .tag(index)
                case .textOnly:
                    TextWidgetGuts(text: .constant(""),
                                   date: .constant(Date()),
                                   lastValue: "Lonesome Dove",
                                   lastDate: "\(lastDate)")
                    .background(RoundedRectangle(cornerRadius: 12).stroke(store.state.color, lineWidth: 3.0))
//                    .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .tag(index)
                case .bookCounter:
                    EmptyView()
                }
            }
        }.tabViewStyle(PageTabViewStyle())
            .onAppear(perform: {
                setupAppearance()
            })
    }

    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}
