import Foundation
import os

// MARK: - Log Level

public enum OwlsLogLevel: Int, Sendable, Comparable {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case critical = 4

    public static func < (lhs: OwlsLogLevel, rhs: OwlsLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var emoji: String {
        switch self {
        case .debug: "🔍"
        case .info: "ℹ️"
        case .warning: "⚠️"
        case .error: "❌"
        case .critical: "🔥"
        }
    }

    var osLogType: OSLogType {
        switch self {
        case .debug: .debug
        case .info: .info
        case .warning: .default
        case .error: .error
        case .critical: .fault
        }
    }
}

// MARK: - Logger

public final class OwlsLogger: Sendable {

    public static let shared = OwlsLogger()

    private let osLog = Logger(subsystem: Bundle.main.bundleIdentifier ?? "OwlsApp", category: "MicroUI")
    private let minimumLevel: OwlsLogLevel

    private init(minimumLevel: OwlsLogLevel = .debug) {
        self.minimumLevel = minimumLevel
    }

    // MARK: - Log Methods

    public static func debug(_ message: String, module: String = "", file: String = #file, line: Int = #line) {
        shared.log(.debug, message: message, module: module, file: file, line: line)
    }

    public static func info(_ message: String, module: String = "", file: String = #file, line: Int = #line) {
        shared.log(.info, message: message, module: module, file: file, line: line)
    }

    public static func warning(_ message: String, module: String = "", file: String = #file, line: Int = #line) {
        shared.log(.warning, message: message, module: module, file: file, line: line)
    }

    public static func error(_ message: String, module: String = "", error: Error? = nil, file: String = #file, line: Int = #line) {
        var msg = message
        if let error { msg += " | \(error.localizedDescription)" }
        shared.log(.error, message: msg, module: module, file: file, line: line)
    }

    public static func critical(_ message: String, module: String = "", file: String = #file, line: Int = #line) {
        shared.log(.critical, message: message, module: module, file: file, line: line)
    }

    // MARK: - Core

    private func log(_ level: OwlsLogLevel, message: String, module: String, file: String, line: Int) {
        guard level >= minimumLevel else { return }

        let fileName = (file as NSString).lastPathComponent
        let moduleTag = module.isEmpty ? "" : "[\(module)] "

        #if DEBUG
        print("\(level.emoji) \(moduleTag)\(message) (\(fileName):\(line))")
        #endif

        osLog.log(level: level.osLogType, "\(moduleTag)\(message)")

        // Track errors in analytics
        if level >= .error {
            OwlsAnalytics.track(.errorOccurred(message, module: module, screen: fileName))
        }
    }
}
