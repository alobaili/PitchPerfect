//
//  PitchPerfectApp.swift
//  PitchPerfect
//
//  Created by Abdulaziz AlObaili on 04/09/2021.
//  Copyright © 2021 Udacity. All rights reserved.
//

import SwiftUI

@main
struct PitchPerfectApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                RecordSoundsView()
            }
        }
    }
}
