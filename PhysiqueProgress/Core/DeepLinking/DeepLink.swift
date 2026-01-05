//
//  DeepLink.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import Foundation

struct DeepLink {

    let route: DeepLinkRoute

    init(url: URL) {
        let path = url.path.lowercased()

        switch path {
        case "/progress":
            route = .progress
        case "/premium":
            route = .premium
        case "/history":
            route = .history
        default:
            route = .unknown
        }
    }

    // Custom scheme support
    init?(schemeURL: URL) {
        guard schemeURL.scheme == "physiqueprogress" else {
            return nil
        }

        let host = schemeURL.host?.lowercased() ?? ""

        switch host {
        case "progress":
            route = .progress
        case "premium":
            route = .premium
        case "history":
            route = .history
        default:
            route = .unknown
        }
    }
}

