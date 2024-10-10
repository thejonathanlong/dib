//
//  BarGraph.swift
//  DataHorde
//
//  Created by Jonathan Long on 6/12/24.
//
//
//import Charts
//import SwiftUI
//
//struct BarGraph: View {
//    let bars: [LineGraphFeature.State.Point]
//    @State var newX: Date?
//    @State var newY: Double?
//
//    var body: some View {
//        Chart {
//            ForEach(bars) { bar in
//                BarMark(x: .value(bar.x.valueDescription, bar.x.value), y: .value(bar.y.valueDescription, bar.y.value))
//                if let newX, let newY {
//                    PointMark(x: .value("s", newX), y: .value("a", newY))
//                        .foregroundStyle(.red)
//                }
//            }
//        }.chartOverlay { proxy in
//            GeometryReader { geometry in
//                Rectangle().fill(.clear).contentShape(Rectangle())
//                    .gesture(DragGesture().onChanged { value in updateCursorPosition(at: value.location, geometry: geometry, proxy: proxy) })
//                    .onTapGesture { location in updateCursorPosition(at: location, geometry: geometry, proxy: proxy) }
//            }
//        }
//    }
//
//    func updateCursorPosition(at: CGPoint, geometry: GeometryProxy, proxy: ChartProxy) {
//        guard let plotFrame = proxy.plotFrame else { return }
//        let data = bars
//        let origin = geometry[plotFrame].origin
//        if let datePos = proxy.value(atX: at.x - origin.x, as: Date.self),
//           let index = data.lastIndex(where: { $0.x.value <= datePos }) {
//            let time = data[index].x.value
//            let newDouble = data[index].y.value
//            //            let height = data[index].height.doubleValue(for: diveManager.heightUnit)
//            //            position = ChartPosition(x: time, y: height)
//            newX = time
//            newY = newDouble
//        }
//    }
//}
//
//#Preview {
//    BarGraph(bars: [
//        .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24)),
//                             y: (valueDescription: "y", value: 2),
//                             uniqueId: "point1"),
//                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*2)),
//                             y: (valueDescription: "y", value: 3),
//                             uniqueId: "point2"),
//                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*3)),
//                             y: (valueDescription: "y", value: 2),
//                             uniqueId: "point3"),
//                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*4)),
//                             y: (valueDescription: "y", value: 3),
//                             uniqueId: "point4"),
//                       .init(x: (valueDescription: "x", value: Date().addingTimeInterval(60*60*24*5)),
//                             y: (valueDescription: "y", value: 3),
//                             uniqueId: "point5")
//    ])
//    .frame(maxWidth: 300, maxHeight: 400)
//}
