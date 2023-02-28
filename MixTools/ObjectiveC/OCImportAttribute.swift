//
//  ObjectiveCImportAttribute.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

public struct OCImportSingleAttribute {
    let line: String
    let importName: String
    init?(line: String) {
        let scanner = Scanner(string: line)
        if line.hasPrefix(.ocImportPrefix) || line.hasPrefix(.atImportPrefix), let importName = scanner.scanFirstQuotationString() {
            self.line = line
            self.importName =  importName
        } else {
            return nil
        }
    }
}

public final class OCImportAttribute: FileAttributeCompatible {
    public var name: String { "import" }

    public private(set) var singleImportAttributeList: [OCImportSingleAttribute] = []
    
    public var order: Int {
        AttributeOrder.high.rawValue
    }

    public func addLine(_ line: String) -> Bool {
        var _line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if let singleImportAttribute = OCImportSingleAttribute(line: _line) {
            self.singleImportAttributeList.append(singleImportAttribute)
            return true
        }
        return false
    }
    
    public func formatWithConfig(_ config: Any) -> String {
        guard let _config = config as? [String] else { return singleImportAttributeList.mixed().map({ $0.line }).joined(separator: "\n") }
        var importNames: [OCImportSingleAttribute] = singleImportAttributeList
        var sortedLines: [String] = []
        for s in _config {
            for i in 0 ..< importNames.count {
                if s == importNames[i].importName {
                    sortedLines.append(importNames.remove(at: i).importName)
                }
            }
        }
        
        if !importNames.isEmpty {
            sortedLines.append(contentsOf: importNames.mixed().map({ $0.line }))
        }
        return sortedLines.joined(separator: "\n")
    }
    
    public func compatibleConfig(_ config: Any?) -> Any {
        guard var _config = config as? [String] else { return singleImportAttributeList.mixed().map({ $0.importName }) }
        let importNames = singleImportAttributeList.map { $0.importName }
        for importName in importNames {
            if _config.contains(importName) { continue }
            if !_config.isEmpty { _config.append(importName) }
            else {
                let index = Int(arc4random()) % _config.count
                _config.insert(importName, at: index)
            }
        }
        return _config
    }
}
