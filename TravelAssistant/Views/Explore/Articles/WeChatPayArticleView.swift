//
//  WeChatPayArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct WeChatPayArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProblem = 0
    @State private var expandedSolutions: Set<Int> = []
    
    let commonProblems = [
        "Can't register without Chinese phone",
        "Real-name verification failed",
        "Payment keeps getting declined",
        "App interface all in Chinese"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Problem-Solving Hero
                    VStack(spacing: 20) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.green, .mint]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(height: 200)
                            
                            VStack(spacing: 12) {
                                Text("🆘")
                                    .font(.system(size: 60))
                                
                                Text("WeChat Pay Problem Solver")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("Got stuck? We've got solutions for every WeChat Pay challenge")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                        }
                        
                        // Reality Check
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("Let's Be Honest")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("WeChat Pay can be frustrating to set up, especially for foreigners. But here's the thing - millions of tourists figure it out every year. The trick is knowing the common problems and their solutions. Let's solve yours!")
                                .font(.body)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Problem Selector
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("❓")
                                    .font(.title2)
                                Text("What's Your Problem?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Common Problem", selection: $selectedProblem) {
                                ForEach(0..<commonProblems.count, id: \.self) { index in
                                    Text(commonProblems[index])
                                        .tag(index)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(height: 120)
                            .clipped()
                            
                            problemSolutionCard(for: selectedProblem)
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(15)
                        
                        // Situation-Based Solutions
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("💡")
                                    .font(.title2)
                                Text("Solutions by Situation")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                situationCard(
                                    situation: "Tourist (Short Stay)",
                                    problems: ["No Chinese bank card", "Limited verification options", "Language barrier"],
                                    solutions: ["Use international credit card", "Find friend with Chinese number", "Download Google Translate"],
                                    workaround: "Use Alipay instead - more tourist-friendly",
                                    color: .blue
                                )
                                
                                situationCard(
                                    situation: "Student (Long Stay)",
                                    problems: ["Need Chinese bank account", "Complex verification", "Limited income verification"],
                                    solutions: ["Open bank account first", "Use student ID for verification", "Start with small amounts"],
                                    workaround: "Many student services accept campus card",
                                    color: .purple
                                )
                                
                                situationCard(
                                    situation: "Business Traveler",
                                    problems: ["Time constraints", "Need immediate access", "Frequent transactions"],
                                    solutions: ["Prepare documents beforehand", "Use expedited verification", "Set up during business hours"],
                                    workaround: "Business cards may have different requirements",
                                    color: .orange
                                )
                            }
                        }
                        
                        // Quick Fix Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("⚡")
                                    .font(.title2)
                                Text("Quick Fixes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                quickFixCard(
                                    problem: "Payment Failed",
                                    quickFix: "Check network → Try different card → Restart app",
                                    when: "Works 80% of the time"
                                )
                                
                                quickFixCard(
                                    problem: "Can't Scan QR",
                                    quickFix: "Clean camera lens → Check lighting → Move closer/farther",
                                    when: "Usually lighting issue"
                                )
                                
                                quickFixCard(
                                    problem: "Verification Code Delayed",
                                    quickFix: "Wait 60 seconds → Check SMS folder → Try calling number",
                                    when: "Peak hours cause delays"
                                )
                                
                                quickFixCard(
                                    problem: "Account Restricted",
                                    quickFix: "Don't panic → Contact support → Provide ID documents",
                                    when: "Usually resolved in 24 hours"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Advanced Troubleshooting
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🔧")
                                    .font(.title2)
                                Text("When Basic Fixes Don't Work")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                DisclosureGroup("Registration Problems") {
                                    advancedSolutionContent(type: .registration)
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
                                
                                DisclosureGroup("Payment Problems") {
                                    advancedSolutionContent(type: .payment)
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
                                
                                DisclosureGroup("Verification Problems") {
                                    advancedSolutionContent(type: .verification)
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
                                
                                DisclosureGroup("Technical Problems") {
                                    advancedSolutionContent(type: .technical)
                                }
                                .padding()
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
                            }
                        }
                        
                        // When All Else Fails
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🆘")
                                    .font(.title2)
                                Text("Last Resort Options")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                lastResortCard(
                                    option: "Ask a Local Friend",
                                    description: "Have them help with registration using their phone",
                                    pros: ["Usually works", "Local language support", "Fast solution"],
                                    cons: ["Need to find someone willing", "Privacy concerns"],
                                    riskLevel: "Low"
                                )
                                
                                lastResortCard(
                                    option: "Use Alternative Apps",
                                    description: "Switch to Alipay or international payment apps",
                                    pros: ["More foreigner-friendly", "Better English support", "Fewer restrictions"],
                                    cons: ["Not accepted everywhere", "Missing some features"],
                                    riskLevel: "None"
                                )
                                
                                lastResortCard(
                                    option: "Contact WeChat Support",
                                    description: "Official customer service through app or website",
                                    pros: ["Official solution", "Can resolve account issues", "Free support"],
                                    cons: ["Slow response", "Language barrier", "May require documentation"],
                                    riskLevel: "None"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Success Stories
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("🎉")
                                    .font(.title2)
                                Text("Success Stories")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                successStoryCard(
                                    story: "Failed verification 3 times, finally worked on 4th try with better lighting and removing glasses",
                                    tip: "Face recognition is picky - try different conditions"
                                )
                                
                                successStoryCard(
                                    story: "Couldn't register with US number, borrowed Chinese friend's phone for verification code",
                                    tip: "Social solution often works when technical solutions fail"
                                )
                                
                                successStoryCard(
                                    story: "Payment kept failing with international card, got Chinese bank card and everything worked",
                                    tip: "Sometimes the 'proper' solution is the only solution"
                                )
                            }
                        }
                        
                        // Bottom Line
                        VStack(spacing: 15) {
                            HStack {
                                Text("🎯")
                                    .font(.title2)
                                Text("The Bottom Line")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("WeChat Pay isn't impossible to set up as a foreigner, but it can be frustrating. Don't give up after the first failure. Most problems have solutions - it's just about finding the right approach for your specific situation. And remember, if all else fails, Alipay is usually more foreigner-friendly!")
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
            .navigationTitle("WeChat Pay SOS")
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
    
    // Problem Solution Views
    private func problemSolutionCard(for index: Int) -> some View {
        let solutions = [
            (
                problem: "Can't register without Chinese phone",
                causes: ["WeChat requires Chinese number for verification", "International numbers not always accepted", "SMS verification system is strict"],
                solutions: ["Ask Chinese friend to receive verification code", "Try multiple times - sometimes works on retry", "Use email registration if available", "Consider getting temporary Chinese SIM card"],
                preventive: "Get Chinese phone number or have local contact ready before starting"
            ),
            (
                problem: "Real-name verification failed",
                causes: ["Poor photo quality", "Name doesn't match exactly", "Face recognition lighting issues", "Document format not accepted"],
                solutions: ["Take passport photo in bright, even light", "Ensure name matches passport exactly", "Remove glasses for face scan", "Try verification during business hours"],
                preventive: "Prepare high-quality document photos before starting verification"
            ),
            (
                problem: "Payment keeps getting declined",
                causes: ["International card not supported", "Insufficient balance", "Network connectivity issues", "Daily limit reached"],
                solutions: ["Try different credit card", "Use Chinese bank card instead", "Check network connection", "Contact bank to enable international transactions"],
                preventive: "Set up Chinese bank card for best compatibility"
            ),
            (
                problem: "App interface all in Chinese",
                causes: ["Auto-detected location set to China", "Language settings need manual change", "App version doesn't support your language"],
                solutions: ["Go to Settings → Language → English", "Change phone system language temporarily", "Update app to latest version", "Use translation app alongside"],
                preventive: "Change language settings immediately after download"
            )
        ]
        
        let solution = solutions[index]
        
        return VStack(alignment: .leading, spacing: 15) {
            Text("❗ \(solution.problem)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Why this happens:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                ForEach(solution.causes, id: \.self) { cause in
                    Text("• \(cause)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Solutions to try:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                ForEach(solution.solutions, id: \.self) { fix in
                    Text("✅ \(fix)")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.orange)
                Text("Prevention: \(solution.preventive)")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .italic()
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
    
    // Helper Views
    private func situationCard(situation: String, problems: [String], solutions: [String], workaround: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("👤 \(situation)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Common Problems:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                
                ForEach(problems, id: \.self) { problem in
                    Text("• \(problem)")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Best Solutions:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                
                ForEach(solutions, id: \.self) { solution in
                    Text("• \(solution)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.blue)
                Text("Alternative: \(workaround)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .italic()
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func quickFixCard(problem: String, quickFix: String, when: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("⚡")
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(problem)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(quickFix)
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Text("💡 \(when)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    enum ProblemType {
        case registration, payment, verification, technical
    }
    
    @ViewBuilder
    private func advancedSolutionContent(type: ProblemType) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            switch type {
            case .registration:
                Text("• Try registering at different times of day")
                Text("• Use VPN to different locations")
                Text("• Clear app cache and restart")
                Text("• Try older version of the app")
                Text("• Register on web version first")
                
            case .payment:
                Text("• Contact your bank about international transactions")
                Text("• Enable 3D Secure on your card")
                Text("• Try adding card through Alipay first")
                Text("• Use different network (WiFi vs cellular)")
                Text("• Check if your card type is supported")
                
            case .verification:
                Text("• Try verification in well-lit area")
                Text("• Use different device/camera")
                Text("• Submit documents during business hours")
                Text("• Contact support with reference number")
                Text("• Try alternative document types")
                
            case .technical:
                Text("• Update to latest app version")
                Text("• Restart phone completely")
                Text("• Free up phone storage space")
                Text("• Check phone's date/time settings")
                Text("• Try different internet connection")
            }
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
    
    private func lastResortCard(option: String, description: String, pros: [String], cons: [String], riskLevel: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("🆘 \(option)")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text("Risk: \(riskLevel)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(riskLevel == "None" ? .green : riskLevel == "Low" ? .orange : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        (riskLevel == "None" ? Color.green : riskLevel == "Low" ? Color.orange : Color.red).opacity(0.2)
                    )
                    .cornerRadius(8)
            }
            
            Text(description)
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
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func successStoryCard(story: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("💬 \"\(story)\"")
                .font(.body)
                .italic()
                .foregroundColor(.secondary)
            
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text("Lesson: \(tip)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    WeChatPayArticleView()
}