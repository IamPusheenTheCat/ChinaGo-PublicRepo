//
//  AboutView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Title
                    VStack(spacing: 15) {
                        Image(systemName: "globe.asia.australia.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.blue)
                        
                        Text("ChinaGo")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Travel Assistant for China")
                            .font(.title3)
                            .foregroundColor(.secondary)
                        
                        Text("Version 1.0.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                    }
                    
                    // App Description
                    VStack(alignment: .leading, spacing: 15) {
                        Text("About ChinaGo")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Text("ChinaGo is your comprehensive travel companion designed specifically for exploring China. Whether you're a first-time visitor or a seasoned traveler, our app provides essential tools and local insights to make your China journey smoother and more enriching.")
                                .font(.body)
                                .lineSpacing(4)
                            
                            Text("From intelligent navigation and real-time translation to cultural guides and practical tips, ChinaGo bridges the language and cultural gaps to help you navigate China with confidence.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Key Features
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Key Features")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 15) {
                            AboutFeatureCard(
                                icon: "location.fill",
                                title: "Smart Navigation",
                                description: "GPS navigation with local insights",
                                color: .blue
                            )
                            
                            AboutFeatureCard(
                                icon: "textformat.123",
                                title: "Real-time Translation",
                                description: "Instant text and speech translation",
                                color: .green
                            )
                            
                            AboutFeatureCard(
                                icon: "camera.viewfinder",
                                title: "OCR Recognition",
                                description: "Scan and translate any text instantly",
                                color: .orange
                            )
                            
                            AboutFeatureCard(
                                icon: "brain.head.profile",
                                title: "AI Assistant",
                                description: "Intelligent travel recommendations",
                                color: .purple
                            )
                            
                            AboutFeatureCard(
                                icon: "book.fill",
                                title: "Travel Guides",
                                description: "Comprehensive China travel information",
                                color: .red
                            )
                            
                            AboutFeatureCard(
                                icon: "shield.fill",
                                title: "Privacy First",
                                description: "Your data stays on your device",
                                color: .indigo
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Team Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("About the Team")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Text("ChinaGo is developed by a passionate team of travelers and technology enthusiasts who understand the challenges of international travel in China. Our team combines expertise in mobile development, AI technology, and deep cultural knowledge of China.")
                                .font(.body)
                                .lineSpacing(4)
                            
                            Text("We are committed to continuously improving the app based on user feedback and the evolving needs of travelers. Our goal is to create the most comprehensive and user-friendly travel assistant for China.")
                                .font(.body)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Values Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Our Values")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ValueRow(
                                icon: "heart.fill",
                                title: "User-Centric",
                                description: "Everything we build starts with understanding traveler needs",
                                color: .red
                            )
                            
                            ValueRow(
                                icon: "lock.shield.fill",
                                title: "Privacy Protection",
                                description: "Your personal data and privacy are our top priority",
                                color: .blue
                            )
                            
                            ValueRow(
                                icon: "globe.fill",
                                title: "Cultural Bridge",
                                description: "Fostering understanding between cultures through travel",
                                color: .green
                            )
                            
                            ValueRow(
                                icon: "lightbulb.fill",
                                title: "Innovation",
                                description: "Leveraging cutting-edge AI to solve real travel challenges",
                                color: .yellow
                            )
                            
                            ValueRow(
                                icon: "hands.sparkles.fill",
                                title: "Quality",
                                description: "Delivering reliable, accurate, and helpful services",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Technology Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Technology")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            Text("Built with Modern Technologies")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                TechBadge(name: "SwiftUI", color: .blue)
                                TechBadge(name: "AI/ML", color: .purple)
                                TechBadge(name: "Core Location", color: .green)
                                TechBadge(name: "Speech Recognition", color: .orange)
                                TechBadge(name: "Vision Framework", color: .red)
                                TechBadge(name: "Security", color: .indigo)
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Contact and Support
                    VStack(spacing: 15) {
                        Text("Get in Touch")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            ContactRow(icon: "envelope.fill", title: "Support", value: "help@")
                            ContactRow(icon: "globe", title: "Website", value: "www.chinago-ios.app")
                            ContactRow(icon: "bubble.right.fill", title: "Feedback", value: "feedback@chinago-ios.app")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Copyright
                    VStack(spacing: 8) {
                        Divider()
                        
                        Text("© 2025 ChinaGo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Made with ❤️ for travelers worldwide")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("About ChinaGo")
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
}

struct AboutFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(color)
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(height: 120)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ValueRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct TechBadge: View {
    let name: String
    let color: Color
    
    var body: some View {
        Text(name)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(color)
            .cornerRadius(15)
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AboutView()
} 