//
//  TrackedItemView.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/23/24.
//

import SwiftUI

struct TrackedItemView: View {
    let name: String
    let currentValue: String?
    let lastValue: String?
    let lastDateString: String?
    let color: Color
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.headline)
            if let currentValue {
                Text(currentValue)
                    .font(.subheadline)
            }
            if let lastValue, let lastDateString {
                HStack(alignment: .center, spacing: 30) {
                    Text(lastDateString)
                    Text(lastValue)
                }
                .font(.caption)
            }
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .stroke(color, lineWidth: 1.0)
        }
    }
}

#Preview {
    TrackedItemView(name: "Ounces of Water", currentValue: "20 oz", lastValue: "8 oz", lastDateString: "12/2/2024 10:00am", color: Color.green)

}
