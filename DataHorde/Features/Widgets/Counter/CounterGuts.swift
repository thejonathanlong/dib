//
//  CounterGuts.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

import SwiftUI

struct CounterGuts: View {
    struct Constants {
        static let buttonHeight: CGFloat = 25
    }

    let name: String?
    let currentValueString: String
    let color: Color
    var date: Binding<Date>
    let dailyValue: String?
    let lastDate: Date?
    let onDecrement: () -> Void
    let onIncrement: () -> Void
    let onInfo: () -> Void

    var body: some View {
        VStack {
            HStack{
                Button {
                    onDecrement()
                } label: {
                    Image(systemName: "minus")
                        .imageScale(.large)
                        .frame(height: Constants.buttonHeight)
                }
                .buttonStyle(.borderedProminent)
                Spacer()
                Text(currentValueString)
                    .font(.headline)
                Spacer()
                Button {
                    onIncrement()
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .frame(height: Constants.buttonHeight)
                }
                .buttonStyle(.borderedProminent)
            }
            .controlSize(.regular)
            .tint(color)
            VStack(alignment: .leading) {
                DatePicker(selection: date) {
                    Text("Date: ")
                }
                .datePickerStyle(.compact)
                if let dailyValue {
                    Text("**\(dailyValue)** so far today.")
                        .font(.subheadline)
                } else {
                    Text("No values recorded yet.")
                        .font(.subheadline)
                }
            }
        }
        .padding()
    }
}

#Preview {
    CounterGuts(name: "Ounces of Water",
                currentValueString: "100 oz",
                color: .pinkish,
                date: .constant(Date()),
                dailyValue: "10 oz",
                lastDate: Date(),
                onDecrement: {},
                onIncrement: {},
                onInfo: {})
}
