//
//  ConstStrings.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

extension String {
    static let ocDocumentPrefix = "//"
    static let documentBegin = "/*"
    static let documentEnd = "*/"
    
    static let ocImportPrefix = "#import"
    static let atImportPrefix = "@import"
    
    static let ocClassPrefix = "@interface"
    static let ocClassEnd = "@end"
    
    static let atClassPrefix = "@class"
    static let atProtocolPrefix = "@protocol"
    static let protocolOptional = "@optional"
    static let protocolRequired = "@required"
    
    static let ocPropertyPrefix = "@property"
    
    static let ocInstanceMethodPrefix = "-"
    static let ocClassMethodPrefix = "+"
}
