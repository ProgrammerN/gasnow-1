//
//  Analytics.swift
//  Encounters
//
//  Created by Dev Mac on 22/01/19.
//  Copyright © 2019 Psychic Encounters. All rights reserved.
//

import Foundation
import Firebase


/// Private singleton to automatically inject required event parameters
private class AnalyticsHelper {
    static let sharedAnalyticsHelper = AnalyticsHelper()

}

final class FirebaseManager {
    static func initializeFirebase() {
        FirebaseApp.configure()
    }
}

