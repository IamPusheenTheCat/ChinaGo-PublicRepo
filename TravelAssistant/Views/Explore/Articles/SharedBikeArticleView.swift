//
//  SharedBikeArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct SharedBikeArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedApp = 0
    @State private var selectedIssue = 0
    
    let apps = ["Meituan", "Hellobike", "Qingju"]
    let commonIssues = ["Can't Unlock", "Bike Problems", "Payment Failed", "Parking Issues"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Quick Action Hero
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.green, .mint]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "bicycle")
                                .font(.system(size: 45))
                                .foregroundColor(.white)
                            
                            Text("Shared Bikes Made Simple")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Quick guides • Problem solving • Pro tips")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 30-Second Quick Start
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(.orange)
                                Text("30-Second Quick Start")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                quickStepCard(
                                    step: "1",
                                    action: "Spot a bike",
                                    detail: "Look for orange, blue, or green bikes with QR codes",
                                    time: "5 sec",
                                    color: .blue
                                )
                                
                                quickStepCard(
                                    step: "2",
                                    action: "Open any app",
                                    detail: "Meituan, Hellobike, or Qingju - they all work similarly",
                                    time: "5 sec",
                                    color: .green
                                )
                                
                                quickStepCard(
                                    step: "3",
                                    action: "Scan QR code",
                                    detail: "Point at the code on the handlebars - wait for beep",
                                    time: "10 sec",
                                    color: .orange
                                )
                                
                                quickStepCard(
                                    step: "4",
                                    action: "Ride away!",
                                    detail: "Adjust seat if needed, check brakes, and go",
                                    time: "10 sec",
                                    color: .purple
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // App Comparison (Simplified)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "apps.iphone")
                                    .foregroundColor(.blue)
                                Text("Choose Your App")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("(They're all pretty similar)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("App", selection: $selectedApp) {
                                ForEach(0..<apps.count, id: \.self) { index in
                                    Text(apps[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            appQuickCompare(for: selectedApp)
                        }
                        
                        // Smart Parking Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "parkingsign")
                                    .foregroundColor(.green)
                                Text("Smart Parking")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("(Avoid fees & fines)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                parkingGuideCard(
                                    type: "✅ Good Spots",
                                    locations: ["White-lined bike areas", "Near subway exits", "Mall entrances", "Bus stops"],
                                    color: .green
                                )
                                
                                parkingGuideCard(
                                    type: "🚫 Avoid These",
                                    locations: ["Red zones in app", "Crosswalks", "Building entrances", "Narrow sidewalks"],
                                    color: .red
                                )
                            }
                            
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Pro Tip: Check the app before parking - it shows no-parking zones in real-time!")
                                    .font(.callout)
                                    .italic()
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        // Troubleshooting Center
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "wrench.and.screwdriver.fill")
                                    .foregroundColor(.red)
                                Text("Troubleshooting Center")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Common Issue", selection: $selectedIssue) {
                                ForEach(0..<commonIssues.count, id: \.self) { index in
                                    Text(commonIssues[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            troubleshootingCard(for: selectedIssue)
                        }
                        
                        // Safety Checklist
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.shield.fill")
                                    .foregroundColor(.blue)
                                Text("Quick Safety Check")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                safetyCheckItem(
                                    check: "🚲 Test the brakes",
                                    why: "Gently squeeze - should respond smoothly"
                                )
                                
                                safetyCheckItem(
                                    check: "💺 Adjust the seat",
                                    why: "Your toes should just touch the ground"
                                )
                                
                                safetyCheckItem(
                                    check: "🔔 Try the bell",
                                    why: "You'll need it to alert pedestrians"
                                )
                                
                                safetyCheckItem(
                                    check: "🛞 Check the tires",
                                    why: "Don't ride with obviously flat tires"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Riding Etiquette (Simple Version)
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                                Text("Be a Good Rider")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 8) {
                                Text("🛣️ Stay in bike lanes (the painted ones)")
                                Text("🚦 Stop at red lights (yes, even on bikes)")
                                Text("🚶 Slow down around pedestrians")
                                Text("🎧 Skip the headphones - you need to hear traffic")
                                Text("🌙 Use the bike's light at night (button on handlebars)")
                            }
                            .font(.body)
                        }
                        
                        // Money-Saving Hacks
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                Text("Money-Saving Hacks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                moneySavingTip(
                                    icon: "📱",
                                    tip: "Get monthly passes",
                                    savings: "Save 50%+ for daily riders"
                                )
                                
                                moneySavingTip(
                                    icon: "🎁",
                                    tip: "Use new user promotions",
                                    savings: "Often get 10+ free rides"
                                )
                                
                                moneySavingTip(
                                    icon: "⭐",
                                    tip: "Build credit score",
                                    savings: "Unlock deposit-free riding"
                                )
                                
                                moneySavingTip(
                                    icon: "📍",
                                    tip: "Park in designated areas",
                                    savings: "Avoid $3-8 relocation fees"
                                )
                            }
                        }
                        
                        // When Things Go Wrong
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("When Things Go Wrong")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                emergencyCard(
                                    situation: "Bike breaks down while riding",
                                    action: "Park safely, end trip in app, find another bike"
                                )
                                
                                emergencyCard(
                                    situation: "Got charged for someone else's ride",
                                    action: "Screenshot your trip history, contact customer service"
                                )
                                
                                emergencyCard(
                                    situation: "Bike stolen while you're using it",
                                    action: "Report to police (110) and the app immediately"
                                )
                                
                                emergencyCard(
                                    situation: "Accident or injury",
                                    action: "Call 120 (ambulance) or 110 (police) if serious"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Final Encouragement
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "bicycle")
                                    .foregroundColor(.green)
                                Text("You're Ready to Ride!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Shared bikes are honestly one of the best ways to explore Chinese cities. They're cheap, fun, and give you freedom to stop anywhere. Don't overthink it - just scan and go! 🚲")
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
            .navigationTitle("Shared Bikes")
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
    private func quickStepCard(step: String, action: String, detail: String, time: String, color: Color) -> some View {
        HStack(spacing: 15) {
            VStack {
                Text(step)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
                    .background(color)
                    .clipShape(Circle())
                
                Text(time)
                    .font(.caption)
                    .foregroundColor(color)
                    .fontWeight(.medium)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(action)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(detail)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func appQuickCompare(for app: Int) -> some View {
        let content = getAppContent(for: app)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(content.emoji)
                    .font(.title2)
                Text(content.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(content.color)
                Spacer()
                Text(content.price)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(content.color)
            }
            
            Text(content.bestFor)
                .font(.body)
                .italic()
            
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("✅ Good stuff:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    ForEach(content.pros, id: \.self) { pro in
                        Text("• \(pro)")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("⚠️ Watch out:")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                    
                    ForEach(content.cons, id: \.self) { con in
                        Text("• \(con)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getAppContent(for app: Int) -> (name: String, emoji: String, price: String, bestFor: String, pros: [String], cons: [String], color: Color) {
        switch app {
        case 0: // Meituan
            return (
                name: "Meituan Bike",
                emoji: "🟡",
                price: "$0.15/15min",
                bestFor: "Best overall choice - reliable and widely available",
                pros: ["Most bikes available", "Good bike condition", "Easy to use"],
                cons: ["Slightly more expensive", "Popular = busy"],
                color: .yellow
            )
        case 1: // Hellobike
            return (
                name: "Hellobike",
                emoji: "🔵",
                price: "$0.10/15min",
                bestFor: "Budget riders and those with good credit scores",
                pros: ["Cheapest option", "No deposit with good credit", "E-bikes available"],
                cons: ["Fewer bikes in some areas", "App in Chinese"],
                color: .blue
            )
        case 2: // Qingju
            return (
                name: "Qingju (Didi)",
                emoji: "🟢",
                price: "$0.12/15min",
                bestFor: "Didi users and those wanting integrated transport",
                pros: ["Good coverage", "Integrates with Didi app", "24/7 support"],
                cons: ["Newer, fewer bikes", "Limited promotions"],
                color: .green
            )
        default:
            return (name: "", emoji: "", price: "", bestFor: "", pros: [], cons: [], color: .gray)
        }
    }
    
    private func parkingGuideCard(type: String, locations: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(type)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(locations, id: \.self) { location in
                    Text("• \(location)")
                        .font(.body)
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func troubleshootingCard(for issue: Int) -> some View {
        let content = getTroubleshootingContent(for: issue)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(content.emoji)
                    .font(.title2)
                Text(content.problem)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Quick fixes:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                ForEach(content.solutions, id: \.self) { solution in
                    HStack(alignment: .top, spacing: 8) {
                        Text("💡")
                            .font(.caption)
                        Text(solution)
                            .font(.body)
                    }
                }
            }
            
            if !content.prevention.isEmpty {
                Text("Prevent this: \(content.prevention)")
                    .font(.callout)
                    .italic()
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getTroubleshootingContent(for issue: Int) -> (problem: String, emoji: String, solutions: [String], prevention: String) {
        switch issue {
        case 0: // Can't Unlock
            return (
                problem: "Can't Unlock the Bike",
                emoji: "🔒",
                solutions: [
                    "Check your internet connection",
                    "Try scanning a different QR code on the bike",
                    "Force close and reopen the app",
                    "Try a different bike nearby"
                ],
                prevention: "Make sure your phone has good signal before scanning"
            )
        case 1: // Bike Problems
            return (
                problem: "Bike Has Issues",
                emoji: "🚲",
                solutions: [
                    "Don't try to fix it yourself - safety first",
                    "Park the bike safely and end your trip",
                    "Report the issue in the app for others",
                    "Find another bike nearby"
                ],
                prevention: "Do a quick safety check before riding"
            )
        case 2: // Payment Failed
            return (
                problem: "Payment Failed",
                emoji: "💳",
                solutions: [
                    "Check if your payment method is still valid",
                    "Try a different payment method",
                    "Contact customer service through the app",
                    "Sometimes it's just a temporary glitch - try again"
                ],
                prevention: "Keep multiple payment methods linked to your account"
            )
        case 3: // Parking Issues
            return (
                problem: "Parking Violations",
                emoji: "🚫",
                solutions: [
                    "Always check the app for red zones before parking",
                    "If you get a fine, contest it through customer service",
                    "Take photos of where you parked as evidence",
                    "Move the bike to a proper area if asked"
                ],
                prevention: "When in doubt, park near other shared bikes"
            )
        default:
            return (problem: "", emoji: "", solutions: [], prevention: "")
        }
    }
    
    private func safetyCheckItem(check: String, why: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(check)
                .font(.body)
                .fontWeight(.medium)
            
            Spacer()
            
            Text(why)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding(.vertical, 5)
    }
    
    private func moneySavingTip(icon: String, tip: String, savings: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tip)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(savings)
                    .font(.caption)
                    .foregroundColor(.green)
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func emergencyCard(situation: String, action: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⚠️ \(situation)")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Text("→ \(action)")
                .font(.body)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}

struct SharedBikeArticleView_Previews: PreviewProvider {
    static var previews: some View {
        SharedBikeArticleView()
    }
}