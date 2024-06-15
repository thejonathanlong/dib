//
//  CadenceSelectionFeature.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

//import ComposableArchitecture
//import Foundation
//import PoCampo
//
//@Reducer
//struct CadenceSelectionFeature {
//    @ObservableState
//    struct State: Equatable {
//        let cadenceList = CadenceModel.CadenceType.allCases
//        var selectedCadence: CadenceModel.CadenceType
//    }
//
//    enum Action {
//        case cadenceTypeChanged(cadence: CadenceModel.CadenceType)
//    }
//
//    var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//                case let .cadenceTypeChanged(cadence: cadence):
//                    state.selectedCadence = cadence
//                    return .none
//            }
//        }
//    }
//}
