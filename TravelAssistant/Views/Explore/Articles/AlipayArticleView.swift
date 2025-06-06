//
//  AlipayArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct AlipayArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var completedSteps: Set<Int> = []
    @State private var showingDemo = false
    
    let setupSteps = [
        "Download & Register",
        "Verify Identity", 
        "Add Payment Method",
        "First Purchase",
        "Explore Features"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Step-by-Step Hero Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .cyan]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 220)
                        
                        VStack(spacing: 15) {
                            Text("📱")
                                .font(.system(size: 60))
                            
                            Text("Alipay Setup Tutorial")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Complete step-by-step guide to getting started")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                            
                            // Progress Indicator
                            HStack {
                                ForEach(0..<setupSteps.count, id: \.self) { index in
                                    Circle()
                                        .fill(index <= currentStep ? Color.white : Color.white.opacity(0.4))
                                        .frame(width: 12, height: 12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Step Navigator
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("Choose Your Starting Point")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Current Step", selection: $currentStep) {
                                ForEach(0..<setupSteps.count, id: \.self) { index in
                                    HStack {
                                        if completedSteps.contains(index) {
                                            Text("✅ \(setupSteps[index])")
                                        } else {
                                            Text("\(index + 1). \(setupSteps[index])")
                                        }
                                    }
                                    .tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            currentStepContent()
                        }
                        
                        // Quick Reference Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("📋")
                                    .font(.title2)
                                Text("Quick Reference")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Button("Show Demo") {
                                    showingDemo.toggle()
                                }
                                .font(.caption)
                                .foregroundColor(.blue)
                            }
                            
                            if showingDemo {
                                demoSection()
                            } else {
                                quickRefCards()
                            }
                        }
                        
                        // Why Choose Alipay Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💪")
                                    .font(.title2)
                                Text("Why Start with Alipay?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                advantageCard(
                                    icon: "🌍",
                                    title: "Foreigner-Friendly",
                                    description: "English support, international cards accepted",
                                    color: .blue
                                )
                                
                                advantageCard(
                                    icon: "🏪",
                                    title: "Wide Acceptance",
                                    description: "Most shops, restaurants, and services",
                                    color: .green
                                )
                                
                                advantageCard(
                                    icon: "💰",
                                    title: "Financial Services",
                                    description: "Investing, savings, insurance all-in-one",
                                    color: .purple
                                )
                                
                                advantageCard(
                                    icon: "🛒",
                                    title: "Shopping Integration",
                                    description: "Direct connection to Taobao and Tmall",
                                    color: .orange
                                )
                            }
                        }
                        
                        // Common Mistakes to Avoid
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("⚠️")
                                    .font(.title2)
                                Text("Avoid These Mistakes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                mistakeCard(
                                    mistake: "Using wrong name format",
                                    solution: "Use exact name as on passport - spelling and spaces matter!",
                                    icon: "📝"
                                )
                                
                                mistakeCard(
                                    mistake: "Skipping real-name verification",
                                    solution: "You'll need it for most features - do it early to save time",
                                    icon: "🆔"
                                )
                                
                                mistakeCard(
                                    mistake: "Only using one payment method",
                                    solution: "Add backup payment - some places only accept certain cards",
                                    icon: "💳"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Troubleshooting Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🔧")
                                    .font(.title2)
                                Text("If Something Goes Wrong")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                troubleshootItem(
                                    problem: "Can't receive verification code",
                                    solution: "Check phone number format (+86 for China), try again in 1 minute"
                                )
                                
                                troubleshootItem(
                                    problem: "Face verification keeps failing",
                                    solution: "Use good lighting, remove glasses, follow instructions slowly"
                                )
                                
                                troubleshootItem(
                                    problem: "International card not accepted",
                                    solution: "Try Visa or Mastercard, or get Chinese bank card for full features"
                                )
                                
                                troubleshootItem(
                                    problem: "App interface in Chinese",
                                    solution: "Settings → Language → English (may need to scroll down)"
                                )
                            }
                        }
                        
                        // Success Checklist
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎉")
                                    .font(.title2)
                                Text("Success Checklist")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                checklistItem(
                                    text: "Account created and verified",
                                    completed: completedSteps.contains(0) && completedSteps.contains(1)
                                )
                                
                                checklistItem(
                                    text: "Payment method added",
                                    completed: completedSteps.contains(2)
                                )
                                
                                checklistItem(
                                    text: "First successful purchase made",
                                    completed: completedSteps.contains(3)
                                )
                                
                                checklistItem(
                                    text: "Familiar with main features",
                                    completed: completedSteps.contains(4)
                                )
                            }
                            
                            if completedSteps.count == setupSteps.count {
                                Text("🎊 Congratulations! You're now an Alipay pro! Time to explore China with confidence.")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Alipay Tutorial")
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
    
    // Step Content Views
    @ViewBuilder
    private func currentStepContent() -> some View {
        switch currentStep {
        case 0:
            stepCard(
                title: "Download & Register",
                content: [
                    "📱 Download 'Alipay' app (blue icon) from App Store",
                    "🌍 Select your country/region during setup",
                    "📞 Enter phone number (Chinese number recommended)",
                    "✉️ Add email as backup verification method",
                    "🔐 Create strong password (mix letters, numbers, symbols)"
                ],
                tips: [
                    "Use your international phone number if no Chinese number",
                    "Write down your password - you'll need it often",
                    "Enable notifications to stay updated"
                ],
                timeEstimate: "5-10 minutes"
            )
            
        case 1:
            stepCard(
                title: "Verify Identity",
                content: [
                    "🆔 Go to 'Me' → 'Account Security' → 'Real-name Verification'",
                    "📝 Enter real name exactly as on passport",
                    "📸 Upload clear passport photo (all corners visible)",
                    "👤 Complete face recognition (good lighting needed)",
                    "⏳ Wait for approval (usually 1-24 hours)"
                ],
                tips: [
                    "Name must match passport exactly - check spelling",
                    "Use bright, even lighting for face scan",
                    "Keep passport flat when photographing"
                ],
                timeEstimate: "10-15 minutes + waiting"
            )
            
        case 2:
            stepCard(
                title: "Add Payment Method",
                content: [
                    "💳 Go to 'Me' → 'Wallet' → 'Bank Cards'",
                    "➕ Tap 'Add Bank Card'",
                    "🔢 Enter card number and details",
                    "📱 Verify with SMS code",
                    "✅ Set as default payment method"
                ],
                tips: [
                    "Chinese bank cards work best for full features",
                    "International Visa/Mastercard also accepted",
                    "Add multiple cards as backup options"
                ],
                timeEstimate: "5 minutes per card"
            )
            
        case 3:
            stepCard(
                title: "Make First Purchase",
                content: [
                    "🛒 Find a shop with Alipay QR code",
                    "📱 Open Alipay → 'Scan' (top right)",
                    "📷 Point camera at merchant's QR code",
                    "💰 Enter payment amount",
                    "🔐 Confirm with password or biometric"
                ],
                tips: [
                    "Start with small amount for first test",
                    "Check amount twice before confirming",
                    "Listen for 'payment received' confirmation"
                ],
                timeEstimate: "2-3 minutes"
            )
            
        case 4:
            stepCard(
                title: "Explore Features",
                content: [
                    "🏠 Browse homepage mini-programs",
                    "🚇 Set up transport payment (subway/bus)",
                    "📊 Check Yu'e Bao for savings",
                    "🎯 Explore city services in your area",
                    "📱 Add payment shortcut to phone home screen"
                ],
                tips: [
                    "Don't feel pressured to use everything at once",
                    "Focus on transportation and shopping first",
                    "Ask locals about popular local services"
                ],
                timeEstimate: "Ongoing exploration"
            )
            
        default:
            EmptyView()
        }
    }
    
    private func stepCard(title: String, content: [String], tips: [String], timeEstimate: String) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("⏱️ \(timeEstimate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content, id: \.self) { item in
                    Text(item)
                        .font(.body)
                }
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("💡 Pro Tips:")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                ForEach(tips, id: \.self) { tip in
                    Text("• \(tip)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            Button(action: {
                withAnimation {
                    completedSteps.insert(currentStep)
                    if currentStep < setupSteps.count - 1 {
                        currentStep += 1
                    }
                }
            }) {
                Text(completedSteps.contains(currentStep) ? "✅ Completed" : "Mark as Complete")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(completedSteps.contains(currentStep) ? Color.green : Color.blue)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(15)
    }
    
    private func quickRefCards() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            quickRefCard(
                icon: "📱",
                title: "Payment Code",
                desc: "Me → Pay → Show barcode"
            )
            
            quickRefCard(
                icon: "📷",
                title: "Scan QR",
                desc: "Homepage → Scan button (top right)"
            )
            
            quickRefCard(
                icon: "💰",
                title: "Check Balance",
                desc: "Me → Wallet → Account Balance"
            )
            
            quickRefCard(
                icon: "📋",
                title: "Transaction History",
                desc: "Me → Wallet → Transaction Records"
            )
        }
    }
    
    private func demoSection() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎬 Payment Demo")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("1. 📱 Open Alipay app")
                Text("2. 📷 Tap 'Scan' at top right")
                Text("3. 🎯 Point camera at QR code")
                Text("4. 💰 Enter amount (¥50)")
                Text("5. 🔐 Confirm with password")
                Text("6. ✅ Wait for confirmation sound")
            }
            .font(.body)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    // Helper Views
    private func quickRefCard(icon: String, title: String, desc: String) -> some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title)
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
            Text(desc)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
        .frame(height: 90)
    }
    
    private func advantageCard(icon: String, title: String, description: String, color: Color) -> some View {
        VStack(spacing: 10) {
            Text(icon)
                .font(.title)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .frame(height: 110)
    }
    
    private func mistakeCard(mistake: String, solution: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("❌ \(mistake)")
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("✅ \(solution)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func troubleshootItem(problem: String, solution: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("❗ \(problem)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.red)
            
            Text("💡 \(solution)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func checklistItem(text: String, completed: Bool) -> some View {
        HStack {
            Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(completed ? .green : .gray)
            
            Text(text)
                .font(.body)
                .strikethrough(completed)
                .foregroundColor(completed ? .secondary : .primary)
            
            Spacer()
        }
    }
}

#Preview {
    AlipayArticleView()
}