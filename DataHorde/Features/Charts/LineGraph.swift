//
//  LineGraph.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/10/24.
//

import Charts
import SwiftUI

struct LineGraph: View {
    let lines: [LineGraphFeature.Line]
    @State var newX: Date?
    @State var newY: Double?
    var body: some View {
        Chart {
            ForEach(lines) { line in
                ForEach(line.points) { point in
                    LineMark(x: .value(point.x.valueDescription, point.x.value),
                             y: .value(point.y.valueDescription, point.y.value),
                             series: .value(line.uniqueId, line.uniqueId))
                    PointMark(x: .value(point.x.valueDescription, point.x.value),
                              y: .value(point.y.valueDescription, point.y.value))
                    if let newX, let newY {
                        RuleMark(x: .value("Date", newX))
                            .foregroundStyle(.red)
                    }
                }
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture().onChanged { value in updateCursorPosition(at: value.location, geometry: geometry, proxy: proxy) })
                    .onTapGesture { location in updateCursorPosition(at: location, geometry: geometry, proxy: proxy) }
            }
        }
    }

    func updateCursorPosition(at: CGPoint, geometry: GeometryProxy, proxy: ChartProxy) {
        guard let data = lines.first, let plotFrame = proxy.plotFrame else { return }
        let origin = geometry[plotFrame].origin
        if let datePos = proxy.value(atX: at.x - origin.x, as: Date.self),
           let index = data.points.lastIndex(where: { $0.x.value <= datePos }) {
            let time = data.points[index].x.value
            let newDouble = data.points[index].y.value
            //            let height = data[index].height.doubleValue(for: diveManager.heightUnit)
            //            position = ChartPosition(x: time, y: height)
            newX = time
            newY = newDouble
        }
    }
}

#Preview {
    LineGraph(lines: [
        .init(points: [.init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24)),
                             y: (valueDescription: "y", value: 2),
                             uniqueId: "point1"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*2)),
                             y: (valueDescription: "y", value: 3),
                             uniqueId: "point2"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*3)),
                             y: (valueDescription: "y", value: 2),
                             uniqueId: "point3"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*4)),
                             y: (valueDescription: "y", value: 3),
                             uniqueId: "point4"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*5)),
                             y: (valueDescription: "y", value: 3),
                             uniqueId: "point5")
        ],
              uniqueId: "line1"),
        .init(points: [.init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24)),
                             y: (valueDescription: "y", value: 20),
                             uniqueId: "point12"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*2)),
                             y: (valueDescription: "y", value: 30),
                             uniqueId: "point22"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*3)),
                             y: (valueDescription: "y", value: 20),
                             uniqueId: "point32"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*4)),
                             y: (valueDescription: "y", value: 30),
                             uniqueId: "point42"),
                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*5)),
                             y: (valueDescription: "y", value: 30),
                             uniqueId: "point52")
        ],
              uniqueId: "line"),

    ])
    .frame(maxHeight: 400)
}
