//
//  TrackedValueModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation
import PoCampo

extension DBValue: UniqueManagedObject { }

struct Book: Codable, Equatable, CustomStringConvertible, DataConvertibleValue {
    init?(valueData: Data) {
        let decoder = JSONDecoder()
        if let book = try? decoder.decode(Book.self, from: valueData) {
            self = book
        } else {
            return nil
        }
    }

    init(title: String?, author: String?) {
        self.title = title
        self.author = author
    }

    func convertToData() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }

    var defaultValue: Book {
        .init(title: nil, author: nil)
    }

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

protocol DataConvertibleValue: Equatable {
    init?(valueData: Data)

    func convertToData() -> Data?

    var defaultValue: Self { get }
}

extension String: DataConvertibleValue {
    init?(valueData: Data) {
        self.init(data: valueData, encoding: .utf8)
    }
    func convertToData() -> Data? {
        data(using: .utf8)
    }
    
    var defaultValue: String {
        ""
    }
}

extension Double: DataConvertibleValue {
    init?(valueData: Data) {
        if let string = String(data: valueData, encoding: .utf8) {
            self = Double(string) ?? 0
        } else {
            self = 0
        }
    }

    func convertToData() -> Data? {
        String(self).data(using: .utf8) ?? Data()
    }
    
    var defaultValue: Double {
        0
    }
}

enum TrackedValueType: String, Equatable {
    case number
    case text
    case book
}

struct TrackedValueModel: AsyncDataStorableModel, Equatable, ItemValueProvider {
    static func == (lhs: TrackedValueModel, rhs: TrackedValueModel) -> Bool {
        lhs.uniqueId == rhs.uniqueId && lhs.date == rhs.date && lhs.type == rhs.type && lhs.data == rhs.data
    }
    
    typealias ManagedObject = DBValue

    let data: Data?

    let value: Any?

    let type: TrackedValueType

    var uniqueId: String

    var date: Date

    static var entityName: String {
        "DBValue"
    }

    init(object: ManagedObject) {
        let type = TrackedValueType(rawValue: object.type ?? TrackedValueModelConstants.double) ?? .number
        switch type {
        case .number:
            self.init(type: type, value: Double(valueData: object.value ?? Data()), uniqueId: object.uniqueId!)
        case .text:
            self.init(type: type, value: String(valueData: object.value ?? Data()), uniqueId: object.uniqueId!)
        case .book:
            self.init(type: type, value: Book(valueData: object.value ?? Data()), uniqueId: object.uniqueId!)
        }
    }

    init<V: DataConvertibleValue>(type: TrackedValueType, value: V?, uniqueId: String, date: Date = Date()) {
        self.type = type
        self.date = date
        self.value = value
        self.data = value?.convertToData()
        self.uniqueId = uniqueId
    }

    static func update(managedObject: ManagedObject, with model: TrackedValueModel) {
        managedObject.type = model.type.rawValue
        managedObject.value = model.data
        managedObject.date = model.date
        managedObject.uniqueId = model.uniqueId
    }
}
