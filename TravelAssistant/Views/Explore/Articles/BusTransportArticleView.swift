//
//  BusTransportArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct BusTransportArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFAQ = 0
    @State private var showingCityGuide = false
    
    let faqs = [
        "How do I know which bus to take?",
        "What if I get on the wrong bus?",
        "How do I pay for the bus?",
        "When should I get off?"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Problem-Solution Hero
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.orange, .red.opacity(0.8)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 180)
                            
                            VStack(spacing: 10) {
                                Text("🚌")
                                    .font(.system(size: 50))
                                
                                Text("Bus Travel Solved")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Your questions answered, your concerns addressed")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        
                        // Why Choose Bus Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.orange)
                                Text("Why bother with buses?")
                                    .font(.title3)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Good question! Here's the honest truth: buses aren't glamorous, but they're incredibly practical. For just $0.30-0.60 per ride, you can reach places that subways and taxis don't go. Plus, you'll see the city from street level and experience how most locals actually get around.")
                                .font(.body)
                                .padding()
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // FAQ Section with Interactive Picker
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("❓")
                                    .font(.title2)
                                Text("Common Questions")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("FAQ", selection: $selectedFAQ) {
                                ForEach(0..<faqs.count, id: \.self) { index in
                                    Text(faqs[index])
                                        .font(.caption)
                                        .tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 100)
                            .clipped()
                            
                            faqAnswerCard(for: selectedFAQ)
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(15)
                        
                        // Step-by-Step First Ride Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🚶‍♂️")
                                    .font(.title2)
                                Text("Your First Bus Ride")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("(Step by step)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 15) {
                                firstRideStep(
                                    number: "1️⃣",
                                    title: "Find Your Stop",
                                    description: "Look for the blue bus stop signs with route numbers",
                                    tips: ["Use Baidu Maps to find stops", "Ask locals - they're usually helpful"]
                                )
                                
                                firstRideStep(
                                    number: "2️⃣",
                                    title: "Check the Direction",
                                    description: "Make sure the bus goes toward your destination",
                                    tips: ["Check the final stop name", "Look at the route map"]
                                )
                                
                                firstRideStep(
                                    number: "3️⃣",
                                    title: "Board & Pay",
                                    description: "Enter through the front door, scan QR code or use card",
                                    tips: ["Have payment ready", "Don't block the door"]
                                )
                                
                                firstRideStep(
                                    number: "4️⃣",
                                    title: "Find a Spot",
                                    description: "Move toward the back, grab a handrail",
                                    tips: ["Offer seats to elderly", "Keep backpack in front"]
                                )
                                
                                firstRideStep(
                                    number: "5️⃣",
                                    title: "Know When to Exit",
                                    description: "Listen for announcements, watch for landmarks",
                                    tips: ["Press stop button if needed", "Exit from rear door"]
                                )
                            }
                        }
                        
                        // Payment Deep Dive
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💰")
                                    .font(.title2)
                                Text("Payment Methods Explained")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                paymentMethodCard(
                                    icon: "📱",
                                    title: "QR Code (Recommended)",
                                    howTo: "Open WeChat/Alipay → Transport → Scan when boarding",
                                    pros: ["Super convenient", "Automatic fare calculation", "No need for exact change"],
                                    cons: ["Needs internet", "Battery dependent"],
                                    difficulty: "Easy",
                                    color: .green
                                )
                                
                                paymentMethodCard(
                                    icon: "💳",
                                    title: "Transit Card",
                                    howTo: "Buy at subway stations → Top up → Tap on reader",
                                    pros: ["Works offline", "Faster boarding", "Discounts available"],
                                    cons: ["Need to buy/top up", "Easy to lose"],
                                    difficulty: "Easy",
                                    color: .blue
                                )
                                
                                paymentMethodCard(
                                    icon: "💵",
                                    title: "Cash (Last Resort)",
                                    howTo: "Exact change only → Drop coins in box",
                                    pros: ["Always works", "No setup needed"],
                                    cons: ["Need exact change", "Slower", "Less convenient"],
                                    difficulty: "Okay",
                                    color: .orange
                                )
                            }
                        }
                        
                        // Troubleshooting Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🔧")
                                    .font(.title2)
                                Text("When Things Go Wrong")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                troubleshootCard(
                                    problem: "Bus didn't come",
                                    solutions: ["Check if it's a holiday - schedules change", "Ask other waiting passengers", "Use backup transportation"],
                                    prevention: "Check real-time apps like Baidu Maps"
                                )
                                
                                troubleshootCard(
                                    problem: "Went past my stop",
                                    solutions: ["Don't panic - get off at next stop", "Cross the street and catch bus back", "Walk back (might be faster)"],
                                    prevention: "Set a phone alarm for estimated arrival time"
                                )
                                
                                troubleshootCard(
                                    problem: "Payment failed",
                                    solutions: ["Try again - sometimes readers are slow", "Use backup payment method", "Ask driver for help"],
                                    prevention: "Have multiple payment options ready"
                                )
                                
                                troubleshootCard(
                                    problem: "Bus is too crowded",
                                    solutions: ["Wait for next bus (usually 5-10 min)", "Consider alternate routes", "Travel at off-peak times"],
                                    prevention: "Avoid 8-9 AM and 5-7 PM rush hours"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.05))
                        .cornerRadius(15)
                        
                        // City-Specific Quick Tips
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🏙️")
                                    .font(.title2)
                                Text("City-Specific Tips")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Button("Show Details") {
                                    showingCityGuide.toggle()
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            if showingCityGuide {
                                VStack(spacing: 12) {
                                    cityTipCard(
                                        city: "Beijing",
                                        tip: "Bus routes have numbers like 1, 2, 300+ are express",
                                        quirk: "Some buses only run during peak hours",
                                        color: .red
                                    )
                                    
                                    cityTipCard(
                                        city: "Shanghai",
                                        tip: "Watch for the medium-capacity buses (longer buses)",
                                        quirk: "Some announcements in English, Japanese, Korean",
                                        color: .blue
                                    )
                                    
                                    cityTipCard(
                                        city: "Guangzhou",
                                        tip: "BRT system has dedicated lanes - much faster",
                                        quirk: "Some buses cross the Pearl River - great views!",
                                        color: .green
                                    )
                                    
                                    cityTipCard(
                                        city: "Shenzhen",
                                        tip: "All electric buses - super quiet and clean",
                                        quirk: "Many buses run 24/7 - check the schedule",
                                        color: .purple
                                    )
                                }
                            }
                        }
                        
                        // Etiquette in Simple Terms
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🤝")
                                    .font(.title2)
                                Text("Bus Etiquette 101")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                etiquetteItem(
                                    rule: "Let people off first",
                                    reason: "Makes boarding faster for everyone"
                                )
                                
                                etiquetteItem(
                                    rule: "Move to the back",
                                    reason: "More space for other passengers"
                                )
                                
                                etiquetteItem(
                                    rule: "Give up priority seats",
                                    reason: "It's the right thing to do"
                                )
                                
                                etiquetteItem(
                                    rule: "Keep voice down",
                                    reason: "Not everyone wants to hear your conversation"
                                )
                                
                                etiquetteItem(
                                    rule: "No eating strong-smelling food",
                                    reason: "Small space + strong odors = unhappy passengers"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.05))
                        .cornerRadius(15)
                        
                        // Final Encouragement
                        VStack(spacing: 15) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("Bottom Line")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Buses aren't perfect, but they're:")
                                    .font(.headline)
                                
                                HStack {
                                    Text("✅")
                                    Text("Cheap (often under $0.50)")
                                }
                                
                                HStack {
                                    Text("✅")
                                    Text("Go everywhere")
                                }
                                
                                HStack {
                                    Text("✅")
                                    Text("Run frequently")
                                }
                                
                                HStack {
                                    Text("✅")
                                    Text("A great way to see the city")
                                }
                                
                                Text("Don't expect luxury, but do expect to save money and get around effectively. Start with short trips during off-peak hours, and you'll be a bus pro in no time!")
                                    .font(.body)
                                    .italic()
                                    .padding(.top, 10)
                            }
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Bus Guide")
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
    private func faqAnswerCard(for index: Int) -> some View {
        let answers = [
            (
                question: "How do I know which bus to take?",
                answer: "Use Baidu Maps or Gaode Maps - they show exact bus routes and real-time arrival. Just enter your destination and they'll suggest bus options with walking directions to stops.",
                tip: "Screenshot the route on your phone so you don't need internet later"
            ),
            (
                question: "What if I get on the wrong bus?",
                answer: "Relax! Just get off at the next stop and catch a bus going the other direction. Chinese bus drivers are used to confused passengers and are generally patient.",
                tip: "Learn to say 'xiàchē' (下车) - it means 'getting off'"
            ),
            (
                question: "How do I pay for the bus?",
                answer: "QR codes are easiest - open WeChat or Alipay, find the transport section, and scan when you board. If that fails, use a transit card or exact change cash.",
                tip: "Always have a backup payment method ready"
            ),
            (
                question: "When should I get off?",
                answer: "Watch for landmarks, listen for stop announcements, or use GPS on your phone. Many buses also have digital displays showing upcoming stops.",
                tip: "Stand up and move toward the exit door before your stop"
            )
        ]
        
        let faq = answers[index]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(faq.question)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(faq.answer)
                .font(.body)
            
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text(faq.tip)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
            }
            .padding(.top, 5)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func firstRideStep(number: String, title: String, description: String, tips: [String]) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.title)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(tips, id: \.self) { tip in
                        HStack {
                            Text("💡")
                                .font(.caption)
                            Text(tip)
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func paymentMethodCard(icon: String, title: String, howTo: String, pros: [String], cons: [String], difficulty: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
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
            
            Text("How: \(howTo)")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    ForEach(pros, id: \.self) { pro in
                        Text("• \(pro)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Cons:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    ForEach(cons, id: \.self) { con in
                        Text("• \(con)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func troubleshootCard(problem: String, solutions: [String], prevention: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("❗ \(problem)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Solutions:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                ForEach(solutions, id: \.self) { solution in
                    Text("• \(solution)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                Image(systemName: "shield")
                    .foregroundColor(.blue)
                Text("Prevention: \(prevention)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .italic()
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func cityTipCard(city: String, tip: String, quirk: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(city)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text("Tip: \(tip)")
                .font(.body)
            
            Text("Quirk: \(quirk)")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func etiquetteItem(rule: String, reason: String) -> some View {
        HStack(spacing: 10) {
            Text("👍")
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(rule)
                    .font(.body)
                    .fontWeight(.medium)
                Text(reason)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    BusTransportArticleView()
}

