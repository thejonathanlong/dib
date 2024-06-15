//
//  CadenceModel.swift
//  DataHorde
//
//  Created by Jonathan Long on 3/2/24.
//

//import Foundation
//import PoCampo
//
//struct CadenceModel: AsyncDataStorableModel, Equatable {
//    enum CadenceType: String, CaseIterable, Identifiable {
//        case daily
//        case weekly
//        case monthly
//        case yearly
//        case none
//
//        var id: String {
//            rawValue
//        }
//    }
//    
//    typealias ManagedObject = Cadence
//
//    var uniqueId: String
//
//    var cadenceType: CadenceType
//
//    static var entityName = "Cadence"
//
//    init(object: Cadence) {
//        self.uniqueId = object.uniqueId ?? "Uhoh, no Id"
//        self.cadenceType = CadenceType(rawValue: object.cadenceType!)!
//    }
//
//    static func update(managedObject: Cadence, with model: CadenceModel) {
//        managedObject.uniqueId = model.uniqueId
//        managedObject.cadenceType = model.cadenceType.rawValue
//    }
//
//}
