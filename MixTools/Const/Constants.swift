//
//  Constants.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

public struct AttributeOrder {
    let rawValue: Int
        
    static let lowest = AttributeOrder(rawValue: 1 << 10000)
    
    static let low = AttributeOrder(rawValue: 1 << 1000)
    
    static let medium = AttributeOrder(rawValue: 1 << 100)
    
    static let high = AttributeOrder(rawValue: 1 << 10)

    static let highest = AttributeOrder(rawValue: 0)
    
    static let `default` = AttributeOrder.medium
}

public extension FileAttributeCompatible {
    var order: Int {
        AttributeOrder.default.rawValue
    }
}
