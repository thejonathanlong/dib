//
//  ItemFetchingService.swift
//  DataHorde
//
//  Created by Jonathan Long on 4/6/24.
//

import Dependencies
import Foundation
import PoCampo

protocol ItemsFetching {
    associatedtype V: DataConvertibleValue
    func streamItems() -> AsyncThrowingStream<[TrackedItemModel], Error>
}

class ItemFetchingService<V: DataConvertibleValue>: ItemsFetching {
    @Dependency(\.dataStore) var dataStore

    var stream: AsyncThrowingStream<[TrackedItemModel], Error>?

    func streamItems() -> AsyncThrowingStream<[TrackedItemModel], Error> {
        guard let stream else {
            let newStream: AsyncThrowingStream<[TrackedItemModel], Error> = dataStore.stream(matching: .init(value: true))
            self.stream = newStream
            return newStream
        }

        return stream
    }
}
