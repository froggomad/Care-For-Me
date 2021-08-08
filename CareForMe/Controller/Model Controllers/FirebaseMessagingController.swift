//
//  FirebaseMessagingController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/20/21.
//

import FirebaseMessaging
import UIKit

class FirebaseMessagingController: NSObject {
    enum NotificationPermissionStatus {
        case authorized
        case denied
        case needPermission
    }
    
    static let shared = FirebaseMessagingController()
    var token: String?
    private let dbController = FirebaseDatabaseController()
    
    override private init() {
        super.init()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveToken(_:)),
            name: .tokenKey,
            object: nil)
        
        registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    @objc private func receiveToken(_ notification: Notification) {
        
        guard let tokenDict = notification.userInfo as? [Notification.Name: String],
              let token = tokenDict[.tokenKey] else { return }
        self.token = token
        let apiTokenDict = ["token": token]
        if AuthService.shared.isLoggedIn {
            guard let user = AuthService.shared.user else { return }
            FirebaseDatabaseController().updateValues(for: .userRef(userId: user.userId), with: apiTokenDict)
        }
        
    }
    
    func registerForRemoteNotifications(_ application: UIApplication = UIApplication.shared) {
        application.registerForRemoteNotifications()
    }
    
    func getNotificationSettings(completion: @escaping (NotificationPermissionStatus) -> Void) {
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            DispatchQueue.main.async {
                switch permission.authorizationStatus  {
                case .authorized, .provisional, .ephemeral:
                    completion(.authorized)
                case .denied:
                    completion(.denied)
                case .notDetermined:
                    completion(.needPermission)
                @unknown default:
                    completion(.needPermission)
                }
            }
        })
    }
    
    func requestNotificationPermissions(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] success, error in
                if success {
                    self?.retrieveMessagingToken()
                    completion(.success(success))
                } else if let error = error {
                    completion(.failure(error))
                } else {
                    let error = NSError(domain: #function, code: 0)
                    completion(.failure(error))
                }
            }
        )
        
    }
    
    /// use this to retrieve a messaging token directly and send a notification (fallback)
    func retrieveMessagingToken() {
        
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                let dataDict:[Notification.Name: String] = [.tokenKey: token]
                NotificationCenter.default.post(name: .tokenKey, object: nil, userInfo: dataDict)
            }
        }
        
    }
    
    enum NotificationType {
        case read
        case unread
    }
    
    func postMessage(type: NotificationType, notification: CareNotification) {
        switch type {
        case .read:
            let readNotificationRef = APIRef.postReadNotification(userId: notification.forUserId, notificationId: notification.id.uuidString)
            
            dbController.setValue(for: readNotificationRef, with: notification)
        case .unread:
            let unreadNotificationRef = APIRef.postUnreadNotification(userId: notification.forUserId, notificationId: notification.id.uuidString)
            
            dbController.setValue(for: unreadNotificationRef, with: notification)
            
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension Notification.Name {
    static let tokenKey = Notification.Name("FCMToken")
}

extension FirebaseMessagingController: UNUserNotificationCenterDelegate {
    
    // MARK: - Firebase Messaging -
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if userInfo.isEmpty {
            completionHandler(.noData)
        } else {
            completionHandler(.newData)
        }
        
    }
    
    // MARK: - APNS -
    // set FirebaseMessaging service with apnsToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    /// handle notifications being presented in app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let careNotification = parseUNNotification(notification: notification)
        NotificationCenter.default.post(name: .newUnreadNotification, object: nil, userInfo: ["careNotification": careNotification])
        
        if #available(iOS 14, *) {
            completionHandler([[.banner, .sound, .badge]])
        } else {
            completionHandler([[.alert, .sound, .badge]])
        }
    }
    
    /// handle user tapping on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        TabBar.activate(.notifications)
        completionHandler()
    }
    
    private func parseUNNotification(notification: UNNotification) -> CareNotification {
        let userInfo = notification.request.content.userInfo
        let message = notification.request.content.body
        
        let id = userInfo["id"] as? String ?? ""
        let title = userInfo["title"] as? String ?? ""
        let date = userInfo["date"] as? Date ?? notification.date
        let category = userInfo["category"] as? String ?? ""
        let userId = userInfo["forUserId"] as? String ?? ""

        let notification = CareNotification(id: UUID(uuidString: id) ?? UUID(),
                                            category: category,
                                            title: title,
                                            text: message,
                                            forUserId: userId,
                                            date: date)
        return notification
    }
}

extension FirebaseMessagingController: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        let dataDict:[NSNotification.Name: String] = [.tokenKey: fcmToken]
        NotificationCenter.default.post(name: .tokenKey, object: nil, userInfo: dataDict)
    }
    
}
