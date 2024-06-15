//
//  ItemDetailsFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/10/24.
//

import Charts
import ComposableArchitecture
import SwiftUI

struct ItemDetailsFeatureView: View {

    @Bindable var store: StoreOf<ItemDetailsFeature>
    @State var showHeatMap: Bool
    @State var showLineGraph: Bool
    @State var showBarGraph: Bool

    var body: some View {
        VStack {
            HStack {
                if store.state.canShowHeatMap {
                    Toggle("Heat Map", isOn: $showHeatMap)
                        .toggleStyle(.button)
                }
                if store.state.canShowBarGraph {
                    Toggle("Bar Graph", isOn: $showBarGraph)
                        .toggleStyle(.button)
                }
                if store.state.canShowLineGraph {
                    Toggle("Line Graph", isOn: $showLineGraph)
                        .toggleStyle(.button)
                }
            }
            if showLineGraph {
                LineGraph(lines: [
                    .init(points: [
                        .init(x: (valueDescription: String, value: Date), y: <#T##(valueDescription: String, value: Double)#>, uniqueId: <#T##String#>)
                    ],
                          uniqueId: store.item.uniqueId)
                    ])
            }
        }
    }
}

//#Preview {
//    ItemDetailsFeatureView()
//}
