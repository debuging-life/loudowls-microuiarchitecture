import SwiftUI
import MicroUICore

@main
struct MicruiachitectureApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        MicroUIBootstrap.register()
        OwlsImageCache.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .owlsErrorAlert()
                .onOpenURL { url in
                    OwlsDeepLinkRouter.shared.route(url: url)
                }
            #if DEBUG
                .overlay(alignment: .bottomTrailing) {
                    OwlsDebugButton()
                }
            #endif
        }
    }
}

// MARK: - App Delegate (Push Notifications)

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Task { await OwlsPushNotificationManager.shared.requestPermission() }
        application.registerForRemoteNotifications()
        return true
    }

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        OwlsPushNotificationManager.shared.didRegisterForRemoteNotifications(deviceToken: deviceToken)
    }

    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        OwlsPushNotificationManager.shared.handleNotification(userInfo: userInfo)
        return .newData
    }
}
