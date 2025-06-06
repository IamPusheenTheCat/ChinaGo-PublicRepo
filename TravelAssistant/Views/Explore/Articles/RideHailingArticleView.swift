//
//  RideHailingArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct RideHailingArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedApp = 0
    @State private var selectedScenario = 0
    
    let apps = ["Didi", "Meituan", "AutoNavi", "T3"]
    let scenarios = ["Airport Run", "Daily Commute", "Late Night", "Group Travel"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Modern Hero Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.orange, .yellow]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 240)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 55))
                                .foregroundColor(.white)
                            
                            Text("Ride-Hailing Apps Decoded")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Compare, choose, and ride with confidence")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Why Ride-Hailing Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Why Choose Ride-Hailing?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                benefitCard(
                                    icon: "🚗",
                                    title: "Door-to-Door Convenience",
                                    description: "No walking to stations, no transfers needed"
                                )
                                
                                benefitCard(
                                    icon: "⏰",
                                    title: "24/7 Availability",
                                    description: "Get a ride anytime, anywhere in the city"
                                )
                                
                                benefitCard(
                                    icon: "💺",
                                    title: "Comfort & Privacy",
                                    description: "AC, music, and personal space for your journey"
                                )
                                
                                benefitCard(
                                    icon: "🛡️",
                                    title: "Safety Features",
                                    description: "GPS tracking, driver verification, and trip sharing"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(15)
                        
                        // App Comparison Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "apps.iphone")
                                    .foregroundColor(.purple)
                                Text("App Showdown")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("- Pick Your Champion")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("App", selection: $selectedApp) {
                                ForEach(0..<apps.count, id: \.self) { index in
                                    Text(apps[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            appComparisonCard(for: selectedApp)
                        }
                        
                        // Vehicle Types
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "car.2.fill")
                                    .foregroundColor(.green)
                                Text("Choose Your Ride")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                vehicleTypeCard(
                                    type: "Economy",
                                    cars: "Nissan Sentra, VW Lavida",
                                    price: "$3-6",
                                    bestFor: "Daily trips, budget-conscious rides",
                                    icon: "💰",
                                    color: .green
                                )
                                
                                vehicleTypeCard(
                                    type: "Comfort",
                                    cars: "Camry, Accord, Model 3",
                                    price: "$5-10",
                                    bestFor: "Airport runs, important meetings",
                                    icon: "⭐",
                                    color: .blue
                                )
                                
                                vehicleTypeCard(
                                    type: "Business",
                                    cars: "BMW 5 Series, Audi A6",
                                    price: "$8-15",
                                    bestFor: "Client meetings, special occasions",
                                    icon: "💼",
                                    color: .purple
                                )
                                
                                vehicleTypeCard(
                                    type: "Luxury",
                                    cars: "Mercedes S-Class, BMW 7 Series",
                                    price: "$15-30",
                                    bestFor: "VIP treatment, luxury experience",
                                    icon: "💎",
                                    color: .orange
                                )
                            }
                        }
                        
                        // Scenario-Based Tips
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.red)
                                Text("Smart Scenarios")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Scenario", selection: $selectedScenario) {
                                ForEach(0..<scenarios.count, id: \.self) { index in
                                    Text(scenarios[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            scenarioAdviceCard(for: selectedScenario)
                        }
                        
                        // Booking Process Made Simple
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "list.number")
                                    .foregroundColor(.cyan)
                                Text("The Booking Process")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                processStep(
                                    number: "1",
                                    title: "Set Your Destination",
                                    description: "Type address or pin location on map",
                                    tip: "Save frequently used addresses for quick booking",
                                    color: .blue
                                )
                                
                                processStep(
                                    number: "2",
                                    title: "Choose Vehicle & Time",
                                    description: "Pick car type and departure time",
                                    tip: "Book 10-15 minutes ahead during rush hour",
                                    color: .green
                                )
                                
                                processStep(
                                    number: "3",
                                    title: "Confirm & Track",
                                    description: "Get driver details and live tracking",
                                    tip: "Screenshot driver info for safety",
                                    color: .orange
                                )
                                
                                processStep(
                                    number: "4",
                                    title: "Ride & Pay",
                                    description: "Enjoy the ride, auto-payment at the end",
                                    tip: "Rate your driver to help future passengers",
                                    color: .purple
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.cyan.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Cost Breakdown
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                Text("Understanding Costs")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                costFactorCard(
                                    factor: "Base Fare",
                                    amount: "$1.50-2.50",
                                    explanation: "Starting price for first 3km"
                                )
                                
                                costFactorCard(
                                    factor: "Distance Fee",
                                    amount: "$0.50/km",
                                    explanation: "Added for each kilometer beyond base"
                                )
                                
                                costFactorCard(
                                    factor: "Time Fee",
                                    amount: "$0.15/min",
                                    explanation: "For waiting in traffic or delays"
                                )
                                
                                costFactorCard(
                                    factor: "Peak Pricing",
                                    amount: "+20-50%",
                                    explanation: "Rush hours, bad weather, high demand"
                                )
                            }
                            
                            Text("💡 Pro Tip: Compare prices across apps before booking - they can vary significantly!")
                                .font(.callout)
                                .italic()
                                .foregroundColor(.blue)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(10)
                        }
                        
                        // Safety & Etiquette
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "shield.checkered")
                                    .foregroundColor(.red)
                                Text("Stay Safe & Be Respectful")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            HStack(alignment: .top, spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🛡️ Safety First")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    
                                    Text("• Check license plate matches app")
                                    Text("• Share trip details with friends")
                                    Text("• Sit in back seat for safety")
                                    Text("• Trust your instincts")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🤝 Good Etiquette")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    
                                    Text("• Be ready when driver arrives")
                                    Text("• Keep conversations friendly")
                                    Text("• No eating smelly food")
                                    Text("• Rate fairly and tip through app")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Final Recommendation
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                Text("Our Recommendation")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Start with Didi for reliability, try Meituan for savings, and use AutoNavi for navigation accuracy. Each app has its strengths, so having 2-3 installed gives you the best coverage and prices. Happy riding! 🚗")
                                .font(.body)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Ride-Hailing")
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
    private func benefitCard(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func appComparisonCard(for app: Int) -> some View {
        let content = getAppContent(for: app)
        
        return VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(content.emoji)
                    .font(.title)
                Text(content.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(content.color)
                Spacer()
                Text(content.rating)
                    .font(.title3)
            }
            
            Text(content.tagline)
                .font(.body)
                .italic()
                .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("✅ Strengths")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    ForEach(content.pros, id: \.self) { pro in
                        Text("• \(pro)")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("⚠️ Watch Out")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                    
                    ForEach(content.cons, id: \.self) { con in
                        Text("• \(con)")
                            .font(.caption)
                    }
                }
            }
            
            Text("Best for: \(content.bestFor)")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(content.color)
                .padding(.top, 5)
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getAppContent(for app: Int) -> (name: String, emoji: String, tagline: String, pros: [String], cons: [String], bestFor: String, rating: String, color: Color) {
        switch app {
        case 0: // Didi
            return (
                name: "Didi",
                emoji: "🚖",
                tagline: "The market leader with the most reliable service",
                pros: ["Largest fleet", "Best coverage", "English support", "Safety features"],
                cons: ["Higher prices", "Surge pricing", "Popular = busy"],
                bestFor: "First-time users and reliability-focused travelers",
                rating: "⭐⭐⭐⭐⭐",
                color: .orange
            )
        case 1: // Meituan
            return (
                name: "Meituan",
                emoji: "🛵",
                tagline: "Great value with frequent promotions and discounts",
                pros: ["Best prices", "Fast pickup", "Good app UX", "Frequent discounts"],
                cons: ["Smaller fleet", "Limited English", "Fewer luxury options"],
                bestFor: "Budget-conscious riders and frequent users",
                rating: "⭐⭐⭐⭐",
                color: .yellow
            )
        case 2: // AutoNavi
            return (
                name: "AutoNavi",
                emoji: "🗺️",
                tagline: "Superior navigation with multiple service providers",
                pros: ["Best routes", "Multiple providers", "Good prices", "Map integration"],
                cons: ["Less standardized", "Variable quality", "Chinese-focused"],
                bestFor: "Navigation enthusiasts and comparison shoppers",
                rating: "⭐⭐⭐⭐",
                color: .blue
            )
        case 3: // T3
            return (
                name: "T3",
                emoji: "🏢",
                tagline: "Professional service backed by state-owned companies",
                pros: ["Professional drivers", "Standardized service", "Good car quality", "Reliable"],
                cons: ["Higher prices", "Limited coverage", "Fewer cars available"],
                bestFor: "Business travelers and quality-focused users",
                rating: "⭐⭐⭐⭐",
                color: .purple
            )
        default:
            return (name: "", emoji: "", tagline: "", pros: [], cons: [], bestFor: "", rating: "", color: .gray)
        }
    }
    
    private func vehicleTypeCard(type: String, cars: String, price: String, bestFor: String, icon: String, color: Color) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(type)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(price)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(color)
                }
                
                Text(cars)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Best for: \(bestFor)")
                    .font(.caption)
                    .italic()
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func scenarioAdviceCard(for scenario: Int) -> some View {
        let content = getScenarioContent(for: scenario)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(content.emoji)
                    .font(.title2)
                Text(content.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(content.color)
            }
            
            Text(content.description)
                .font(.body)
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(content.tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Text("💡")
                            .font(.caption)
                        Text(tip)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getScenarioContent(for scenario: Int) -> (title: String, emoji: String, description: String, tips: [String], color: Color) {
        switch scenario {
        case 0: // Airport Run
            return (
                title: "Airport Run",
                emoji: "✈️",
                description: "Getting to/from the airport efficiently and on time",
                tips: [
                    "Book Comfort or Business class for luggage space",
                    "Add 30-45 minutes buffer for traffic",
                    "Pre-book the night before for early flights",
                    "Airport pickup zones can be confusing - check terminal"
                ],
                color: .blue
            )
        case 1: // Daily Commute
            return (
                title: "Daily Commute",
                emoji: "🏢",
                description: "Making ride-hailing part of your regular routine",
                tips: [
                    "Use Economy class for cost-effectiveness",
                    "Set up regular routes to save time",
                    "Avoid peak hours if possible (8-9 AM, 6-7 PM)",
                    "Consider monthly transit passes if riding daily"
                ],
                color: .green
            )
        case 2: // Late Night
            return (
                title: "Late Night",
                emoji: "🌙",
                description: "Safe and reliable transportation after hours",
                tips: [
                    "Expect longer wait times and higher prices",
                    "Share trip details with friends for safety",
                    "Stay in well-lit areas while waiting",
                    "Have backup transportation apps installed"
                ],
                color: .purple
            )
        case 3: // Group Travel
            return (
                title: "Group Travel",
                emoji: "👥",
                description: "Moving multiple people efficiently",
                tips: [
                    "Look for 6-7 seat vehicles in luxury category",
                    "Split fare through app's sharing feature",
                    "Book slightly in advance for group vehicles",
                    "Have one person handle the booking and payment"
                ],
                color: .orange
            )
        default:
            return (title: "", emoji: "", description: "", tips: [], color: .gray)
        }
    }
    
    private func processStep(number: String, title: String, description: String, tip: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text(number)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("💡 \(tip)")
                    .font(.caption)
                    .italic()
                    .foregroundColor(color)
            }
            
            Spacer()
        }
    }
    
    private func costFactorCard(factor: String, amount: String, explanation: String) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 2) {
                Text(factor)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(explanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(amount)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
    }
}

struct RideHailingArticleView_Previews: PreviewProvider {
    static var previews: some View {
        RideHailingArticleView()
    }
}
