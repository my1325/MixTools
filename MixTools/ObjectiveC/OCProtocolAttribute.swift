//
//  ObjectiveCProtocolAttribute.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

public struct OCProtocolProperty {
    let line: String
    let propertyName: String
    init?(line: String) {
        guard line.hasPrefix(.ocPropertyPrefix) else { return nil }
        let scanner = Scanner(string: String(line.reversed()))
        if scanner.scanString(";") != nil {
            var name = scanner.scanUpToString(" ")
            if name == nil {
                name = scanner.scanUpToString("*")
            }
            
            if name == nil { return nil }
            
            self.line = line
            self.propertyName = name!
        } else {
            return nil
        }
    }
}

public final class OCProtocolSection {
    
    var sectionName: String
    init(sectionName: String) {
        self.sectionName = sectionName
    }
    
    private(set) var lines: [String] = []
    
    func addLine(_ line: String) {
        
    }
    
    func formatWithConfig(_ config: Any) -> String {
        
    }
    
    public func compatibleConfig(_ config: Any?) -> Any {
        
    }
}

public final class OCProtocolAttribute: FileAttributeCompatible {
    
    private var protocolName: String = "protocol"
    
    public var name: String { protocolName }
    
    public var order: Int { AttributeOrder.high.rawValue }
    
    private var section: [OCProtocolSection] = []
    
    private var isEnd: Bool = false
    
    private var headLine: String = ""
    
    public func addLine(_ line: String) -> Bool {
        guard !isEnd else { return false }
        let _line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: line)
        if _line.hasPrefix(.atProtocolPrefix), let protocolName = scanner.scanProtocolName() {
            self.protocolName = protocolName
            if _line.hasSuffix(";") {
                isEnd = true
            }
            self.headLine = _line
        } else if _line == .ocClassEnd {
            isEnd = true
        } else if _line == .protocolOptional {
            section.append(OCProtocolSection(sectionName: .protocolOptional))
        } else if _line == .protocolRequired {
            section.append(OCProtocolSection(sectionName: .protocolRequired))
        } else {
            if section.isEmpty {
                section.append(OCProtocolSection(sectionName: .protocolRequired))
            }
            section.last?.addLine(line)
        }
        return false
    }
    
    public func formatWithConfig(_ config: Any) -> String {
        var retStringList: [String] = [headLine]
        let _config = (config as? [String: Any]) ?? [:]
        let sortedSection = _config["sortedNames"] as? [String] ?? []
        var _section = section
        for name in sortedSection {
            for i in 0 ..< _section.count {
                if name == _section[i].sectionName {
                    let s = _section.remove(at: i)
                    let string = s.formatWithConfig(_config[s.sectionName] ?? [])
                    retStringList.append(string)
                }
            }
        }
        
        if !_section.isEmpty {
            let value = _section.mixed().map({ $0.formatWithConfig(_config[$0.sectionName] ?? []) })
            retStringList.append(contentsOf: value)
        }
        return retStringList.joined(separator: "\n")
    }
    
    public func compatibleConfig(_ config: Any?) -> Any {
        var retValue = (config as? [String: Any]) ?? [:]
        var array = retValue["sortedNames"] as? [String] ?? []
        for s in section {
            retValue[s.sectionName] = s.compatibleConfig(retValue[s.sectionName])
            if !array.contains(s.sectionName) {
                if array.isEmpty {
                    array.append(s.sectionName)
                } else {
                    let index = Int(arc4random()) % array.count
                    array.insert(s.sectionName, at: index)
                }
            }
        }
        retValue["sortedNames"] = array
        return retValue
    }
}
