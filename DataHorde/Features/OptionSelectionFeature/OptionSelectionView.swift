//
//  OptionSelectionView.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/14/24.
//

import ComposableArchitecture
import SwiftUI

protocol BackgroundProvider: Equatable {
    var backgroundColor: Color { get }
}

struct OptionSelectionView<Option: OptionSelection>: View {
    @Bindable var store: StoreOf<OptionSelectionFeature<Option>>

    let constants = Constants()

    struct Constants {
        let pillPadding: CGFloat = 8.0
        let contentPadding: CGFloat = 4
        let lineWidth: CGFloat = 2.0
        let insets = EdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(store.state.options) { option in
                    Group {
                        if store.state.isRounded {
                            roundedItem(option: option)
                        } else {
                            item(option: option)
                        }
                    }
                    .onTapGesture {
                        store.send(.optionChanged(option: option))
                    }
                }
            }
            .padding(.all, constants.contentPadding)
        }
    }

    func roundedItem(option: Option) -> some View {
        Circle()
            .stroke(store.state.selectedOption == option ? .black : .clear, lineWidth: constants.lineWidth)
            .fill(option.backgroundColor)
            .frame(height: 50)
            .padding(constants.insets)
    }

    func item(option: Option) -> some View {
        Text(option.description)
            .padding(EdgeInsets(top: constants.pillPadding, leading: constants.pillPadding, bottom: constants.pillPadding, trailing: constants.pillPadding))
            .background(RoundedRectangle(cornerRadius: 12.0)
                .fill(option.backgroundColor))
            .overlay {
                RoundedRectangle(cornerRadius: 12.0)
                    .inset(by: 2)
                    .stroke(option == store.state.selectedOption ? .black : .clear, style: .init(lineWidth: constants.lineWidth))
            }
    }
}
