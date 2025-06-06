//
//  TravelAssistantApp.swift
//  TravelAssistant
//
//  Created by Assistant on 6/5/25.
//

import SwiftUI

@main
struct TravelAssistantApp: App {
    @State private var selectedTab = 0
    @State private var showWelcome = true
    
    var body: some Scene {
        WindowGroup {
            if showWelcome {
                WelcomeView(showWelcome: $showWelcome, selectedTab: $selectedTab)
            } else {
                MainTabView(selectedTab: $selectedTab)
            }
        }
    }
} 