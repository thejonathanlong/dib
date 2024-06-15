//
//  OptionSelectionFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/14/24.
//

import ComposableArchitecture
import Foundation
import PoCampo
import SwiftUI

typealias OptionSelection = BackgroundProvider & Identifiable & CustomStringConvertible & Equatable

@Reducer
struct OptionSelectionFeature<Option: OptionSelection> {
    @ObservableState
    struct State: Equatable {
        let options: [Option]
        var selectedOption: Option
        var isRounded: Bool

        init(options: [Option], selectedOption: Option, isRounded: Bool = false) {
            self.options = options
            self.selectedOption = selectedOption
            self.isRounded = isRounded
        }
    }

    enum Action {
        case optionChanged(option: Option)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case let .optionChanged(option: option):
                    state.selectedOption = option
                    return .none
            }
        }
    }
}


