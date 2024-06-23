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
                LineGraph(lines: [store.state.line])
            }
            if showBarGraph {
                BarGraph(bars: store.state.line.points)
            }
        }
    }
}

struct ChartToggle: View {
    let canShowHeatMap: Bool
    let canShowLineGraph: Bool
    let canShowBarGraph: Bool

    @Binding var showHeatMap: Bool
    @Binding var showLineGraph: Bool
    @Binding var showBarGraph: Bool

    struct Constants {
        static let selectedInsets: CGFloat = 10.0
    }

    var body: some View {
        HStack {
            if canShowHeatMap {
                Button {
                    showHeatMap = true
                    showBarGraph = false
                    showLineGraph = false
                } label: {
                    Text("Heat Map")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12.0).fill(showHeatMap ? Color.blue.opacity(0.5) : Color.clear)
                }
            }
            if canShowBarGraph {
                Button {
                    showHeatMap = false
                    showBarGraph = true
                    showLineGraph = false
                } label: {
                    Text("Bar Graph")
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12.0).fill(showBarGraph ? Color.blue.opacity(0.5) : Color.clear)
                }
            }
            if canShowLineGraph {
                Button {
                    showHeatMap = false
                    showBarGraph = false
                    showLineGraph = true
                } label: {
                    Text("Line Graph")
                }
                .padding(EdgeInsets(top: Constants.selectedInsets, leading: Constants.selectedInsets, bottom: Constants.selectedInsets, trailing: Constants.selectedInsets))
                .background {
                    RoundedRectangle(cornerRadius: 12.0).fill(showLineGraph ? Color.blue.opacity(0.15) : Color.clear)
                }
            }
        }
//        .padding()
        .background(RoundedRectangle(cornerRadius: 12.0).stroke(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, lineWidth: 2.0))
    }
}

#Preview {
    ChartToggle(canShowHeatMap: true, canShowLineGraph: true, canShowBarGraph: true, showHeatMap: .constant(false), showLineGraph: .constant(true), showBarGraph: .constant(false))
}
