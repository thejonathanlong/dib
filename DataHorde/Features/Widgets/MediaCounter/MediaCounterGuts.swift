//
//  BookCounterGuts.swift
//  DataHorde
//
//  Created by Jonathan Long on 5/24/24.
//

import SwiftUI

struct MediaCounterGuts: View {
    var title: Binding<String>
    var author: Binding<String>
    var startDate: Binding<Date>
    var endDate: Binding<Date>
    var lastValue: String?
    var lastDate: String?

    var body: some View {
        VStack {
            TextField("Book Title",
                      text: title,
                      prompt: Text("Book Title..."))
            .lineLimit(3, reservesSpace: true)
            .font(.title3)
            TextField("Author",
                      text: author,
                      prompt: Text("Author..."))
            .lineLimit(3, reservesSpace: true)
            .font(.headline)
            VStack(alignment: .leading) {
                DatePicker(selection: startDate) {
                    Text("Start:")
                }
                .datePickerStyle(.compact)
                if let lastDate, let lastValue {
                    Text("**\(lastValue)** finished on **\(lastDate)**")
                        .lineLimit(2)
                        .font(.subheadline)
                }
            }
        }
        .padding()
    }
}

#Preview {
    MediaCounterGuts(title: .constant(""), author: .constant(""), startDate: .constant(Date()), endDate: .constant(Date()), lastValue: "", lastDate: "\(Date())")
}
