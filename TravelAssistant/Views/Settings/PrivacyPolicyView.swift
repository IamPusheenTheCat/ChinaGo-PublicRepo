//
//  PrivacyPolicyView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Privacy Policy")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last Updated: \(getCurrentDate())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("This Privacy Policy describes how ChinaGo (\"we,\" \"our,\" or \"us\") collects, uses, and protects your information when you use our mobile application.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Privacy Policy Content
                    VStack(alignment: .leading, spacing: 25) {
                        
                        PrivacySection(
                            title: "1. Information We Collect",
                            content: """
                            **Location Information**
                            • GPS coordinates for navigation and nearby place recommendations
                            • Location history for route optimization and personalized suggestions
                            • Geographic preferences for travel planning
                            
                            **Device Information**
                            • Device model and operating system version
                            • App version and usage analytics
                            • Camera and microphone access for specific features
                            • Photo library access for image processing
                            
                            **User-Generated Content**
                            • Photos and images uploaded for OCR translation
                            • Voice recordings for speech recognition and translation
                            • Text inputs and chat conversations with AI assistant
                            • Search queries and travel preferences
                            
                            **API and Service Data**
                            • Encrypted API keys stored locally in device Keychain
                            • Translation requests sent to third-party services
                            • OCR processing data sent to Baidu services
                            • AI chat interactions with DeepSeek services
                            """
                        )
                        
                        PrivacySection(
                            title: "2. How We Use Your Information",
                            content: """
                            **Core App Functionality**
                            • Provide navigation services and route planning
                            • Offer real-time translation and OCR text recognition
                            • Enable AI-powered travel assistance and recommendations
                            • Deliver location-based content and services
                            
                            **Service Improvement**
                            • Analyze usage patterns to improve app performance
                            • Enhance translation accuracy and speed
                            • Develop new features based on user needs
                            • Optimize battery usage and app stability
                            
                            **Personalization**
                            • Customize travel recommendations based on your preferences
                            • Remember frequently visited locations
                            • Provide relevant travel guides and tips
                            • Adapt interface language and regional settings
                            """
                        )
                        
                        PrivacySection(
                            title: "3. Data Sharing and Third Parties",
                            content: """
                            **Third-Party Services**
                            • **DeepSeek API**: AI chat and translation services (encrypted communication)
                            • **Baidu OCR**: Text recognition from images (temporary processing only)
                            • **Apple Services**: Maps, location services, and system integrations
                            
                            **We DO NOT**
                            • Sell your personal information to third parties
                            • Share your data with advertisers
                            • Store your conversations or personal content on our servers
                            • Access your data without your explicit permission
                            
                            **Legal Requirements**
                            We may disclose your information only if required by law, court order, or government regulation, or to protect our legal rights and user safety.
                            """
                        )
                        
                        PrivacySection(
                            title: "4. Data Storage and Security",
                            content: """
                            **Local Storage**
                            • Most data is stored locally on your device
                            • API keys are encrypted and stored in iOS Keychain
                            • User preferences and settings remain on your device
                            • Chat history and translations are stored locally
                            
                            **Security Measures**
                            • End-to-end encryption for API communications
                            • Industry-standard security protocols
                            • Regular security updates and patches
                            • No cloud storage of sensitive personal data
                            
                            **Data Retention**
                            • Local data remains until you delete the app
                            • Temporary processing data is deleted immediately after use
                            • You can clear all data through app settings
                            """
                        )
                        
                        PrivacySection(
                            title: "5. Your Rights and Choices",
                            content: """
                            **Access and Control**
                            • Review and delete your local data at any time
                            • Control location sharing through iOS settings
                            • Manage camera and microphone permissions
                            • Export or delete your personal information
                            
                            **Opt-Out Options**
                            • Disable location services (may limit functionality)
                            • Turn off camera/microphone access for specific features
                            • Use app without providing optional information
                            • Delete app and all associated data
                            
                            **Data Portability**
                            • Export your travel history and preferences
                            • Transfer data to other compatible services
                            • Receive a copy of your information upon request
                            """
                        )
                        
                        PrivacySection(
                            title: "6. Children's Privacy",
                            content: """
                            Our app is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information immediately.
                            
                            Parents and guardians who believe their child has provided personal information should contact us immediately.
                            """
                        )
                        
                        PrivacySection(
                            title: "7. International Users",
                            content: """
                            **China Users**
                            • Comply with PRC Cybersecurity Law and data protection regulations
                            • Local data processing for Chinese services
                            • Respect cultural privacy expectations
                            
                            **International Users**
                            • GDPR compliance for EU users
                            • CCPA compliance for California residents
                            • Regional privacy law adherence
                            
                            **Data Transfers**
                            • Minimal cross-border data transfer
                            • Encryption for all international communications
                            • User consent for any data processing outside home country
                            """
                        )
                        
                        PrivacySection(
                            title: "8. Changes to This Policy",
                            content: """
                            We may update this Privacy Policy from time to time. When we make changes:
                            
                            • We will notify you through the app
                            • The updated policy will be posted with a new "Last Updated" date
                            • Significant changes will require your consent
                            • You can review the policy anytime in app settings
                            
                            Continued use of the app after policy changes constitutes acceptance of the updated terms.
                            """
                        )
                        
                        PrivacySection(
                            title: "9. Contact Information",
                            content: """
                            If you have questions, concerns, or requests regarding this Privacy Policy or your personal information, please contact us:
                            
                            **Email**: privacy@chinago-ios.app
                            **Support**: help@chinago-ios.app
                            **Website**: www.chinago-ios.app/privacy
                            
                            **Response Time**: We will respond to your inquiries within 30 days.
                            
                            **Data Protection Officer** (for EU users): dpo@chinago-ios.app
                            """
                        )
                        
                        // Footer
                        VStack(spacing: 15) {
                            Divider()
                            
                            Text("Your privacy is important to us. We are committed to protecting your personal information and being transparent about our data practices.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Text("© 2025 ChinaGo-iOS. All rights reserved.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
}

struct PrivacySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .lineSpacing(4)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    PrivacyPolicyView()
} 