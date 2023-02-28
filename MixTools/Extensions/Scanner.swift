//
//  Scanner.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

extension Scanner {
    
    func scanFirstQuotationString() -> String? {
        if scanUpToString("\"") != nil {
            return scanUpToString("\"")?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
    
    func scanProtocolName() -> String? {
        if scanUpToString(" ") != nil {
            return scanUpToString("<")?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
    
    func scanFirstWordBetweenWhitespace() -> String? {
        if scanUpToString(" ") != nil {
            return scanUpToString(" ")?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
}
