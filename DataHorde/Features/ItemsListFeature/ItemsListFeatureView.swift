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
        static let itemSize = GridItem.Size.fixed(325)
        static let columnSpacing: CGFloat = 25
        static let rowSpacing: CGFloat = 25
    }

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    @Bindable var store: StoreOf<ItemsListFeature>

    var rows: [GridItem] {
        switch (horizontalSizeClass, verticalSizeClass) {
        case (.regular, .regular):
            return [GridItem(Constants.itemSize, spacing: Constants.columnSpacing),
             GridItem(Constants.itemSize, spacing: Constants.columnSpacing)]
        default:
            return [GridItem(Constants.itemSize, spacing: Constants.columnSpacing)]
        }

    }

    var itemList: some View {
        // Make ItemFeatureView inline here. It's just a Vstack that switches on widget type, plops donw the widget and then adds an add Value button at the bottom.
        // Not 100% sure how the add value button works... but maybe thats ok...
        
        LazyVGrid(columns: rows, spacing: Constants.rowSpacing, content: {
            ForEach(store.items) { (item: TrackedItemModel) in
                ItemFeatureView(store: .init(initialState: .init(item: item), reducer: {
                    ItemFeature()
                }))
                .onTapGesture {
                    store.send(.itemTapped(item: item))
                }
            }
        })
    }

    var toolBar: some View {
        Button {
            store.send(.addItemTapped)
        } label: {
            Image(systemName: "plus")
        }
        .fullScreenCover(item: $store.scope(state: \.addItem, action: \.addItem), content: { store in
            AddItemView(store: store)
        })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                itemList
                    .navigationDestination(
                    item: $store.scope(state: \.itemDetails,
                                       action: \.itemDetails)
                ) { store in
                    ItemFeatureView(store: store)
                }
            }
            .navigationTitle("Items")
            .toolbar {
                toolBar
            }
        }.onAppear(perform: {
            store.send(.fetchItems)
        })
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
