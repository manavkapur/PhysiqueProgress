//
//  NotificationService.swift
//  PhysiqueProgressNotificationService
//
//  Created by Manav Kapur on 05/01/26.
//

import UserNotifications

final class NotificationService: UNNotificationServiceExtension {

    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler:
        @escaping (UNNotificationContent) -> Void
    ) {
        print("🔥 Notification Service Extension fired")
        self.contentHandler = contentHandler
        bestAttemptContent =
            (request.content.mutableCopy() as? UNMutableNotificationContent)

        guard
            let bestAttemptContent,
            let imageUrlString =
                request.content.userInfo["image-url"] as? String ??
                request.content.userInfo["image"] as? String,
            let imageURL = URL(string: imageUrlString)
        else {
            contentHandler(request.content)
            return
        }

        downloadImage(from: imageURL) { attachment in
            if let attachment {
                bestAttemptContent.attachments = [attachment]
            }
            contentHandler(bestAttemptContent)
        }
    }

    override func serviceExtensionTimeWillExpire() {
        if let contentHandler, let bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    private func downloadImage(
        from url: URL,
        completion: @escaping (UNNotificationAttachment?) -> Void
    ) {
        let task = URLSession.shared.downloadTask(with: url) { tempURL, _, _ in
            guard let tempURL else {
                completion(nil)
                return
            }

            let fileManager = FileManager.default
            let ext = url.pathExtension
            let localURL =
                URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension(ext)

            try? fileManager.moveItem(at: tempURL, to: localURL)

            let attachment =
                try? UNNotificationAttachment(
                    identifier: "image",
                    url: localURL
                )

            completion(attachment)
        }
        task.resume()
    }

}
