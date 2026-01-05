//
//  NotificationCoordinator.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

final class NotificationCoordinator {

    static let shared = NotificationCoordinator()
    private init() {}

    func setupAfterLogin() {
        print("🔥 setupAfterLogin called")

        NotificationPermissionManager.requestPermission { granted in
            print("🔥 permission callback:", granted)

            guard granted else { return }
            NotificationScheduler.scheduleNotificationReminder()
        }
    }
}

