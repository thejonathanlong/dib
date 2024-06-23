//
//  TrackedValueModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo

extension DBValue: UniqueManagedObject { }

struct Book: Codable, Equatable, CustomStringConvertible {
    let title: String?
    let author: String?

    var description: String {
        guard let title, let author else { return "" }
        return title + " by " + author
    }
}

struct TrackedValueModelConstants {
    static let double = "double"
    static let text = "text"
    static let book = "book"
}

protocol DataConvertibleValue {
    init(data: Data)

    func convertToData() -> Data
}

struct TrackedValueModel: AsyncDataStorableModel, Equatable {
    typealias ManagedObject = DBValue

    enum TrackedValueType: Equatable {


        case number(value: Double)
        case text(value: String)
        case book(value: Book)

        init?(rawValue: String?, data: Data?) {
            switch rawValue?.lowercased() {
            case TrackedValueModelConstants.double:
                let value: Double
                if let data, let string = String(data: data, encoding: .utf8) {
                    value = Double(string) ?? 0
                } else {
                    value = 0
                }
                self = .number(value: value)
            default:
                return nil
            }
        }

        var rawValue: String {
            switch self {
            case .number:
                return TrackedValueModelConstants.double
            case .text:
                return TrackedValueModelConstants.text
            case .book:
                return TrackedValueModelConstants.book
            }
        }

        var rawData: Data {
            switch self {
            case let .number(value: value):
                return String(value).data(using: .utf8) ?? Data()
            case let .text(value: value):
                return value.data(using: .utf8) ?? Data()
            case let .book(value: value):
                let encoder = JSONEncoder()
                return (try? encoder.encode(value)) ?? Data()
            }
        }
    }

    var uniqueId: String = "ProbablyNeedAnIdProperty"

    let type: TrackedValueType

    let date: Date

    static var entityName: String {
        "DBTrackedValue"
    }

    var value: String {
        switch type {
        case .number(let value):
            return String(value)
        case .text(value: let value):
            return value
        case .book(value: let value):
            return value.description
        }
    }

    var defaultValue: String {
        switch type {
        case .number:
            return String(0)
        case .text:
            return ""
        case .book:
            return ""
        }
    }

    var isNumber: Bool {
        switch type {
        case .number:
            return true
        case .text, .book:
            return false
        }
    }

    var numberValue: Double? {
        switch type {
        case .number(let value):
            return value
        case .text:
            return nil
        case .book:
            return nil
        }
    }

    init(object: ManagedObject) {
        self.type = .init(rawValue: object.type, data: object.value) ?? .number(value: 0)
        self.date = object.date ?? Date()
    }

    init(type: TrackedValueType, date: Date = Date()) {
        self.type = type
        self.date = date
    }

    static func update(managedObject: ManagedObject, with model: TrackedValueModel) {
        managedObject.type = model.type.rawValue
        managedObject.value = model.type.rawData
        managedObject.date = model.date
    }
}

