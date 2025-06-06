//
//  TermsOfServiceView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Terms of Service")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Last Updated: \(getCurrentDate())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("These Terms of Service (\"Terms\") govern your use of the ChinaGo mobile application. By downloading, installing, or using our app, you agree to be bound by these Terms.")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    // Terms Content
                    VStack(alignment: .leading, spacing: 25) {
                        
                        TermsSection(
                            title: "1. Acceptance of Terms",
                            content: """
                            By accessing and using ChinaGo, you acknowledge that you have read, understood, and agree to be bound by these Terms and our Privacy Policy. If you do not agree to these Terms, you must not use our application.
                            
                            These Terms constitute a legally binding agreement between you and ChinaGo. Your continued use of the app constitutes your ongoing acceptance of these Terms and any modifications we may make.
                            """
                        )
                        
                        TermsSection(
                            title: "2. Description of Service",
                            content: """
                            ChinaGo is a travel assistant application designed specifically for travelers to China. Our services include:
                            
                            • **Navigation Services**: GPS-based navigation and route planning
                            • **Translation Services**: Real-time text and speech translation
                            • **OCR Services**: Text recognition from images
                            • **AI Assistant**: Intelligent travel recommendations and assistance
                            • **Travel Guides**: Comprehensive information about China travel
                            • **Local Information**: Cultural, dining, and transportation guidance
                            
                            Our services are provided "as is" and we reserve the right to modify, suspend, or discontinue any part of our services at any time.
                            """
                        )
                        
                        TermsSection(
                            title: "3. User Responsibilities",
                            content: """
                            **Acceptable Use**
                            • Use the app only for lawful purposes and in accordance with these Terms
                            • Respect local laws and customs when traveling in China
                            • Provide accurate information when using our services
                            • Do not attempt to reverse engineer, hack, or compromise the app
                            
                            **Prohibited Activities**
                            • Using the app for illegal activities or purposes
                            • Attempting to gain unauthorized access to our systems
                            • Interfering with other users' enjoyment of the app
                            • Uploading harmful, offensive, or inappropriate content
                            • Violating any applicable laws or regulations
                            
                            **Content Responsibility**
                            You are solely responsible for any content you submit, upload, or share through our app. This includes photos, text, voice recordings, and any other user-generated content.
                            """
                        )
                        
                        TermsSection(
                            title: "4. Intellectual Property Rights",
                            content: """
                            **Our Rights**
                            • All content, features, and functionality of ChinaGo are owned by us
                            • Our trademarks, logos, and service marks are our exclusive property
                            • The app's software, design, and architecture are protected by copyright
                            • Travel guides and informational content are proprietary to ChinaGo
                            
                            **User License**
                            We grant you a limited, non-exclusive, non-transferable license to use the app for personal, non-commercial purposes. This license does not include the right to:
                            • Resell or redistribute the app or its content
                            • Create derivative works based on our app
                            • Use our content for commercial purposes without permission
                            
                            **User Content**
                            You retain ownership of content you create, but grant us a license to use it for providing our services.
                            """
                        )
                        
                        TermsSection(
                            title: "5. Privacy and Data Protection",
                            content: """
                            Your privacy is important to us. Please review our Privacy Policy, which also governs your use of our services, to understand our practices.
                            
                            **Data Collection**
                            • We collect only necessary data to provide our services
                            • Most data is stored locally on your device
                            • We use industry-standard security measures to protect your data
                            
                            **Third-Party Services**
                            • We use DeepSeek API for AI services
                            • We use Baidu OCR for text recognition
                            • These services have their own privacy policies and terms
                            
                            **Data Control**
                            You have the right to access, modify, or delete your personal data at any time through the app settings.
                            """
                        )
                        
                        TermsSection(
                            title: "6. Payment and Subscription Terms",
                            content: """
                            **Pricing**
                            • Current version may be offered free or with premium features
                            • Prices for premium features will be clearly displayed
                            • All prices are subject to change with 30 days notice
                            
                            **Billing**
                            • Payments are processed through Apple App Store
                            • Subscriptions automatically renew unless cancelled
                            • Refunds are subject to Apple's refund policy
                            
                            **Free Trial**
                            • Free trials may be offered for premium features
                            • You can cancel anytime during the trial period
                            • Automatic billing begins after trial period ends
                            
                            **Cancellation**
                            • You can cancel subscriptions through your Apple ID settings
                            • Cancellation takes effect at the end of the current billing period
                            • No refunds for partial periods unless required by law
                            """
                        )
                        
                        TermsSection(
                            title: "7. Disclaimers and Limitations",
                            content: """
                            **Service Disclaimers**
                            • Services provided "as is" without warranties of any kind
                            • We do not guarantee accuracy of translation or navigation services
                            • Third-party API services may experience downtime or errors
                            • Travel information is for guidance only and may become outdated
                            
                            **Limitation of Liability**
                            To the maximum extent permitted by law:
                            • We are not liable for any indirect, incidental, or consequential damages
                            • Our total liability shall not exceed the amount you paid for the app
                            • We are not responsible for decisions made based on app information
                            • You use the app at your own risk
                            
                            **Travel Disclaimers**
                            • Always verify travel information with official sources
                            • We are not responsible for travel delays, cancellations, or issues
                            • Local laws and regulations may change without notice
                            • Emergency services should be contacted directly, not through our app
                            """
                        )
                        
                        TermsSection(
                            title: "8. Indemnification",
                            content: """
                            You agree to indemnify, defend, and hold harmless ChinaGo and its officers, directors, employees, and agents from and against any claims, damages, obligations, losses, liabilities, costs, or debt arising from:
                            
                            • Your use of the app
                            • Your violation of these Terms
                            • Your violation of any third-party rights
                            • Any content you submit or share through the app
                            • Your travel activities or decisions based on app information
                            """
                        )
                        
                        TermsSection(
                            title: "9. Modifications and Termination",
                            content: """
                            **Modifications to Terms**
                            • We may update these Terms at any time
                            • Changes will be posted in the app with updated date
                            • Continued use constitutes acceptance of modified Terms
                            • Significant changes will require your explicit consent
                            
                            **Service Modifications**
                            • We reserve the right to modify or discontinue services
                            • Features may be added, changed, or removed at our discretion
                            • We will provide reasonable notice for major changes
                            
                            **Termination**
                            • You may terminate your account at any time by deleting the app
                            • We may terminate or suspend access for violations of these Terms
                            • Termination does not relieve you of obligations incurred before termination
                            """
                        )
                        
                        TermsSection(
                            title: "10. Governing Law and Disputes",
                            content: """
                            **Governing Law**
                            These Terms are governed by the laws of [Your Jurisdiction], without regard to its conflict of law principles.
                            
                            **Dispute Resolution**
                            • Initial disputes should be addressed through our customer support
                            • Unresolved disputes may be subject to binding arbitration
                            • You may have the right to opt out of arbitration within 30 days
                            
                            **Class Action Waiver**
                            You agree to resolve disputes individually and waive the right to participate in class action lawsuits, except where prohibited by law.
                            
                            **Jurisdiction**
                            Any legal proceedings shall be conducted in the courts of [Your Jurisdiction].
                            """
                        )
                        
                        TermsSection(
                            title: "11. Contact Information",
                            content: """
                            For questions about these Terms of Service, please contact us:
                            
                            **Email**: legal@chinago-ios.app
                            **Support**: help@chinago-ios.app
                            **Address**: [Your Business Address]
                            
                            **Business Hours**: Monday - Friday, 9:00 AM - 6:00 PM
                            **Response Time**: We will respond to inquiries within 48 hours
                            """
                        )
                        
                        // Footer
                        VStack(spacing: 15) {
                            Divider()
                            
                            Text("By using ChinaGo, you acknowledge that you have read and understood these Terms of Service and agree to be bound by them.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Text("© 2025 ChinaGo. All rights reserved.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Terms of Service")
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

struct TermsSection: View {
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
    TermsOfServiceView()
} 