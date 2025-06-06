//
//  WelcomeView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @Binding var selectedTab: Int
    @State private var animateContent = false
    @State private var animateFeatures = false
    @State private var currentImageIndex = 0
    
    // Travel theme background patterns
    let backgroundPatterns = ["airplane", "location", "map", "globe.asia.australia", "building.2"]
    
    var body: some View {
        ZStack {
            // 新的图片背景
            Image("WelcomeBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea(.all)
            
            // 独立的半透明遮罩层，确保完全覆盖屏幕
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.6),
                    Color.black.opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            // Top semicircle decoration
            VStack {
                ZStack {
                    // Semicircle shape
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.2), .white.opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300, height: 300)
                        .clipped()
                        .offset(y: -150) // Offset upward by half to show only bottom part
                        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                }
                .clipped()
                Spacer()
            }
            .ignoresSafeArea(.all)
            
            // Dynamic decorative icons
            ForEach(0..<8, id: \.self) { index in
                Image(systemName: backgroundPatterns[index % backgroundPatterns.count])
                    .font(.system(size: CGFloat(20 + index * 5)))
                    .foregroundColor(.white.opacity(0.1))
                    .position(
                        x: CGFloat.random(in: 50...300),
                        y: CGFloat.random(in: 200...700)
                    )
                    .scaleEffect(animateContent ? 1.0 : 0.5)
                    .opacity(animateContent ? 0.15 : 0.0)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .delay(Double(index) * 0.2),
                        value: animateContent
                    )
            }
            
            // Main content with proper safe area handling
            VStack(spacing: 0) {
                // Top title area
                VStack(spacing: 20) {
                    // App icon and title
                    VStack(spacing: 15) {
                        // Main title
                        VStack(spacing: 8) {
                            Text("Welcome to China")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 30)
                            
                            Text("Your Smart China Travel Companion")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 30)
                            
                            Text("Explore China with Confidence")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))
                                .opacity(animateContent ? 1 : 0)
                                .offset(y: animateContent ? 0 : 30)
                        }
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 60)
                
                Spacer()
                    .frame(height: 40)
                
                // Feature showcase
                VStack(spacing: 20) {
                    ForEach(Array(getFeatures().enumerated()), id: \.offset) { index, feature in
                        FeatureCard(
                            icon: feature.icon,
                            title: feature.title,
                            subtitle: feature.subtitle,
                            color: feature.color
                        ) {
                            // Handle feature card tap
                            navigateToFeature(feature.title)
                        }
                        .opacity(animateFeatures ? 1 : 0)
                        .offset(x: animateFeatures ? 0 : -100)
                        .animation(
                            .spring(response: 0.8, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1 + 0.5),
                            value: animateFeatures
                        )
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                    .frame(height: 20)
                
                // Start button
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        showWelcome = false
                    }
                }) {
                    HStack(spacing: 15) {
                        Image(systemName: "airplane.departure")
                            .font(.title3)
                        
                        Text("Explore All Features")
                            .fontWeight(.semibold)
                            .font(.headline)
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.black.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 30)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.orange.opacity(0.8),
                                            Color.red.opacity(0.8)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 40)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 50)
                .scaleEffect(animateContent ? 1 : 0.9)
            }
            .safeAreaInset(edge: .top) { Color.clear.frame(height: 0) }
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.5).delay(0.3)) {
                animateContent = true
            }
            
            withAnimation(.easeOut(duration: 1.0).delay(0.8)) {
                animateFeatures = true
            }
        }
    }
    
    // Get feature data
    private func getFeatures() -> [FeatureData] {
        return [
            FeatureData(
                icon: "brain.head.profile",
                title: "Chat Assistant",
                subtitle: "Get instant travel help",
                color: .blue
            ),
            FeatureData(
                icon: "translate",
                title: "Live Translator",
                subtitle: "Break language barriers",
                color: .green
            ),
            FeatureData(
                icon: "camera.viewfinder",
                title: "Camera Translator",
                subtitle: "Scan & translate instantly",
                color: .orange
            ),
            FeatureData(
                icon: "location.north.circle",
                title: "Smart Navigation",
                subtitle: "Find your way around",
                color: .red
            ),
            FeatureData(
                icon: "book.pages",
                title: "Travel Tips",
                subtitle: "Discover local insights",
                color: .purple
            )
        ]
    }
    
    // Navigate to corresponding feature page
    private func navigateToFeature(_ featureTitle: String) {
        withAnimation(.easeInOut(duration: 0.5)) {
            switch featureTitle {
            case "Chat Assistant":
                selectedTab = 0 // ChatAssistantView
            case "Live Translator":
                selectedTab = 1 // TranslatorView
            case "Camera Translator":
                selectedTab = 2 // OCRView
            case "Smart Navigation":
                selectedTab = 3 // NavigationAssistantView
            case "Travel Tips":
                selectedTab = 4 // ExploreView
            default:
                selectedTab = 0
            }
            
            // Close welcome page and navigate to selected page
            showWelcome = false
        }
    }
}

// Feature data model
struct FeatureData {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
}

// Feature card component
struct FeatureCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon container
                ZStack {
                    Circle()
                        .fill(color.opacity(0.3))
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .blur(radius: 8)
                    
                    Circle()
                        .stroke(color.opacity(0.6), lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: color, radius: 4, x: 0, y: 0)
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Indicator arrow
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.15))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                // Add tap feedback animation
            }
            action()
        }
    }
}

// Keep original FeatureRow component in case it's used elsewhere
struct FeatureRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 50, height: 50)
                
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView(showWelcome: .constant(true), selectedTab: .constant(0))
    }
}
