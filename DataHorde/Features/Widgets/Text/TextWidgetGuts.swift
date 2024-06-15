//
//  TextWidgetGuts.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/13/24.
//

import SwiftUI

struct TextWidgetGuts: View {
    var text: Binding<String>
    var date: Binding<Date>
    var lastValue: String?
    var lastDate: String?

    var body: some View {
        VStack {
            TextField("New Value",
                      text: text,
                      prompt: Text("Enter value..."))
            .lineLimit(3, reservesSpace: true)
            .font(.title3)
            VStack(alignment: .leading) {
                DatePicker(selection: date) {
                    Text("Date: ")
                }
                .datePickerStyle(.compact)
                if let lastDate, let lastValue {
                    Text("**\(lastValue)** at **\(lastDate)**")
                        .lineLimit(2)
                        .font(.subheadline)
                }
            }
        }
        .padding()
    }
}

#Preview {
    TextWidgetGuts(text: .constant("This is text."),
                   date: .constant(Date()),
                   lastValue: "Last value",
                   lastDate: "\(Date().addingTimeInterval(TimeInterval(60 * 27 * -1)))")
}
