//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

public enum LogLevel: String, CaseIterable, Sendable {
    case trace
    case debug
    case info
    case notice
    case warning
    case error
}

extension LogLevel {
    internal var naturalIntegralValue: Int {
        switch self {
        case .trace:
            return 0
        case .debug:
            return 1
        case .info:
            return 2
        case .notice:
            return 3
        case .warning:
            return 4
        case .error:
            return 5
        }
    }
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.naturalIntegralValue < rhs.naturalIntegralValue
    }
}

public protocol LoggerHandler: AnyObject, Sendable {
    func log(level: LogLevel, message: String)
}

public final class Logger: @unchecked Sendable {
    var handler: LoggerHandler
    var level: LogLevel

    init(handler: LoggerHandler, level: LogLevel) {
        self.handler = handler
        self.level = level
    }

    public func trace(_ message: @autoclosure () -> String) {
        log(level: .trace, message())
    }

    public func debug(_ message: @autoclosure () -> String) {
        log(level: .debug, message())
    }

    public func info(_ message: @autoclosure () -> String) {
        log(level: .info, message())
    }

    public func notice(_ message: @autoclosure () -> String) {
        log(level: .notice, message())
    }

    public func warning(_ message: @autoclosure () -> String) {
        log(level: .warning, message())
    }

    public func error(_ message: @autoclosure () -> String) {
        log(level: .error, message())
    }

    func log(
        level: LogLevel,
        _ message: @autoclosure () -> String
    ) {
        if self.level <= level {
            self.handler.log(level: level, message: message())
        }
    }
}

public final class EmptyLogHandler: LoggerHandler, @unchecked Sendable {
    public init() {}
    
    public func log(level: LogLevel, message: String) {}
}

public final class PrintLogHandler: LoggerHandler, @unchecked Sendable {
    public init() {}

    public func log(level: LogLevel, message: String) {
        print("NotionSwift \(level.rawValue.uppercased()): \(message)")
    }
}
