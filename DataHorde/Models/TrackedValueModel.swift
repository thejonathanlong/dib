//
//  TrackedValueModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo

struct TrackedValueModel: AsyncDataStorableModel {
    typealias ManagedObject = TrackedValue

    enum TrackedValueType {
        struct Constants {
            static let int = "int"
        }

        case int(value: Int)

        init?(rawValue: String?, data: Data?) {
            switch rawValue?.lowercased() {
            case Constants.int:
                let value: Int
                if let data, let string = String(data: data, encoding: .utf8) {
                    value = Int(string) ?? 0
                } else {
                    value = 0
                }
                self = .int(value: value)
            default:
                return nil
            }
        }

        var rawValue: String {
            switch self {
            case .int:
                return Constants.int
            }
        }

        var rawData: Data {
            switch self {
            case let .int(value: value):
                return String(value).data(using: .utf8) ?? Data()
            }
        }
    }

    var uniqueId: String = "ProbablyNeedAnIdProperty"

    let type: TrackedValueType

    let date: Date

    static var entityName: String {
        "TrackedValue"
    }

    init(object: TrackedValue) {
        self.type = .init(rawValue: object.type, data: object.value) ?? .int(value: 0)
        self.date = object.date ?? Date()
    }

    static func update(managedObject: TrackedValue, with model: TrackedValueModel) {
        managedObject.type = model.type.rawValue
        managedObject.value = model.type.rawData
        managedObject.date = model.date
    }
}
