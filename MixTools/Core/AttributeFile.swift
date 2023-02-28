//
//  ClassFile.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation

public protocol FileAttributeCompatible {
    var name: String { get }
        
    var order: Int { get }
    
    func addLine(_ line: String) -> Bool
    
    func formatWithConfig(_ config: Any) -> String
    
    func compatibleConfig(_ config: Any?) -> Any
}

open class AttributeFile: File {
    public var attribute: [FileAttributeCompatible] = []
    
    open func writeToFile(_ config: [String: Any] = [:]) throws -> [String: Any] {
        try seekToHead()
        var _config = config
        let attribute = attribute.mixed().sorted(by: { $0.order < $1.order })
        let content = attribute.map {
            let attributeConfig = _config[$0.name]
            let attributeCompatibleConfig = $0.compatibleConfig(attributeConfig)
            _config[$0.name] = attributeCompatibleConfig
            return $0.formatWithConfig(attributeCompatibleConfig)
        }
        .joined(separator: "\n")
        try write(content)
        return config
    }
    
    open func parseFile() {
        fatalError()
    }
}
