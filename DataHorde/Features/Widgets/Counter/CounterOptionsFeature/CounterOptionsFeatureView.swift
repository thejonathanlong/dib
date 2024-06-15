//
//  CounterOptionsFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterOptionsFeatureView: View {
    @Bindable var store: StoreOf<CounterOptionsFeature>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            OptionSelectionView(store: store.scope(state: \.incrementValueSelectionState, action: \.incrementOptionSelectionAction))
//                .padding(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
            Divider()
            OptionSelectionView(store: store.scope(state: \.itemMeasurementSelectionState, action: \.itemMeasurementSelectionAction))
//                .padding(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
            Divider()
        }
    }
}
