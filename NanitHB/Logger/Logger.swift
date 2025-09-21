//
//  Logger.swift
//
//  Created by Konstantin Bezzemelnyi on 19.03.2025.
//


import Foundation
import OSLog

public enum Logger {

    fileprivate enum `Type`: String {
        case debug = "🔵🔵🔵"
        case success = "🟢🟢🟢"
        case info = "🟡🟡🟡"
        case error = "🔴🔴🔴"
    }

    // MARK: - Properties
    private static let id: UUID = UUID()
    private static let concurrentListenersQueue = DispatchQueue(label: "\(id).Logger.concurrentListenersQueue",
                                                                qos: .background,
                                                                attributes: .concurrent)

    private static let logQueue = DispatchQueue(label: "\(id).logQueue", qos: .utility)
}

// MARK: - Public methods
public extension Logger {

    static func debug(_ msg: String, logPrefix: String? = nil, function: String? = #function, file: String? = #file, fileId: String = #fileID, line: Int? = #line) {
        log(msg, logPrefix: logPrefix, type: .debug, name: moduleAndClassName(at: file, fileId: fileId), function: function, line: line)
    }

    static func success(_ msg: String, logPrefix: String? = nil, function: String? = #function, file: String? = #file, fileId: String = #fileID, line: Int? = #line) {
        log(msg, logPrefix: logPrefix, type: .success, name: moduleAndClassName(at: file, fileId: fileId), function: function, line: line)
    }

    static func info(_ msg: String, logPrefix: String? = nil, function: String? = #function, file: String? = #file, fileId: String = #fileID, line: Int? = #line) {
        log(msg, logPrefix: logPrefix, type: .info, name: moduleAndClassName(at: file, fileId: fileId), function: function, line: line)
    }

    static func error(_ msg: String, logPrefix: String? = nil, function: String? = #function, file: String? = #file, fileId: String = #fileID, line: Int? = #line) {
        log(msg, logPrefix: logPrefix, type: .error, name: moduleAndClassName(at: file, fileId: fileId), function: function, line: line)
    }

    private static func moduleAndClassName(at path: String?, fileId: String) -> String {
        let moduleName = fileId.firstIndex(of: "/").flatMap { String(fileId[fileId.startIndex ..< $0]) }

        let name = path?.fileName?.components(separatedBy: "/").last

        return (moduleName ?? "module_not found") + "_" + (name ?? "file_name_not_found")
    }
}

// MARK: - Private methods
private extension Logger {

    static func log(_ msg: String, logPrefix: String?, type: Type, name: String, function: String? = nil, line: Int? = nil) {
        concurrentListenersQueue.async(flags: .barrier) {
            let logPrefix: String = logPrefix ?? name
            var message = "\n" + "\(type.rawValue) \(logPrefix) " + "|"

            message += " \(msg) |"

            if let function = function { message += " method: \(function) |" }
            if let line = line { message += " line: \(line) |" }

            switch type {
            case .debug:
                os_log("%{public}@", log: .default, type: .debug, message)
            case .success, .info:
                os_log("%{public}@", log: .default, type: .info, message)
            case .error:
                os_log("%{public}@", log: .default, type: .fault, message)
            }
        }
    }

}
