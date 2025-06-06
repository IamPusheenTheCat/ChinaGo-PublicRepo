//
//  SubwayArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct SubwayArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCity = 0
    @State private var showingScenario = 0
    
    let cities = ["Beijing", "Shanghai", "Guangzhou", "Shenzhen"]
    let scenarios = ["First Time", "Rush Hour", "Late Night", "With Luggage"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Casual Hero Section
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.green, .teal]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 200)
                            
                            VStack(spacing: 12) {
                                Text("🚇")
                                    .font(.system(size: 60))
                                
                                Text("Subway Like a Local")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Master China's subway systems and never get lost again")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                            }
                        }
                        
                        // Reality Check Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💡")
                                    .font(.title2)
                                Text("Real Talk")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Yes, Chinese subways can be overwhelming at first. But here's the thing - once you get the hang of it, they're actually super efficient and way cheaper than taxis. Plus, you'll feel like a total pro navigating underground like locals do!")
                                .font(.body)
                                .italic()
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // City Picker with Different Vibes
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🏙️")
                                    .font(.title2)
                                Text("Pick Your City")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("(They're all different!)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("City", selection: $selectedCity) {
                                ForEach(0..<cities.count, id: \.self) { index in
                                    Text(cities[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            cityVibeCard(for: selectedCity)
                        }
                        
                        // Scenario-Based Learning
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎭")
                                    .font(.title2)
                                Text("Common Scenarios")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Scenario", selection: $showingScenario) {
                                ForEach(0..<scenarios.count, id: \.self) { index in
                                    Text(scenarios[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            scenarioCard(for: showingScenario)
                        }
                        
                        // Payment Methods (Simplified & Visual)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💳")
                                    .font(.title2)
                                Text("How to Pay")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("(Super easy once you know)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                paymentOption(
                                    emoji: "📱",
                                    method: "Phone Payment",
                                    pros: "One-tap convenience",
                                    cons: "Need internet",
                                    difficulty: "Easy",
                                    color: .blue
                                )
                                
                                paymentOption(
                                    emoji: "💳",
                                    method: "Transit Card",
                                    pros: "Works offline",
                                    cons: "Need to top up",
                                    difficulty: "Easy",
                                    color: .green
                                )
                                
                                paymentOption(
                                    emoji: "🎫",
                                    method: "Single Tickets",
                                    pros: "No setup needed",
                                    cons: "Slower, more expensive",
                                    difficulty: "Okay",
                                    color: .orange
                                )
                            }
                        }
                        
                        // Subway Etiquette (Fun Way)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🤝")
                                    .font(.title2)
                                Text("Don't Be 'That' Tourist")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                etiquetteRule(
                                    do: "Stand right, walk left on escalators",
                                    dont: "Block the left side",
                                    why: "Locals are in a hurry!"
                                )
                                
                                etiquetteRule(
                                    do: "Let people off first",
                                    dont: "Push onto the train immediately",
                                    why: "You'll get on faster this way"
                                )
                                
                                etiquetteRule(
                                    do: "Move to the center",
                                    dont: "Stand by the doors",
                                    why: "More space for everyone"
                                )
                                
                                etiquetteRule(
                                    do: "Give up priority seats",
                                    dont: "Pretend you don't see elderly folks",
                                    why: "Basic human decency"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Navigation Hacks
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🧭")
                                    .font(.title2)
                                Text("Pro Navigation Hacks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                hackCard(
                                    hack: "Download offline maps",
                                    reason: "Cell service can be spotty underground",
                                    icon: "map"
                                )
                                
                                hackCard(
                                    hack: "Screenshot your route",
                                    reason: "Faster than constantly opening apps",
                                    icon: "camera"
                                )
                                
                                hackCard(
                                    hack: "Learn exit numbers",
                                    reason: "Different exits can be blocks apart",
                                    icon: "arrow.up.right.square"
                                )
                                
                                hackCard(
                                    hack: "Use landmarks, not just station names",
                                    reason: "Easier to remember and ask for help",
                                    icon: "building.2"
                                )
                            }
                        }
                        
                        // Time-Based Tips
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("⏰")
                                    .font(.title2)
                                Text("Timing is Everything")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🌅 6-9 AM")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                    Text("Rush hour madness")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("• Packed trains")
                                    Text("• Longer waits")
                                    Text("• Stressed commuters")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🌞 10-4 PM")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    Text("Sweet spot")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("• Comfortable rides")
                                    Text("• Shorter waits")
                                    Text("• Happy tourists")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🌆 5-8 PM")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    Text("Rush hour again")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("• Even more packed")
                                    Text("• Everyone's tired")
                                    Text("• Avoid if possible")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🌙 After 9 PM")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text("Chill vibes")
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("• Spacious trains")
                                    Text("• Relaxed atmosphere")
                                    Text("• Check last train!")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(20)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Emergency Situations
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🚨")
                                    .font(.title2)
                                Text("When Things Go Wrong")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                emergencyCard(
                                    situation: "Got on wrong direction",
                                    solution: "Don't panic! Get off at next station and cross platform",
                                    tip: "Look for '反向' signs"
                                )
                                
                                emergencyCard(
                                    situation: "Missed last train",
                                    solution: "Use ride-hailing apps or find night bus routes",
                                    tip: "Last trains usually around 11 PM"
                                )
                                
                                emergencyCard(
                                    situation: "Lost or confused",
                                    solution: "Find subway staff in blue uniforms - they're super helpful",
                                    tip: "Show them your destination on your phone"
                                )
                            }
                        }
                        
                        // Bottom Encouragement
                        VStack(spacing: 15) {
                            HStack {
                                Text("🎉")
                                    .font(.title2)
                                Text("You've Got This!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Remember, millions of people use these systems daily without issues. Yes, it might feel overwhelming at first, but you'll be zipping around like a local in no time. Start with shorter trips, be patient with yourself, and don't be afraid to ask for help. Chinese people are generally very kind to confused tourists! 🚇✨")
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
            .navigationTitle("Subway Guide")
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
    private func cityVibeCard(for index: Int) -> some View {
        let cityData = [
            (name: "Beijing", vibe: "Historic & Massive", tip: "Lines are numbered, super logical", color: Color.red),
            (name: "Shanghai", vibe: "Modern & Efficient", tip: "English announcements everywhere", color: Color.blue),
            (name: "Guangzhou", vibe: "Practical & Clean", tip: "Great connections to Hong Kong", color: Color.green),
            (name: "Shenzhen", vibe: "Tech-forward & Fast", tip: "Most digital-friendly system", color: Color.purple)
        ]
        
        let city = cityData[index]
        
        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(city.name)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(city.vibe)
                    .font(.subheadline)
                    .foregroundColor(city.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(city.color.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text("💡 \(city.tip)")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(city.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func scenarioCard(for index: Int) -> some View {
        let scenarios = [
            (title: "First Time Riding", content: "Take your time, follow the crowd, and don't stress about looking touristy. Everyone was new once!", tips: ["Start with short trips", "Follow other passengers", "Ask station staff for help"]),
            (title: "Rush Hour Survival", content: "It's going to be crowded. Really crowded. But everyone's in the same boat!", tips: ["Board quickly but politely", "Move to center of car", "Be patient"]),
            (title: "Late Night Travel", content: "Quieter and more relaxed, but check those last train times!", tips: ["Verify last train schedule", "Download backup transport apps", "Stay aware of surroundings"]),
            (title: "Traveling with Luggage", content: "Totally doable, just need to be smart about timing and positioning.", tips: ["Avoid rush hours", "Use elevators, not escalators", "Stand by doors for easy exit"])
        ]
        
        let scenario = scenarios[index]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(scenario.title)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(scenario.content)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Quick Tips:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                ForEach(scenario.tips, id: \.self) { tip in
                    HStack {
                        Text("•")
                            .foregroundColor(.blue)
                        Text(tip)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func paymentOption(emoji: String, method: String, pros: String, cons: String, difficulty: String, color: Color) -> some View {
        HStack(spacing: 15) {
            Text(emoji)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(method)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                HStack {
                    Text("✅ \(pros)")
                        .font(.caption)
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text("❌ \(cons)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
            
            Text(difficulty)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color)
                .cornerRadius(8)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func etiquetteRule(do doThis: String, dont dontThis: String, why: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("✅ DO:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text(doThis)
                    .font(.caption)
            }
            
            HStack {
                Text("❌ DON'T:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text(dontThis)
                    .font(.caption)
            }
            
            HStack {
                Text("💭 WHY:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Text(why)
                    .font(.caption)
                    .italic()
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(8)
    }
    
    private func hackCard(hack: String, reason: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.orange)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hack)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(reason)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func emergencyCard(situation: String, solution: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("😰 \(situation)")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("💡 \(solution)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("🎯 Pro tip: \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    SubwayArticleView()
}