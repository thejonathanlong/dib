//
//  DataStoreDependencies.swift
//  DataHorde
//
//  Created by Jonathan Long on 4/3/24.
//

import CoreData
import Dependencies
import Foundation
import PoCampo

//private enum 

private enum AsyncDataStoreKey: DependencyKey {
    static var liveValue: any AsyncDataStoreCompatible {
        let modelURL = Bundle.main.url(forResource: "DataHorde", withExtension: "momd")!
        print("modelURL \(try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true))")
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let dataManager = DataManager(containerName: "DataHorde", managedObjectModel: managedObjectModel)
        return dataManager.makeAsyncStore()
    }
}

private enum ItemCreatableKey: DependencyKey {
    static var liveValue: ItemCreatable = ItemCreationService()
}

private enum WidgetCreatableKey: DependencyKey {
    static var liveValue: WidgetCreatable = WidgetCreationService()
}

private enum ItemsFetchingKey: DependencyKey {
    static var liveValue: any ItemsFetching = ItemFetchingService()
}

extension DependencyValues {
    var dataStore: any AsyncDataStoreCompatible {
        get { self[AsyncDataStoreKey.self] }
        set { self[AsyncDataStoreKey.self] = newValue }
    }

    var itemCreationService: any ItemCreatable {
        get { self[ItemCreatableKey.self] }
        set { self[ItemCreatableKey.self] = newValue }
    }

    var widgetCreationService: any WidgetCreatable {
        get { self[WidgetCreatableKey.self] }
        set { self[WidgetCreatableKey.self] = newValue }
    }

    var itemFetchingStream: any ItemsFetching {
        get { self[ItemsFetchingKey.self] }
        set { self[ItemsFetchingKey.self] = newValue }
    }
}

// This is a change.
