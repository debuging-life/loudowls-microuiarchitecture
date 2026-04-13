import Foundation
import UserNotifications

// MARK: - Push Notification Manager

public final class OwlsPushNotificationManager: NSObject, @unchecked Sendable {

    public static let shared = OwlsPushNotificationManager()

    private override init() {
        super.init()
    }

    // MARK: - Request Permission

    public func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])

            if granted {
                OwlsLogger.info("Push notifications authorized", module: "Notifications")
            } else {
                OwlsLogger.warning("Push notifications denied", module: "Notifications")
            }

            return granted
        } catch {
            OwlsLogger.error("Push notification request failed", module: "Notifications", error: error)
            return false
        }
    }

    // MARK: - Handle Notification

    public func handleNotification(userInfo: [AnyHashable: Any]) {
        OwlsLogger.info("Push received: \(userInfo)", module: "Notifications")
        OwlsAnalytics.track(OwlsAnalyticsEvent(
            name: "push_notification_received",
            category: .lifecycle,
            properties: ["module": userInfo["module"] as? String ?? "unknown"]
        ))

        // Route through deep link system
        OwlsDeepLinkRouter.shared.route(userInfo: userInfo)
    }

    // MARK: - Register Device Token

    public func didRegisterForRemoteNotifications(deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        OwlsLogger.info("Device token: \(token)", module: "Notifications")

        // TODO: Send token to your backend
        // await api.registerPushToken(token)
    }

    // MARK: - Schedule Local Notification

    public func scheduleLocal(
        title: String,
        body: String,
        delay: TimeInterval = 5,
        data: [String: String] = [:]
    ) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = data

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                OwlsLogger.error("Failed to schedule notification", module: "Notifications", error: error)
            }
        }
    }
}
