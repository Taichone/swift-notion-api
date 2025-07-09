//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

typealias Environment = NotionSwiftEnvironment

public struct NotionSwiftEnvironment: Sendable {
    private static let lock = NSLock()
    private static var _log = Logger(handler: EmptyLogHandler(), level: .info)
    
    static var log: Logger {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _log
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _log = newValue
        }
    }
    
    public static var logHandler: LoggerHandler {
        get { 
            lock.lock()
            defer { lock.unlock() }
            return _log.handler 
        }
        set { 
            lock.lock()
            defer { lock.unlock() }
            _log.handler = newValue 
        }
    }

    public static var logLevel: LogLevel {
        get { 
            lock.lock()
            defer { lock.unlock() }
            return _log.level 
        }
        set { 
            lock.lock()
            defer { lock.unlock() }
            _log.level = newValue 
        }
    }
}
