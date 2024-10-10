//
//  LineGraph.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/10/24.
//

import Charts
import ComposableArchitecture
import SwiftUI

struct LineGraph<V: Equatable & Plottable>: View {
    @Bindable var store: StoreOf<LineGraphFeature<V>>

    var body: some View {
        LineGraphGuts(lines: store.state.lines)
    }
}

