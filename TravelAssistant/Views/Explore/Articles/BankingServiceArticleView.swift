//
//  BankingServiceArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct BankingServiceArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBankCategory = 0
    @State private var selectedStrategy = 0
    @State private var showingROICalculator = false
    
    let bankCategories = ["Big Four State Banks", "Joint-Stock Banks", "Foreign Banks", "Digital Banks"]
    let strategies = ["Conservative Approach", "Balanced Portfolio", "Growth Strategy", "Expat Special"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Investment Advisor Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.indigo, .blue, .teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("Banking Strategy Report")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Professional Financial Advisory • Maximize Your China Banking ROI")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Market Analysis
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "chart.bar.xaxis")
                                    .foregroundColor(.blue)
                                Text("Market Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Current financial landscape")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 15) {
                                marketInsightCard(
                                    metric: "Market Dominance",
                                    value: "Big Four: 85%",
                                    trend: "Stable",
                                    insight: "Traditional banks still control the majority of assets and services"
                                )
                                
                                marketInsightCard(
                                    metric: "Digital Innovation",
                                    value: "Mobile Banking: 95%",
                                    trend: "Rapidly Growing",
                                    insight: "Digital services are now standard across all major banks"
                                )
                                
                                marketInsightCard(
                                    metric: "Foreign Access",
                                    value: "Requirements: Stricter",
                                    trend: "Tightening",
                                    insight: "Documentation requirements have increased for compliance"
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Strategic Bank Analysis
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(.green)
                                Text("Strategic Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Bank performance metrics")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Bank Category", selection: $selectedBankCategory) {
                                ForEach(0..<bankCategories.count, id: \.self) { index in
                                    Text(bankCategories[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            bankAnalysisContent(for: selectedBankCategory)
                        }
                        
                        // Investment Strategy Selector
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.purple)
                                Text("Investment Strategy")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Strategy", selection: $selectedStrategy) {
                                ForEach(0..<strategies.count, id: \.self) { index in
                                    Text(strategies[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            strategyContent(for: selectedStrategy)
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(15)
                        
                        // ROI Calculator
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "function")
                                    .foregroundColor(.orange)
                                Text("ROI Analysis")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Calculate your returns")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            if showingROICalculator {
                                roiCalculatorView()
                            } else {
                                roiPreviewCard()
                            }
                            
                            Button(action: {
                                showingROICalculator.toggle()
                            }) {
                                Text(showingROICalculator ? "Hide Calculator" : "Show ROI Calculator")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                        }
                        
                        // Risk Assessment
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "shield.checkerboard")
                                    .foregroundColor(.red)
                                Text("Risk Assessment")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                riskCard(
                                    category: "Regulatory Risk",
                                    level: "Medium",
                                    description: "Foreign exchange regulations may change",
                                    mitigation: "Stay informed of policy changes, diversify across banks"
                                )
                                
                                riskCard(
                                    category: "Currency Risk",
                                    level: "Low-Medium",
                                    description: "RMB exchange rate fluctuations",
                                    mitigation: "Consider multi-currency accounts for hedging"
                                )
                                
                                riskCard(
                                    category: "Liquidity Risk",
                                    level: "Low",
                                    description: "Difficulty accessing funds quickly",
                                    mitigation: "Maintain accounts at multiple institutions"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Professional Recommendations
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Advisory Recommendations")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                recommendationCard(
                                    tier: "Tier 1 Priority",
                                    recommendation: "ICBC or Bank of China for primary relationship",
                                    rationale: "Strongest international support and widest acceptance"
                                )
                                
                                recommendationCard(
                                    tier: "Tier 2 Growth",
                                    recommendation: "China Merchants Bank for digital services",
                                    rationale: "Superior mobile banking and customer experience"
                                )
                                
                                recommendationCard(
                                    tier: "Tier 3 Specialty",
                                    recommendation: "Foreign bank for international needs",
                                    rationale: "Familiar systems and global coordination"
                                )
                            }
                        }
                        
                        // Executive Summary
                        VStack(spacing: 15) {
                            HStack {
                                Text("📊")
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text("Executive Summary")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("Our professional recommendation")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            
                            Text("Based on current market analysis, we recommend a **three-bank strategy**: Primary relationship with a Big Four bank for daily operations, secondary account with China Merchants Bank for digital convenience, and maintain foreign bank access for international coordination. This approach optimizes cost efficiency while minimizing operational risk.")
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Banking Advisory")
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
    private func marketInsightCard(metric: String, value: String, trend: String, insight: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(alignment: .leading, spacing: 4) {
                Text(metric)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .frame(width: 120, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Trend:")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text(trend)
                        .font(.caption)
                        .foregroundColor(.green)
                }
                Text(insight)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private func bankAnalysisContent(for category: Int) -> some View {
        let analysisData = [
            // Big Four State Banks
            (
                banks: ["ICBC", "Agricultural Bank", "Bank of China", "Construction Bank"],
                strengths: ["Widest network", "Government backing", "Stable operations", "International presence"],
                metrics: ["Branches: 40,000+", "Assets: $4.3T", "Foreign support: High", "Mobile rating: 4.2/5"],
                recommendation: "Ideal for primary banking relationship - stability and coverage"
            ),
            // Joint-Stock Banks
            (
                banks: ["China Merchants", "Industrial Bank", "Minsheng Bank", "Ping An Bank"],
                strengths: ["Digital innovation", "Customer service", "Flexible products", "Tech integration"],
                metrics: ["Branches: 15,000+", "Assets: $1.8T", "Digital score: 9.2/10", "Mobile rating: 4.7/5"],
                recommendation: "Best for users prioritizing digital experience and service quality"
            ),
            // Foreign Banks
            (
                banks: ["HSBC", "Citibank", "Standard Chartered", "DBS"],
                strengths: ["International expertise", "English service", "Global network", "Familiar systems"],
                metrics: ["Branches: 200+", "Assets: $400B", "English support: 100%", "International rating: 4.8/5"],
                recommendation: "Perfect complement for international professionals and frequent travelers"
            ),
            // Digital Banks
            (
                banks: ["WeBank", "MYbank", "Baixin Bank", "NetBank"],
                strengths: ["Pure digital", "Lower fees", "24/7 service", "AI-powered"],
                metrics: ["Branches: 0", "Assets: $50B", "Digital-first: 100%", "Innovation score: 9.5/10"],
                recommendation: "Emerging option for tech-savvy users, limited foreign access currently"
            )
        ]
        
        let analysis = analysisData[category]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text("Top Banks in Category:")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            HStack {
                ForEach(analysis.banks, id: \.self) { bank in
                    Text(bank)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Key Strengths:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                ForEach(analysis.strengths, id: \.self) { strength in
                    Text("• \(strength)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Performance Metrics:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                ForEach(analysis.metrics, id: \.self) { metric in
                    Text("📊 \(metric)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Text("💡 Advisory: \(analysis.recommendation)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func strategyContent(for strategy: Int) -> some View {
        let strategies = [
            (
                title: "Conservative Approach",
                profile: "Risk-averse, stability focused",
                allocation: ["Big Four: 80%", "Foreign bank: 20%"],
                products: ["Savings accounts", "Time deposits", "Government bonds"],
                timeframe: "Long-term stability",
                expectedROI: "2-4% annually"
            ),
            (
                title: "Balanced Portfolio",
                profile: "Moderate risk, steady growth",
                allocation: ["Big Four: 50%", "Joint-stock: 30%", "Foreign: 20%"],
                products: ["Mixed deposits", "Bank wealth products", "Fund investments"],
                timeframe: "3-5 years",
                expectedROI: "4-7% annually"
            ),
            (
                title: "Growth Strategy",
                profile: "Higher risk tolerance, growth seeking",
                allocation: ["Joint-stock: 40%", "Digital: 30%", "Big Four: 30%"],
                products: ["Equity funds", "Structured products", "High-yield deposits"],
                timeframe: "5+ years",
                expectedROI: "6-12% annually"
            ),
            (
                title: "Expat Special",
                profile: "International professionals",
                allocation: ["Foreign bank: 40%", "Big Four: 35%", "Joint-stock: 25%"],
                products: ["Multi-currency", "International transfers", "Global investment"],
                timeframe: "Flexible",
                expectedROI: "3-8% annually"
            )
        ]
        
        let strat = strategies[strategy]
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(strat.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Spacer()
                Text("ROI: \(strat.expectedROI)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text("Target Profile: \(strat.profile)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Recommended Allocation:")
                    .font(.caption)
                    .fontWeight(.bold)
                ForEach(strat.allocation, id: \.self) { allocation in
                    Text("• \(allocation)")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Product Mix:")
                    .font(.caption)
                    .fontWeight(.bold)
                ForEach(strat.products, id: \.self) { product in
                    Text("💼 \(product)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Text("⏱️ Investment timeframe: \(strat.timeframe)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func roiPreviewCard() -> some View {
        VStack(spacing: 12) {
            Text("Sample ROI Scenarios")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            HStack {
                roiScenarioColumn(
                    scenario: "Conservative",
                    amount: "¥100,000",
                    return1y: "¥3,000",
                    return5y: "¥16,000"
                )
                
                roiScenarioColumn(
                    scenario: "Balanced",
                    amount: "¥100,000",
                    return1y: "¥5,500",
                    return5y: "¥31,000"
                )
                
                roiScenarioColumn(
                    scenario: "Growth",
                    amount: "¥100,000",
                    return1y: "¥9,000",
                    return5y: "¥61,000"
                )
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func roiScenarioColumn(scenario: String, amount: String, return1y: String, return5y: String) -> some View {
        VStack(spacing: 6) {
            Text(scenario)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Text("Initial: \(amount)")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Text("1Y: \(return1y)")
                .font(.caption)
                .fontWeight(.medium)
            
            Text("5Y: \(return5y)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func roiCalculatorView() -> some View {
        VStack(spacing: 15) {
            Text("Interactive ROI Calculator")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            // Placeholder for calculator interface
            VStack(spacing: 10) {
                Text("📊 Input your scenario:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("• Initial deposit amount")
                Text("• Monthly contributions")
                Text("• Investment timeframe")
                Text("• Risk tolerance level")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .padding()
            .background(Color(.systemGray6).opacity(0.3))
            .cornerRadius(8)
            
            Text("💡 Pro tip: Diversification across 2-3 banks typically optimizes risk-adjusted returns")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func riskCard(category: String, level: String, description: String, mitigation: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(level)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        level.contains("Low") ? Color.green :
                        level.contains("Medium") ? Color.orange : Color.red
                    )
                    .cornerRadius(8)
            }
            
            Text("Risk: \(description)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("Mitigation: \(mitigation)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func recommendationCard(tier: String, recommendation: String, rationale: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(tier)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.yellow)
            
            Text(recommendation)
                .font(.body)
                .fontWeight(.semibold)
            
            Text("Rationale: \(rationale)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    BankingServiceArticleView()
}