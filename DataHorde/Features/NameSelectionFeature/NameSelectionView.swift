//
//  NameSelectionView.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/16/24.
//

import ComposableArchitecture
import SwiftUI

struct NameSelectionView: View {
    @Bindable var store: StoreOf<NameSelectionFeature>

    var body: some View {
        TextField("Name", text: $store.name.sending(\.nameChanged), axis: .vertical)
    }
}
