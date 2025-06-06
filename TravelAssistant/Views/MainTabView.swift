//
//  MainTabView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChatAssistantView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "message.fill" : "message")
                    Text("Chat")
                }
                .tag(0)
            
            TranslatorView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "character.bubble.fill": "character")
                    Text("Translate")
                }
                .tag(1)
            
            OCRView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "camera.viewfinder" : "camera")
                    Text("Scan")
                }
                .tag(2)
            
            NavigationAssistantView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "location.fill" : "location")
                    Text("Navigate")
                }
                .tag(3)
            
            ExploreView()
                .tabItem {
                    Image(systemName: selectedTab == 4 ? "map.fill" : "map")
                    Text("Explore")
                }
                .tag(4)
        }
        .accentColor(.blue)
        .onAppear {
            setupNotificationObservers()
            
            // 确保 TabBar 正确显示
            UITabBar.appearance().isHidden = false
            UITabBar.appearance().backgroundColor = UIColor.systemBackground
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    private func setupNotificationObservers() {
        // Monitor notifications to switch to chat page
        NotificationCenter.default.addObserver(
            forName: Notification.Name("SwitchToChat"),
            object: nil,
            queue: .main
        ) { _ in
            selectedTab = 0 // Switch to first tab (chat page)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(selectedTab: .constant(0))
    }
} 