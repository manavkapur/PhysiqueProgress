import UserNotifications
import FirebaseAnalytics

final class NotificationScheduler {

    static func scheduleNotificationReminder() {

        Analytics.logEvent("daily_reminder_scheduled", parameters: nil)

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: ["daily_progress_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Track your progress 💪"
        content.body = "Take today's physique photo and stay consistent."
        content.sound = .default

        var date = DateComponents()
        date.hour = 9

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        let request = UNNotificationRequest(
            identifier: "daily_progress_reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
}
