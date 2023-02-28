//
//  Array+Extensions.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

public extension Array {
    func mixed() -> Self {
        var indexes: [Int] = []
        for i in 0 ..< count {
            indexes.append(i)
        }
        
        var retValue: [Element] = []
        while !indexes.isEmpty {
            let index = Int(arc4random()) % indexes.count
            let i = indexes.remove(at: index)
            retValue.append(self[i])
        }
        return retValue
    }
}
