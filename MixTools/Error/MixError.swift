//
//  MixError.swift
//  MixTools
//
//  Created by mayong on 2023/2/28.
//

import Foundation
import FilePath

public enum MixError: Error {
    case fileNotExists(FilePath)
    case filePathIsNotCorrent(FilePath)
    case stringInvalidToWrite(String, FilePath)
}

public extension MixError {
    var errorDescription: String {
        switch self {
        case let .fileNotExists(filePath): return "\(filePath.filePath) is not exists"
        case let .filePathIsNotCorrent(filePath): return "\(filePath.filePath) is not correct"
        case let .stringInvalidToWrite(string, filePath): return "\(string) is invalid to write to file \(filePath.filePath)"
        }
    }
}
