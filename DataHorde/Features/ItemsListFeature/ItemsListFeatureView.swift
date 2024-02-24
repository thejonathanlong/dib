//
//  ItemsListFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import SwiftUI

struct ItemsListFeatureView: View {
    struct Constants {
        static let itemSize = GridItem.Size.fixed(190)
        static let columnSpacing: CGFloat = 5
        static let rowSpacing: CGFloat = 5
    }

    let rows: [GridItem] = [GridItem(Constants.itemSize, spacing: Constants.columnSpacing), GridItem(Constants.itemSize, spacing: Constants.columnSpacing)]

    @Bindable var store: StoreOf<ItemsListFeature>

    var body: some View {
        ScrollView {
            LazyVGrid(columns: rows, spacing: Constants.rowSpacing, content: {
                ForEach(store.items) { item in
                    TrackedItemView(name: item.name,
                                    currentValue: item.currentValue ?? "No value",
                                    lastValue: item.values.first?.currentValue ?? "None",
                                    lastDateString: item.lastValueDateString,
                                    color: Color(item.colorName))
                    .onTapGesture {
                        store.send(.itemTapped(item: item))
                    }
                }
            })
            .navigationDestination(
                item: $store.scope(
                    state: \.itemDetails,
                    action: \.itemDetails
                )
              ) { store in
                ItemFeatureView()
              }
        }
    }
}

struct DateUtilities {
    static var defaultDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}
