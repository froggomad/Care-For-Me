//
//  FirebaseMessagingController.swift
//  CareForMe
//
//  Created by Kenneth Dubroff on 6/20/21.
//

import FirebaseMessaging
import UIKit

class FirebaseMessagingController {
    static let shared = FirebaseMessagingController()
    var token: String?
    private let dbController = FirebaseDatabaseController()
    
    private init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveToken(_:)),
            name: .tokenKey,
            object: nil)
        
        registerForRemoteNotifications(UIApplication.shared)
        requestNotificationPermissions { _ in }
        Messaging.messaging().delegate = UIApplication.shared.delegate as? MessagingDelegate
        UNUserNotificationCenter.current().delegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    @objc private func receiveToken(_ notification: Notification) {
        
        guard let tokenDict = notification.userInfo as? [Notification.Name: String],
              let token = tokenDict[.tokenKey] else { return }
        self.token = token
        let apiTokenDict = ["token": token]
        // TODO: UserId
        FirebaseDatabaseController().setValue(for: APIRef.userRef(userId: "userId"), with: apiTokenDict)
        
    }
    
    private func registerForRemoteNotifications(_ application: UIApplication) {
        application.registerForRemoteNotifications()
    }
    
    private func requestNotificationPermissions(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { success, error in
                if success {
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
        
        Messaging.messaging().token { [weak self] token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                let dataDict:[Notification.Name: String] = [.tokenKey: token]
                NotificationCenter.default.post(name: .tokenKey, object: nil, userInfo: dataDict)
                // TODO: UserId
                self?.dbController.setValue(for: APIRef.userRef(userId: "userId"), with: token)
            }
        }
        
    }
    
    func postMessage(title: String, text: String, toUserId: String) {
        let userRef = APIRef.userNotifications(userId: toUserId)
        let id = UUID()
        let endpoint = userRef + "\(id)"
        dbController.setValue(for: endpoint, with: CareNotification(id: id, title: title, message: text, forUserId: toUserId))
    }
    
}

extension Notification.Name {
    static let tokenKey = Notification.Name("FCMToken")
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // MARK: - Firebase Messaging -
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if userInfo.isEmpty {
            completionHandler(.noData)
        } else {
            completionHandler(.newData)
        }
        
    }
    
    // MARK: - APNS -
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        let dataDict:[NSNotification.Name: String] = [.tokenKey: fcmToken]
        NotificationCenter.default.post(name: .tokenKey, object: nil, userInfo: dataDict)
    }
    
}
