//
//  TelecomServiceArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct TelecomServiceArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCarrier = 0
    @State private var selectedTestCategory = 0
    @State private var showingDetailedReview = false
    
    let carriers = ["China Mobile", "China Unicom", "China Telecom", "Digital MVNOs"]
    let testCategories = ["Speed Tests", "Coverage Maps", "Price Analysis", "User Experience"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Tech Review Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .pink, .orange]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("Carrier Review 2024")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Complete Tech Analysis • Speed Tests • Coverage Maps • Real User Reviews")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Editor's Choice Awards
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "award.fill")
                                    .foregroundColor(.yellow)
                                Text("Editor's Choice Awards")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Best in category")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 15) {
                                awardCard(
                                    category: "Best Overall",
                                    winner: "China Mobile",
                                    score: "9.2/10",
                                    reason: "Unmatched coverage and reliability"
                                )
                                
                                awardCard(
                                    category: "Best Performance",
                                    winner: "China Unicom",
                                    score: "9.5/10",
                                    reason: "Fastest speeds in major cities"
                                )
                                
                                awardCard(
                                    category: "Best Value",
                                    winner: "China Telecom",
                                    score: "8.8/10",
                                    reason: "Competitive pricing with solid service"
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Detailed Carrier Review
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "chart.bar.doc.horizontal")
                                    .foregroundColor(.blue)
                                Text("Detailed Reviews")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("In-depth analysis")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Carrier", selection: $selectedCarrier) {
                                ForEach(0..<carriers.count, id: \.self) { index in
                                    Text(carriers[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            carrierReviewContent(for: selectedCarrier)
                        }
                        
                        // Performance Benchmarks
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundColor(.green)
                                Text("Performance Tests")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Test Category", selection: $selectedTestCategory) {
                                ForEach(0..<testCategories.count, id: \.self) { index in
                                    Text(testCategories[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            testResultsContent(for: selectedTestCategory)
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // User Reviews & Ratings
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "person.3.fill")
                                    .foregroundColor(.orange)
                                Text("User Reviews")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Real customer feedback")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                userReviewCard(
                                    reviewer: "TechEnthusiast2024",
                                    rating: 5,
                                    carrier: "China Unicom",
                                    review: "Blazing fast 5G speeds in Shanghai. Downloaded a 4GB game in under 3 minutes!",
                                    verified: true
                                )
                                
                                userReviewCard(
                                    reviewer: "GlobalNomad",
                                    rating: 4,
                                    carrier: "China Mobile",
                                    review: "Best coverage I've experienced. Signal works even in remote mountains.",
                                    verified: true
                                )
                                
                                userReviewCard(
                                    reviewer: "BudgetTraveler",
                                    rating: 4,
                                    carrier: "China Telecom",
                                    review: "Great value for money. 50GB for ¥99 is unbeatable in most countries.",
                                    verified: false
                                )
                            }
                        }
                        
                        // Comparison Table
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "table")
                                    .foregroundColor(.purple)
                                Text("Head-to-Head Comparison")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            comparisonTable()
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Buying Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.cyan)
                                Text("Buying Recommendations")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                recommendationCard(
                                    userType: "Power Users",
                                    recommendation: "China Unicom",
                                    reason: "Fastest speeds and best tech support for heavy data usage"
                                )
                                
                                recommendationCard(
                                    userType: "Travelers",
                                    recommendation: "China Mobile",
                                    reason: "Widest coverage and strongest signal in rural areas"
                                )
                                
                                recommendationCard(
                                    userType: "Budget Conscious",
                                    recommendation: "China Telecom",
                                    reason: "Best price-to-performance ratio with solid reliability"
                                )
                                
                                recommendationCard(
                                    userType: "Tech Enthusiasts",
                                    recommendation: "Digital MVNOs",
                                    reason: "Latest features and innovative services at competitive prices"
                                )
                            }
                        }
                        
                        // Final Verdict
                        if showingDetailedReview {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("🏆")
                                        .font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text("Final Verdict")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Editor's recommendation")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🥇 **Best Choice**: China Mobile for most users")
                                    Text("🥈 **Performance King**: China Unicom for speed lovers")  
                                    Text("🥉 **Value Champion**: China Telecom for budget users")
                                    Text("🔬 **Innovation**: Digital MVNOs for tech early adopters")
                                }
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Call to Action
                        Button(action: {
                            showingDetailedReview.toggle()
                        }) {
                            Text(showingDetailedReview ? "Hide Final Verdict" : "Show Final Verdict 🏆")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(showingDetailedReview ? Color.gray : Color.purple)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Carrier Reviews")
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
    
    // Helper Views
    private func awardCard(category: String, winner: String, score: String, reason: String) -> some View {
        HStack(alignment: .center, spacing: 15) {
            VStack {
                Text("🏆")
                    .font(.title2)
                Text(score)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                Text(winner)
                    .font(.headline)
                    .fontWeight(.bold)
                Text(reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func carrierReviewContent(for carrier: Int) -> some View {
        let reviewData = [
            // China Mobile
            (
                name: "China Mobile",
                logo: "📱",
                overallScore: "9.2/10",
                strengths: ["Widest coverage nationwide", "Best customer service", "Reliable 4G/5G network", "Strong international roaming"],
                weaknesses: ["Slightly higher pricing", "Slower speeds in some areas", "Limited innovation"],
                scores: ["Coverage: 9.8/10", "Speed: 8.5/10", "Value: 7.9/10", "Service: 9.4/10"],
                verdict: "The gold standard for reliability and coverage"
            ),
            // China Unicom
            (
                name: "China Unicom",
                logo: "🚀",
                overallScore: "8.9/10",
                strengths: ["Fastest download speeds", "Advanced 5G rollout", "Tech-forward approach", "Good international partnerships"],
                weaknesses: ["Limited rural coverage", "Inconsistent service quality", "Higher data prices"],
                scores: ["Coverage: 8.2/10", "Speed: 9.8/10", "Value: 8.1/10", "Service: 8.7/10"],
                verdict: "Speed demon perfect for urban power users"
            ),
            // China Telecom  
            (
                name: "China Telecom",
                logo: "📡",
                overallScore: "8.7/10",
                strengths: ["Excellent value for money", "Good network stability", "Decent coverage", "Competitive pricing"],
                weaknesses: ["Slower adoption of new tech", "Average speeds", "Limited premium features"],
                scores: ["Coverage: 8.5/10", "Speed: 8.0/10", "Value: 9.2/10", "Service: 8.1/10"],
                verdict: "Smart choice for budget-conscious users"
            ),
            // Digital MVNOs
            (
                name: "Digital MVNOs",
                logo: "🔬",
                overallScore: "7.8/10",
                strengths: ["Innovative features", "App-first approach", "Competitive pricing", "Modern user experience"],
                weaknesses: ["Limited network own infrastructure", "Newer brands with less track record", "Coverage gaps"],
                scores: ["Coverage: 7.0/10", "Speed: 8.3/10", "Value: 8.8/10", "Service: 7.5/10"],
                verdict: "Exciting option for tech enthusiasts"
            )
        ]
        
        let review = reviewData[carrier]
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(review.logo)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text(review.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Overall Score: \(review.overallScore)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("✅ Strengths:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    ForEach(review.strengths, id: \.self) { strength in
                        Text("• \(strength)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("⚠️ Weaknesses:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    ForEach(review.weaknesses, id: \.self) { weakness in
                        Text("• \(weakness)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Detailed Scores:")
                    .font(.caption)
                    .fontWeight(.bold)
                ForEach(review.scores, id: \.self) { score in
                    Text("📊 \(score)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Text("💡 \(review.verdict)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.purple)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func testResultsContent(for category: Int) -> some View {
        VStack(spacing: 15) {
            switch category {
            case 0: // Speed Tests
                speedTestResults()
            case 1: // Coverage Maps
                coverageAnalysis()
            case 2: // Price Analysis
                priceComparison()
            case 3: // User Experience
                userExperienceMetrics()
            default:
                EmptyView()
            }
        }
    }
    
    private func speedTestResults() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Speed Test Results (March 2024)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                speedResultRow(
                    carrier: "China Unicom",
                    download: "156 Mbps",
                    upload: "87 Mbps",
                    ping: "12ms",
                    color: .green
                )
                
                speedResultRow(
                    carrier: "China Mobile",
                    download: "134 Mbps",
                    upload: "76 Mbps", 
                    ping: "15ms",
                    color: .blue
                )
                
                speedResultRow(
                    carrier: "China Telecom",
                    download: "118 Mbps",
                    upload: "65 Mbps",
                    ping: "18ms",
                    color: .orange
                )
                
                speedResultRow(
                    carrier: "MVNO Average",
                    download: "98 Mbps",
                    upload: "52 Mbps",
                    ping: "22ms",
                    color: .gray
                )
            }
            
            Text("📍 Test locations: Shanghai, Beijing, Guangzhou, Shenzhen (avg. of 1000+ tests)")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func speedResultRow(carrier: String, download: String, upload: String, ping: String, color: Color) -> some View {
        HStack {
            Text(carrier)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text("↓\(download)")
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 60)
            
            Text("↑\(upload)")
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 60)
            
            Text("⚡\(ping)")
                .font(.caption)
                .foregroundColor(color)
                .frame(width: 40)
        }
        .padding(.vertical, 4)
    }
    
    private func coverageAnalysis() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Coverage Analysis")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 10) {
                coverageRow(
                    area: "Tier 1 Cities",
                    mobile: "99%",
                    unicom: "97%",
                    telecom: "95%"
                )
                
                coverageRow(
                    area: "Tier 2 Cities", 
                    mobile: "95%",
                    unicom: "88%",
                    telecom: "90%"
                )
                
                coverageRow(
                    area: "Rural Areas",
                    mobile: "87%",
                    unicom: "72%",
                    telecom: "78%"
                )
                
                coverageRow(
                    area: "High-speed Rail",
                    mobile: "92%",
                    unicom: "85%",
                    telecom: "81%"
                )
            }
            
            Text("🗺️ Based on independent coverage testing by OpenSignal")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func coverageRow(area: String, mobile: String, unicom: String, telecom: String) -> some View {
        HStack {
            Text(area)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(mobile)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .frame(width: 50)
            
            Text(unicom)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.purple)
                .frame(width: 50)
            
            Text(telecom)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
                .frame(width: 50)
        }
    }
    
    private func priceComparison() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Price Analysis (Monthly Plans)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                priceRow(
                    plan: "Basic (20GB)",
                    mobile: "¥89",
                    unicom: "¥79",
                    telecom: "¥69"
                )
                
                priceRow(
                    plan: "Standard (50GB)",
                    mobile: "¥129",
                    unicom: "¥119",
                    telecom: "¥99"
                )
                
                priceRow(
                    plan: "Premium (100GB)",
                    mobile: "¥199",
                    unicom: "¥189",
                    telecom: "¥159"
                )
                
                priceRow(
                    plan: "Unlimited",
                    mobile: "¥299",
                    unicom: "¥269",
                    telecom: "¥229"
                )
            }
            
            Text("💰 Prices include unlimited domestic calls and SMS")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func priceRow(plan: String, mobile: String, unicom: String, telecom: String) -> some View {
        HStack {
            Text(plan)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            Text(mobile)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .frame(width: 50)
            
            Text(unicom)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.purple)
                .frame(width: 50)
            
            Text(telecom)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
                .frame(width: 50)
        }
    }
    
    private func userExperienceMetrics() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("User Experience Ratings")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                uxRow(
                    metric: "App Quality",
                    mobile: 4.2,
                    unicom: 4.5,
                    telecom: 3.9
                )
                
                uxRow(
                    metric: "Customer Service",
                    mobile: 4.6,
                    unicom: 4.0,
                    telecom: 4.1
                )
                
                uxRow(
                    metric: "Network Reliability",
                    mobile: 4.7,
                    unicom: 4.2,
                    telecom: 4.3
                )
                
                uxRow(
                    metric: "Setup Process",
                    mobile: 3.8,
                    unicom: 4.1,
                    telecom: 4.0
                )
            }
            
            Text("⭐ Average ratings from 50,000+ App Store reviews")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func uxRow(metric: String, mobile: Double, unicom: Double, telecom: Double) -> some View {
        HStack {
            Text(metric)
                .font(.subheadline)
                .frame(width: 100, alignment: .leading)
            
            Spacer()
            
            starRating(rating: mobile, color: .blue)
                .frame(width: 80)
            
            starRating(rating: unicom, color: .purple)
                .frame(width: 80)
            
            starRating(rating: telecom, color: .orange)
                .frame(width: 80)
        }
    }
    
    private func starRating(rating: Double, color: Color) -> some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= Int(rating) ? "star.fill" : "star")
                    .font(.caption2)
                    .foregroundColor(color)
            }
            Text(String(format: "%.1f", rating))
                .font(.caption2)
                .foregroundColor(color)
        }
    }
    
    private func userReviewCard(reviewer: String, rating: Int, carrier: String, review: String, verified: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(reviewer)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                if verified {
                    Text("✓ Verified")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
            }
            
            Text(carrier)
                .font(.caption)
                .foregroundColor(.blue)
                .fontWeight(.medium)
            
            Text(review)
                .font(.body)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func comparisonTable() -> some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text("Feature")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 80, alignment: .leading)
                
                Text("Mobile")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 60)
                
                Text("Unicom")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 60)
                
                Text("Telecom")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(width: 60)
            }
            .padding(.bottom, 8)
            
            Divider()
            
            // Comparison rows
            comparisonRow(
                feature: "5G Coverage",
                mobile: "90%",
                unicom: "85%",
                telecom: "80%"
            )
            
            comparisonRow(
                feature: "Intl Roaming",
                mobile: "200+ countries",
                unicom: "180+ countries",
                telecom: "150+ countries"
            )
            
            comparisonRow(
                feature: "English Support",
                mobile: "Good",
                unicom: "Fair",
                telecom: "Fair"
            )
            
            comparisonRow(
                feature: "eSIM Support",
                mobile: "✓",
                unicom: "✓",
                telecom: "Limited"
            )
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func comparisonRow(feature: String, mobile: String, unicom: String, telecom: String) -> some View {
        HStack {
            Text(feature)
                .font(.caption)
                .frame(width: 80, alignment: .leading)
            
            Text(mobile)
                .font(.caption)
                .frame(width: 60)
            
            Text(unicom)
                .font(.caption)
                .frame(width: 60)
            
            Text(telecom)
                .font(.caption)
                .frame(width: 60)
        }
        .padding(.vertical, 2)
    }
    
    private func recommendationCard(userType: String, recommendation: String, reason: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(userType)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.cyan)
            
            Text("→ \(recommendation)")
                .font(.body)
                .fontWeight(.semibold)
            
            Text(reason)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.cyan.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    TelecomServiceArticleView()
}