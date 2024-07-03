//
//  CounterFeatureView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import ComposableArchitecture
import SwiftUI

struct CounterFeatureView: View {
    @Bindable var store: StoreOf<CounterFeature>

    struct Constants {
        static let buttonHeight: CGFloat = 25
    }
    var body: some View {
        VStack {
            Text(store.trackedItem.name)
                .font(.largeTitle)
            HStack{
                Button {
                    store.send(.decrement)
                } label: {
                    Image(systemName: "minus")
                        .imageScale(.large)
                        .frame(height: Constants.buttonHeight)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
                Text(store.currentValue.display)
                    .font(.title2)
                Spacer()
                Button {
                    store.send(.increment)
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .frame(height: Constants.buttonHeight)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
    }
}

//#Preview {
//    CounterFeatureView()
//}
