//
//  QRCodePaymentArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct QRCodePaymentArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedComparison = 0
    @State private var selectedScenario = 0
    
    let comparisonTypes = [
        "Alipay vs WeChat Pay",
        "QR vs Traditional Cards", 
        "Active vs Passive Scan",
        "Mobile vs Cash Payment"
    ]
    
    let scenarios = [
        "Coffee Shop",
        "Supermarket",
        "Street Vendor",
        "Tourist Attraction"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Comparative Analysis Hero
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.indigo, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 200)
                        
                        VStack(spacing: 15) {
                            Text("⚖️")
                                .font(.system(size: 60))
                            
                            Text("QR Payment Comparison")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Data-driven analysis to help you choose the best payment method")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Market Share & Statistics
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("📊")
                                    .font(.title2)
                                Text("Market Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                statisticCard(
                                    platform: "Alipay",
                                    marketShare: "54%",
                                    users: "1.3B",
                                    strength: "E-commerce",
                                    color: .blue
                                )
                                
                                statisticCard(
                                    platform: "WeChat Pay", 
                                    marketShare: "39%",
                                    users: "1.2B",
                                    strength: "Social",
                                    color: .green
                                )
                                
                                statisticCard(
                                    platform: "Bank Cards",
                                    marketShare: "5%",
                                    users: "700M",
                                    strength: "Traditional",
                                    color: .orange
                                )
                                
                                statisticCard(
                                    platform: "Cash",
                                    marketShare: "2%",
                                    users: "Universal",
                                    strength: "Backup",
                                    color: .gray
                                )
                            }
                        }
                        
                        // Interactive Comparison Selector
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🔍")
                                    .font(.title2)
                                Text("Detailed Comparison")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Comparison Type", selection: $selectedComparison) {
                                ForEach(0..<comparisonTypes.count, id: \.self) { index in
                                    Text(comparisonTypes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            comparisonContent(for: selectedComparison)
                        }
                        
                        // Scenario-Based Recommendations
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("Best Choice by Scenario")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Scenario", selection: $selectedScenario) {
                                ForEach(0..<scenarios.count, id: \.self) { index in
                                    Text(scenarios[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            scenarioRecommendation(for: selectedScenario)
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Speed & Efficiency Analysis
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("⚡")
                                    .font(.title2)
                                Text("Speed & Efficiency Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                speedComparisonBar(
                                    method: "QR Scan (Experienced)",
                                    time: "3-5 seconds",
                                    efficiency: 0.95,
                                    color: .green
                                )
                                
                                speedComparisonBar(
                                    method: "Show QR Code",
                                    time: "5-8 seconds", 
                                    efficiency: 0.85,
                                    color: .blue
                                )
                                
                                speedComparisonBar(
                                    method: "Contactless Card",
                                    time: "8-12 seconds",
                                    efficiency: 0.70,
                                    color: .orange
                                )
                                
                                speedComparisonBar(
                                    method: "Cash Payment",
                                    time: "20-30 seconds",
                                    efficiency: 0.40,
                                    color: .red
                                )
                                
                                speedComparisonBar(
                                    method: "QR Scan (Beginner)",
                                    time: "15-25 seconds",
                                    efficiency: 0.50,
                                    color: .gray
                                )
                            }
                        }
                        
                        // Security Comparison Matrix
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🛡️")
                                    .font(.title2)
                                Text("Security Comparison")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 0) {
                                securityHeaderRow()
                                securityComparisonRow(
                                    method: "QR Payment",
                                    encryption: "High",
                                    authentication: "Biometric/PIN",
                                    fraud: "Low",
                                    privacy: "Medium",
                                    overall: .green
                                )
                                securityComparisonRow(
                                    method: "Contactless Card",
                                    encryption: "High",
                                    authentication: "PIN/Signature",
                                    fraud: "Medium",
                                    privacy: "High",
                                    overall: .blue
                                )
                                securityComparisonRow(
                                    method: "Cash",
                                    encryption: "N/A",
                                    authentication: "None",
                                    fraud: "High",
                                    privacy: "High",
                                    overall: .orange
                                )
                            }
                            .background(Color(.systemGray6).opacity(0.3))
                            .cornerRadius(10)
                        }
                        
                        // Cost Analysis
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💰")
                                    .font(.title2)
                                Text("Cost Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                costComparisonCard(
                                    method: "QR Payments",
                                    userCost: "Free",
                                    merchantCost: "0.1-0.6%",
                                    setupCost: "Free",
                                    hiddenCosts: ["Data usage", "Phone battery"],
                                    color: .green
                                )
                                
                                costComparisonCard(
                                    method: "Credit Cards",
                                    userCost: "Annual fee",
                                    merchantCost: "1.5-3%",
                                    setupCost: "POS terminal",
                                    hiddenCosts: ["Processing delays", "Chargeback fees"],
                                    color: .orange
                                )
                                
                                costComparisonCard(
                                    method: "Cash",
                                    userCost: "Free",
                                    merchantCost: "Free",
                                    setupCost: "Free",
                                    hiddenCosts: ["Counting time", "Security risks", "Change management"],
                                    color: .blue
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Adoption Trends
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("📈")
                                    .font(.title2)
                                Text("Adoption Trends")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                trendCard(
                                    demographic: "Generation Z (18-25)",
                                    preference: "QR Payments",
                                    adoption: "96%",
                                    reason: "Digital native, speed-focused",
                                    color: .purple
                                )
                                
                                trendCard(
                                    demographic: "Millennials (26-40)",
                                    preference: "Mixed (QR + Cards)",
                                    adoption: "87%", 
                                    reason: "Convenience + security balance",
                                    color: .blue
                                )
                                
                                trendCard(
                                    demographic: "Gen X (41-55)",
                                    preference: "Cards + some QR",
                                    adoption: "65%",
                                    reason: "Learning but cautious",
                                    color: .orange
                                )
                                
                                trendCard(
                                    demographic: "Baby Boomers (55+)",
                                    preference: "Cash + Cards",
                                    adoption: "34%",
                                    reason: "Trust traditional methods",
                                    color: .gray
                                )
                            }
                        }
                        
                        // Final Recommendation Matrix
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("Your Best Choice")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                recommendationCard(
                                    userType: "Tech-Savvy Tourist",
                                    primary: "Alipay QR",
                                    backup: "WeChat Pay",
                                    reasoning: "Best features, wide acceptance, tourist-friendly",
                                    confidence: "95%"
                                )
                                
                                recommendationCard(
                                    userType: "Conservative Spender",
                                    primary: "International Credit Card",
                                    backup: "Cash",
                                    reasoning: "Familiar, secure, universal acceptance",
                                    confidence: "80%"
                                )
                                
                                recommendationCard(
                                    userType: "Social Traveler",
                                    primary: "WeChat Pay",
                                    backup: "Alipay",
                                    reasoning: "Social features, group payments, red packets",
                                    confidence: "85%"
                                )
                                
                                recommendationCard(
                                    userType: "Business Traveler",
                                    primary: "Corporate Card + QR",
                                    backup: "Multiple methods",
                                    reasoning: "Expense tracking, flexibility, reliability",
                                    confidence: "90%"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.indigo.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Bottom Line Summary
                        VStack(spacing: 15) {
                            HStack {
                                Text("📋")
                                    .font(.title2)
                                Text("Executive Summary")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Based on our analysis:")
                                    .font(.headline)
                                    .fontWeight(.medium)
                                
                                Text("🥇 QR payments are fastest and most convenient for daily use")
                                Text("🥈 Credit cards provide better security and fraud protection")
                                Text("🥉 Cash remains important as a backup option")
                                Text("💡 Best strategy: Use multiple methods based on situation")
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Payment Analysis")
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
    
    // Comparison Content Views
    @ViewBuilder
    private func comparisonContent(for index: Int) -> some View {
        switch index {
        case 0: // Alipay vs WeChat Pay
            alipayVsWeChatComparison()
        case 1: // QR vs Traditional Cards
            qrVsCardsComparison()
        case 2: // Active vs Passive Scan
            activePvPassiveComparison()
        case 3: // Mobile vs Cash
            mobileVsCashComparison()
        default:
            EmptyView()
        }
    }
    
    // Helper Views
    private func statisticCard(platform: String, marketShare: String, users: String, strength: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(platform)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                HStack {
                    Text("Market Share:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(marketShare)
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Users:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(users)
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Strength:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(strength)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(color)
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .frame(height: 120)
    }
    
    private func alipayVsWeChatComparison() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("💙 Alipay")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Strengths:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Better for foreigners")
                    Text("• More financial services")
                    Text("• Wider merchant acceptance")
                    Text("• Better English support")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Weaknesses:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• No social features")
                    Text("• Less popular with young users")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("💚 WeChat Pay")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Strengths:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Social integration")
                    Text("• Red packet feature")
                    Text("• Better for small vendors")
                    Text("• Group payment features")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Weaknesses:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• Harder for foreigners")
                    Text("• Requires Chinese phone")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Verdict:")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Use both for different purposes")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func qrVsCardsComparison() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📱 QR Payments")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    
                    Text("Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Faster transactions")
                    Text("• No physical card needed")
                    Text("• Real-time confirmation")
                    Text("• Integration with apps")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Cons:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• Needs phone battery")
                    Text("• Requires internet")
                    Text("• Learning curve")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("💳 Credit Cards")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    Text("Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Universal acceptance")
                    Text("• Fraud protection")
                    Text("• Works offline")
                    Text("• Familiar to tourists")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Cons:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• Higher merchant fees")
                    Text("• Slower processing")
                    Text("• Foreign transaction fees")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Best Use:")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("QR for daily, cards for backup")
                    .font(.body)
                    .foregroundColor(.purple)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func activePvPassiveComparison() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📷 Active Scan")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("When:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Small vendors")
                    Text("• Vending machines")
                    Text("• Street food")
                        .font(.caption)
                    
                    Text("Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("• You control amount")
                    Text("• No waiting for cashier")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Cons:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• Need to know price")
                    Text("• More error-prone")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("📲 Passive Scan")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("When:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("• Supermarkets")
                    Text("• Restaurants")
                    Text("• Chain stores")
                        .font(.caption)
                    
                    Text("Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("• Amount pre-filled")
                    Text("• Less mistakes")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Text("Cons:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("• Wait for cashier")
                    Text("• Need to trust amount")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Recommendation:")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Learn both methods")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func mobileVsCashComparison() -> some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("📱 Mobile Payment")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("Speed: ⚡⚡⚡⚡⚡")
                        .font(.caption)
                    Text("Convenience: ⭐⭐⭐⭐⭐")
                        .font(.caption)
                    Text("Security: 🛡️🛡️🛡️🛡️")
                        .font(.caption)
                    Text("Acceptance: 📍📍📍📍")
                        .font(.caption)
                    
                    Text("Best for:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("• Regular transactions")
                    Text("• Urban areas")
                    Text("• Tech-savvy users")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("💵 Cash")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Speed: ⚡⚡")
                        .font(.caption)
                    Text("Convenience: ⭐⭐")
                        .font(.caption)
                    Text("Security: 🛡️🛡️")
                        .font(.caption)
                    Text("Acceptance: 📍📍📍📍📍")
                        .font(.caption)
                    
                    Text("Best for:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("• Emergency backup")
                    Text("• Rural areas")
                    Text("• Small amounts")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Text("Strategy:")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Mobile primary, cash backup")
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func scenarioRecommendation(for index: Int) -> some View {
        let scenarios = [
            (
                title: "☕ Coffee Shop",
                situation: "Quick morning coffee purchase",
                best: "Show QR Code",
                backup: "Contactless Card",
                reasoning: "Fast, convenient, small amount",
                tips: ["Set up password-free payment", "Have backup ready for busy times"]
            ),
            (
                title: "🛒 Supermarket",
                situation: "Weekly grocery shopping",
                best: "Active QR Scan",
                backup: "Credit Card",
                reasoning: "Can verify total, good for larger amounts",
                tips: ["Check receipt carefully", "Use loyalty programs if available"]
            ),
            (
                title: "🥟 Street Vendor",
                situation: "Local food from small vendor",
                best: "WeChat Pay QR",
                backup: "Cash",
                reasoning: "More popular with local vendors",
                tips: ["Have cash ready", "Learn basic Chinese numbers"]
            ),
            (
                title: "🎫 Tourist Attraction",
                situation: "Tickets and souvenirs",
                best: "Alipay",
                backup: "International Card",
                reasoning: "Tourist-friendly, often has promotions",
                tips: ["Check for tourist discounts", "Save receipts for tax refund"]
            )
        ]
        
        let scenario = scenarios[index]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(scenario.title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text("Situation: \(scenario.situation)")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🥇 Best Choice")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text(scenario.best)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("🥈 Backup")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text(scenario.backup)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
            }
            
            Text("Why: \(scenario.reasoning)")
                .font(.caption)
                .italic()
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("💡 Pro Tips:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                
                ForEach(scenario.tips, id: \.self) { tip in
                    Text("• \(tip)")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func speedComparisonBar(method: String, time: String, efficiency: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(method)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * efficiency, height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding(.vertical, 4)
    }
    
    private func securityHeaderRow() -> some View {
        HStack {
            Text("Method")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Encryption")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            
            Text("Auth")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            
            Text("Fraud")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            
            Text("Privacy")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
            
            Text("Overall")
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray5))
    }
    
    private func securityComparisonRow(method: String, encryption: String, authentication: String, fraud: String, privacy: String, overall: Color) -> some View {
        HStack {
            Text(method)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(encryption)
                .font(.caption)
                .frame(maxWidth: .infinity)
            
            Text(authentication)
                .font(.caption)
                .frame(maxWidth: .infinity)
            
            Text(fraud)
                .font(.caption)
                .frame(maxWidth: .infinity)
            
            Text(privacy)
                .font(.caption)
                .frame(maxWidth: .infinity)
            
            Circle()
                .fill(overall)
                .frame(width: 12, height: 12)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 6)
    }
    
    private func costComparisonCard(method: String, userCost: String, merchantCost: String, setupCost: String, hiddenCosts: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(method)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("User Cost:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(userCost)
                        .font(.caption)
                    
                    Text("Merchant Cost:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(merchantCost)
                        .font(.caption)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Setup Cost:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(setupCost)
                        .font(.caption)
                    
                    Text("Hidden Costs:")
                        .font(.caption)
                        .fontWeight(.bold)
                    ForEach(hiddenCosts, id: \.self) { cost in
                        Text("• \(cost)")
                            .font(.caption2)
                    }
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func trendCard(demographic: String, preference: String, adoption: String, reason: String, color: Color) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(demographic)
                    .font(.caption)
                    .fontWeight(.bold)
                Text("Prefers: \(preference)")
                    .font(.caption2)
                Text("Adoption: \(adoption)")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Why:")
                    .font(.caption2)
                    .fontWeight(.bold)
                Text(reason)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func recommendationCard(userType: String, primary: String, backup: String, reasoning: String, confidence: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("👤 \(userType)")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Confidence: \(confidence)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Primary:")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(primary)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("Backup:")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(backup)
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            Text("Reasoning: \(reasoning)")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    QRCodePaymentArticleView()
} 