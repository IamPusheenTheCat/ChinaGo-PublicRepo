//
//  ContentView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // AI Chat Assistant
            ChatAssistantView()
                .tabItem {
                    Label("Chat Assistant", systemImage: "message.fill")
                }
                .tag(0)
            
            // Multi-function Translator
            TranslatorView()
                .tabItem {
                    Label("Translator", systemImage: "character.bubble.fill")
                }
                .tag(1)
            
            // Text Recognition
            OCRView()
                .tabItem {
                    Label("Text Recognition", systemImage: "text.viewfinder")
                }
                .tag(2)
            
            // Location Search & Navigation Assistant
            NavigationAssistantView()
                .tabItem {
                    Label("Navigation", systemImage: "map.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
