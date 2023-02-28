//
//  File.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import FilePath
import Foundation

open class File {
    public enum OpenFlag {
        public enum WriteOption {
            case fromHead
            case append
        }
        
        case read
        case write(WriteOption)
        case readWrite(WriteOption)
    }
    
    let fileHandle: FileHandle
    public private(set) var filePath: FilePath
    public let openFlag: OpenFlag
    public init(filePath: FilePath, openFlag: OpenFlag = .read) throws {
        guard filePath.isFile, let _URL = URL(string: filePath.filePath) else {
            throw MixError.filePathIsNotCorrent(filePath)
        }
        
        self.filePath = filePath
        self.openFlag = openFlag
        
        var writeOption: OpenFlag.WriteOption?
        switch openFlag {
        case .read:
            if !filePath.isExists {
                throw MixError.fileNotExists(filePath)
            }
            self.fileHandle = try FileHandle(forReadingFrom: _URL)
        case let .write(option):
            writeOption = option
            try filePath.createIfNotExists()
            self.fileHandle = try FileHandle(forWritingTo: _URL)
        case let .readWrite(option):
            writeOption = option
            try filePath.createIfNotExists()
            self.fileHandle = try FileHandle(forUpdating: _URL)
        }
        
        if let wrappedWriteOption = writeOption {
            try updateWriteOption(wrappedWriteOption)
        }
    }
    
    private func updateWriteOption(_ option: OpenFlag.WriteOption) throws {
        switch option {
        case .fromHead: try fileHandle.seek(toOffset: 0)
        case .append: try fileHandle.seekToEnd()
        }
    }
    
    public var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: filePath.filePath, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        }
        return false
    }
    
    public var isFile: Bool {
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: filePath.filePath, isDirectory: &isDirectory) {
            return !isDirectory.boolValue
        }
        return false
    }
    
    open func close() throws {
        try fileHandle.close()
    }
    
    open func seekToHead() throws {
        try fileHandle.seek(toOffset: 0)
    }
    
    open func seekToEnd() throws {
        try fileHandle.seekToEnd()
    }
    
    open func write(_ string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else { throw MixError.stringInvalidToWrite(string, filePath) }
        try fileHandle.write(contentsOf: data)
    }
    
    open func readLine(_ encoding: String.Encoding = .utf8, chunkSize: Int = 4096) -> String? {
        let delimPattern = "\n".data(using: encoding)!
        var buffer = Data(capacity: chunkSize)
        
        if let range = buffer.range(of: delimPattern, options: [], in: buffer.startIndex ..< buffer.endIndex) {
            let subData = buffer.subdata(in: buffer.startIndex ..< range.lowerBound)
            let line = String(data: subData, encoding: encoding)
            return line
        } else {
            var tempData = fileHandle.readData(ofLength: chunkSize)
            while !tempData.isEmpty {
                buffer.append(tempData)
                tempData = fileHandle.readData(ofLength: chunkSize)
            }
            return (buffer.count > 0) ? String(data: buffer, encoding: encoding) : nil
        }
    }
    
    open func readLines(_ encoding: String.Encoding = .utf8, chunkSize: Int = 4096) -> [String] {
        var lines: [String] = []
        var line: String? = readLine(encoding, chunkSize: chunkSize)
        while let l = line {
            lines.append(l)
            line = readLine(encoding, chunkSize: chunkSize)
        }
        return lines
    }
    
    open func rename(_ newName: String) throws {
        try filePath.rename(newName)
    }
    
    open func remove() throws {
        try filePath.remove()
    }
}
