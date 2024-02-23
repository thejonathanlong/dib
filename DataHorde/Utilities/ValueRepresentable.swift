//
//  ValueRepresentable.swift
//  DataHorde
//
//  Created by Jonathan Long on 2/7/24.
//

import Foundation

protocol ValueRepresentable: Equatable {
    var valueForDisplay: String { get }

    mutating func increment() -> Self

    mutating func decrement() -> Self
}
