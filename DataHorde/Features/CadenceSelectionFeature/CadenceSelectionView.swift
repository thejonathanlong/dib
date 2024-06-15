//
//  CadenceSelectionView.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

import ComposableArchitecture
import SwiftUI

//struct CadenceSelectionView: View {
//    @Bindable var store: StoreOf<CadenceSelectionFeature>
//
//    @State var isExpanded: Bool
//
//    struct Constants {
//        static let selectedImageName = "circle.fill"
//        static let unSelectedImageName = "circle"
//        static let imageColor = Color.blue
//        static let interItemVerticalSpacing = 12.0
//    }
//
//    var body: some View {
//        Section {
//            VStack(spacing: Constants.interItemVerticalSpacing) {
//                ForEach(store.state.cadenceList) { cadence in
//                    HStack {
//                        Text(cadence.rawValue.capitalized)
//                        Spacer()
//                        if cadence == store.state.selectedCadence {
//                            Image(systemName: Constants.selectedImageName)
//                                .foregroundStyle(Constants.imageColor)
//                        } else {
//                            Image(systemName: Constants.unSelectedImageName)
//                                .foregroundStyle(Constants.imageColor)
//                        }
//                    }
//                    .onTapGesture {
//                        store.send(.cadenceTypeChanged(cadence: cadence), animation: .snappy)
//                    }
//                    Divider()
//                }
//            }
//            .padding()
//        } header: {
//            HStack {
//                Image(systemName: "clock")
//                Text("Cadence")
//                Spacer()
//            }
//            .font(.headline)
//        }
//
//    }
//}

//#Preview {
//    CadenceSelectionView(isExpanded: true)
//}
