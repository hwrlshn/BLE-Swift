//
//  Operators.swift
//  BLESwift
//
//  Created by Bohdan Hawrylyshyn on 25.04.24.
//

import Foundation

precedencegroup FunctionApplicationPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator &>: FunctionApplicationPrecedence

public func &> <Input>(value: Input, function: (inout Input) throws -> Void) rethrows -> Input {
    var m_value = value
    try function(&m_value)
    return m_value
}
