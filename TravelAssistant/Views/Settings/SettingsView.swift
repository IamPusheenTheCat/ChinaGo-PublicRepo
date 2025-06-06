//
//  SettingsView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfService = false
    @State private var showingAbout = false
    @State private var showingAPIKeySetup = false
    
    var body: some View {
        NavigationView {
            List {
                // App Information Section
                Section {
                    HStack {
                        Image(systemName: "globe.asia.australia.fill")
                            .foregroundColor(.blue)
                            .frame(width: 30)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("ChinaGo")
                                .font(.headline)
                            Text("Travel Assistant for China")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("v1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("App Information")
                }
                
                // MARK: - API Configuration Section (Temporarily Disabled)
                // TODO: Re-enable this section when user API input is needed
                /*
                // Account & API Section
                Section {
                    SettingsRow(
                        icon: "key.fill",
                        title: "API Configuration",
                        subtitle: "Configure DeepSeek and Baidu API keys",
                        color: .orange
                    ) {
                        showingAPIKeySetup = true
                    }
                } header: {
                    Text("Account & API")
                }
                */
                
                // Privacy & Legal Section
                Section {
                    SettingsRow(
                        icon: "hand.raised.fill",
                        title: "Privacy Policy",
                        subtitle: "How we protect your data",
                        color: .green
                    ) {
                        showingPrivacyPolicy = true
                    }
                    
                    SettingsRow(
                        icon: "doc.text.fill",
                        title: "Terms of Service",
                        subtitle: "Terms and conditions",
                        color: .blue
                    ) {
                        showingTermsOfService = true
                    }
                } header: {
                    Text("Privacy & Legal")
                }
                
                // Support Section
                Section {
                    SettingsRow(
                        icon: "questionmark.circle.fill",
                        title: "Help & Support",
                        subtitle: "Get help using the app",
                        color: .purple
                    ) {
                        // Open support
                    }
                    
                    SettingsRow(
                        icon: "envelope.fill",
                        title: "Contact Us",
                        subtitle: "help@chinago-ios.app",
                        color: .indigo
                    ) {
                        openEmail()
                    }
                    
                    SettingsRow(
                        icon: "star.fill",
                        title: "Rate the App",
                        subtitle: "Share your feedback",
                        color: .yellow
                    ) {
                        openAppStore()
                    }
                } header: {
                    Text("Support")
                }
                
                // About Section
                Section {
                    SettingsRow(
                        icon: "info.circle.fill",
                        title: "About ChinaGo",
                        subtitle: "Learn more about our mission",
                        color: .gray
                    ) {
                        showingAbout = true
                    }
                } header: {
                    Text("About")
                }
                
                // Footer
                Section {
                    VStack(spacing: 8) {
                        Text("© 2025 ChinaGo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Made with ❤️ for travelers to China")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
        // MARK: - API Key Setup Sheet (Temporarily Disabled)
        // TODO: Re-enable this sheet when user API input is needed
        /*
        .sheet(isPresented: $showingAPIKeySetup) {
            APIKeySetupView()
        }
        */
    }
    
    private func openEmail() {
        if let url = URL(string: "mailto:help@chinago-ios.app") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openAppStore() {
        // TODO: Implement App Store link when app is published
        if let url = URL(string: "https://apps.apple.com/app/chinago") {
            UIApplication.shared.open(url)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
} 