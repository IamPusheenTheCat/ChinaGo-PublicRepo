//
//  BankCardArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct BankCardArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBank = 0
    @State private var selectedVisaType = 0
    @State private var selectedIssue = 0
    
    let banks = ["ICBC", "Bank of China", "China Construction Bank", "China Merchants Bank"]
    let visaTypes = ["Tourist", "Work", "Student", "Business"]
    let commonIssues = ["Application Rejected", "Card Not Working", "Fees Too High", "Account Frozen"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Professional Hero Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.blue, .indigo]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 220)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            
                            Text("Chinese Bank Cards Mastery")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("From application to smart usage - your complete guide")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Why You Need a Chinese Bank Card
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Why Get a Chinese Bank Card?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                reasonCard(
                                    icon: "🏠",
                                    title: "Essential Life Services",
                                    description: "Rent, utilities, salary deposits, and large purchases",
                                    importance: "Critical"
                                )
                                
                                reasonCard(
                                    icon: "💼",
                                    title: "Work & Investment",
                                    description: "Salary accounts, investment products, and business transactions",
                                    importance: "Important"
                                )
                                
                                reasonCard(
                                    icon: "🔗",
                                    title: "Payment Integration",
                                    description: "Link to WeChat Pay, Alipay for seamless daily transactions",
                                    importance: "Convenient"
                                )
                                
                                reasonCard(
                                    icon: "🌏",
                                    title: "International Access",
                                    description: "Global ATM access and overseas money transfers",
                                    importance: "Flexible"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(15)
                        
                        // Bank Selection Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "building.columns.fill")
                                    .foregroundColor(.green)
                                Text("Choose Your Bank")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("- They're not all the same")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Bank", selection: $selectedBank) {
                                ForEach(0..<banks.count, id: \.self) { index in
                                    Text(banks[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            bankComparisonCard(for: selectedBank)
                        }
                        
                        // Visa-Based Requirements
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.purple)
                                Text("Know Your Requirements")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Visa Type", selection: $selectedVisaType) {
                                ForEach(0..<visaTypes.count, id: \.self) { index in
                                    Text(visaTypes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            visaRequirementsCard(for: selectedVisaType)
                        }
                        
                        // Application Process
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "list.number")
                                    .foregroundColor(.orange)
                                Text("The Application Process")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                applicationStep(
                                    number: "1",
                                    title: "Prepare Documents",
                                    description: "Passport, visa, residence proof, phone number",
                                    tip: "Make copies beforehand - saves time at the bank",
                                    color: .blue
                                )
                                
                                applicationStep(
                                    number: "2",
                                    title: "Choose the Right Branch",
                                    description: "City center branches are more foreigner-friendly",
                                    tip: "Call ahead to confirm they serve foreign customers",
                                    color: .green
                                )
                                
                                applicationStep(
                                    number: "3",
                                    title: "Visit During Off-Peak Hours",
                                    description: "Before 10 AM or after 3 PM for shorter waits",
                                    tip: "Bring cash for fees and initial deposit",
                                    color: .orange
                                )
                                
                                applicationStep(
                                    number: "4",
                                    title: "Complete the Process",
                                    description: "Forms, photos, PIN setup, and app download",
                                    tip: "Set up mobile banking immediately - you'll need it",
                                    color: .purple
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Smart Usage Tips
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.cyan)
                                Text("Smart Usage Strategies")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                usageTipCard(
                                    category: "ATM Strategy",
                                    tips: ["Use your own bank's ATMs to avoid fees", "Daily limit is usually ¥20,000", "Cover PIN when entering"],
                                    icon: "🏧",
                                    color: .blue
                                )
                                
                                usageTipCard(
                                    category: "Fee Avoidance",
                                    tips: ["Use card 6 times annually to waive next year's fee", "Keep ¥500+ balance to avoid account fees", "Use online banking instead of counter service"],
                                    icon: "💰",
                                    color: .green
                                )
                                
                                usageTipCard(
                                    category: "Integration Setup",
                                    tips: ["Link to WeChat Pay and Alipay", "Set up automatic bill payments", "Enable SMS alerts for transactions"],
                                    icon: "🔗",
                                    color: .purple
                                )
                            }
                        }
                        
                        // Security Best Practices
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "shield.checkered")
                                    .foregroundColor(.red)
                                Text("Security Essentials")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            HStack(alignment: .top, spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🔐 Password Safety")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    
                                    Text("• Use unique 6-digit PIN")
                                    Text("• Avoid birthdays or phone numbers")
                                    Text("• Change every 3-6 months")
                                    Text("• Cover keypad when entering")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🚨 Emergency Actions")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    
                                    Text("• Report lost cards immediately")
                                    Text("• Keep bank hotline numbers saved")
                                    Text("• Monitor statements regularly")
                                    Text("• Never share PIN with anyone")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Fee Breakdown
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                Text("Understanding Fees")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                feeBreakdownCard(
                                    feeType: "Annual Fee",
                                    amount: "¥10-200",
                                    avoidable: true,
                                    howToAvoid: "Use card 6+ times per year"
                                )
                                
                                feeBreakdownCard(
                                    feeType: "ATM Withdrawal (Other Banks)",
                                    amount: "¥2-4",
                                    avoidable: true,
                                    howToAvoid: "Use your own bank's ATMs"
                                )
                                
                                feeBreakdownCard(
                                    feeType: "Account Maintenance",
                                    amount: "¥3-10/month",
                                    avoidable: true,
                                    howToAvoid: "Maintain ¥500+ balance"
                                )
                                
                                feeBreakdownCard(
                                    feeType: "SMS Alerts",
                                    amount: "¥2-5/month",
                                    avoidable: false,
                                    howToAvoid: "Worth the security"
                                )
                            }
                        }
                        
                        // Troubleshooting
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "wrench.and.screwdriver.fill")
                                    .foregroundColor(.yellow)
                                Text("Common Issues & Solutions")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Issue Type", selection: $selectedIssue) {
                                ForEach(0..<commonIssues.count, id: \.self) { index in
                                    Text(commonIssues[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            troubleshootingCard(for: selectedIssue)
                        }
                        
                        // Leaving China Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "airplane.departure")
                                    .foregroundColor(.orange)
                                Text("Planning to Leave China?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                departureOptionCard(
                                    scenario: "Temporary Leave",
                                    duration: "Vacation, business trip",
                                    recommendation: "Keep account active",
                                    benefits: ["Global ATM access", "Easy return setup", "Investment continuity"]
                                )
                                
                                departureOptionCard(
                                    scenario: "Permanent Departure",
                                    duration: "End of work/study",
                                    recommendation: "Close unnecessary accounts",
                                    benefits: ["Avoid dormant fees", "Clean credit record", "Simplified finances"]
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Final Recommendations
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                                Text("Pro Recommendations")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Start with Bank of China or ICBC for the most foreigner-friendly experience. Get mobile banking set up immediately, link to WeChat/Alipay, and use your card regularly to avoid fees. Most importantly, treat it as a tool for integration, not just transactions! 💳")
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
            .navigationTitle("Bank Cards")
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
    private func reasonCard(icon: String, title: String, description: String, importance: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(importance)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(getImportanceColor(importance))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(getImportanceColor(importance).opacity(0.2))
                        .cornerRadius(8)
                }
                
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
    
    private func getImportanceColor(_ importance: String) -> Color {
        switch importance {
        case "Critical": return .red
        case "Important": return .orange
        case "Convenient": return .blue
        case "Flexible": return .green
        default: return .gray
        }
    }
    
    private func bankComparisonCard(for bank: Int) -> some View {
        let content = getBankContent(for: bank)
        
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
            
            Text(content.speciality)
                .font(.body)
                .italic()
                .foregroundColor(.secondary)
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("✅ Best For")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    ForEach(content.strengths, id: \.self) { strength in
                        Text("• \(strength)")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("⚠️ Consider")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                    
                    ForEach(content.considerations, id: \.self) { consideration in
                        Text("• \(consideration)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getBankContent(for bank: Int) -> (name: String, emoji: String, speciality: String, strengths: [String], considerations: [String], rating: String, color: Color) {
        switch bank {
        case 0: // ICBC
            return (
                name: "ICBC",
                emoji: "🏦",
                speciality: "Largest network with most ATMs and branches nationwide",
                strengths: ["Most ATMs everywhere", "English-speaking staff", "Reliable service", "Easy account opening"],
                considerations: ["Can be crowded", "Less personalized service", "Basic features"],
                rating: "⭐⭐⭐⭐⭐",
                color: .red
            )
        case 1: // Bank of China
            return (
                name: "Bank of China",
                emoji: "🌏",
                speciality: "International expertise with best foreign customer service",
                strengths: ["Best for foreigners", "International transfers", "English interface", "Global network"],
                considerations: ["Fewer branches", "Higher fees sometimes", "Stricter requirements"],
                rating: "⭐⭐⭐⭐⭐",
                color: .blue
            )
        case 2: // China Construction Bank
            return (
                name: "China Construction Bank",
                emoji: "🏗️",
                speciality: "Strong in foreign exchange and real estate financing",
                strengths: ["Good exchange rates", "Real estate services", "Modern banking", "Investment options"],
                considerations: ["Medium-sized network", "Technology focused", "Complex fee structure"],
                rating: "⭐⭐⭐⭐",
                color: .green
            )
        case 3: // China Merchants Bank
            return (
                name: "China Merchants Bank",
                emoji: "💎",
                speciality: "Premium service with high-quality customer experience",
                strengths: ["Excellent service", "Modern technology", "Premium features", "Investment focus"],
                considerations: ["Stricter requirements", "Higher minimum deposits", "Fewer branches"],
                rating: "⭐⭐⭐⭐⭐",
                color: .purple
            )
        default:
            return (name: "", emoji: "", speciality: "", strengths: [], considerations: [], rating: "", color: .gray)
        }
    }
    
    private func visaRequirementsCard(for visaType: Int) -> some View {
        let content = getVisaContent(for: visaType)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(content.emoji)
                    .font(.title2)
                Text(content.type)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(content.color)
                Spacer()
                Text(content.difficulty)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(content.color)
                    .cornerRadius(8)
            }
            
            Text(content.description)
                .font(.body)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Required Documents:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                ForEach(content.requirements, id: \.self) { requirement in
                    HStack(alignment: .top, spacing: 8) {
                        Text("📋")
                            .font(.caption)
                        Text(requirement)
                            .font(.body)
                    }
                }
            }
            
            if !content.tips.isEmpty {
                Text("💡 Pro Tips: \(content.tips)")
                    .font(.callout)
                    .italic()
                    .foregroundColor(content.color)
                    .padding(.top, 5)
            }
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getVisaContent(for visaType: Int) -> (type: String, emoji: String, description: String, requirements: [String], tips: String, difficulty: String, color: Color) {
        switch visaType {
        case 0: // Tourist
            return (
                type: "Tourist Visa",
                emoji: "✈️",
                description: "Limited banking services, basic debit card usually available",
                requirements: [
                    "Valid passport with tourist visa",
                    "Hotel booking or accommodation proof",
                    "Return flight ticket",
                    "Chinese phone number"
                ],
                tips: "Some banks may refuse tourist visas - try Bank of China first",
                difficulty: "Hard",
                color: .orange
            )
        case 1: // Work
            return (
                type: "Work Visa/Permit",
                emoji: "💼",
                description: "Full banking services including credit cards and investment products",
                requirements: [
                    "Valid work permit or residence permit",
                    "Employment contract",
                    "Company invitation letter",
                    "Proof of residence address"
                ],
                tips: "Easiest path to full banking services - bring employment documents",
                difficulty: "Easy",
                color: .green
            )
        case 2: // Student
            return (
                type: "Student Visa",
                emoji: "📚",
                description: "Student accounts with special benefits and lower fees",
                requirements: [
                    "Student visa and residence permit",
                    "University enrollment letter",
                    "Student ID card",
                    "Dormitory or rental agreement"
                ],
                tips: "Many banks offer student discounts and fee waivers",
                difficulty: "Easy",
                color: .blue
            )
        case 3: // Business
            return (
                type: "Business Visa",
                emoji: "🤝",
                description: "Business accounts with corporate banking features available",
                requirements: [
                    "Business visa or invitation",
                    "Company registration documents",
                    "Business license (if applicable)",
                    "Meeting/conference documentation"
                ],
                tips: "Focus on banks with strong corporate relationships",
                difficulty: "Medium",
                color: .purple
            )
        default:
            return (type: "", emoji: "", description: "", requirements: [], tips: "", difficulty: "", color: .gray)
        }
    }
    
    private func applicationStep(number: String, title: String, description: String, tip: String, color: Color) -> some View {
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
    
    private func usageTipCard(category: String, tips: [String], icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(icon)
                    .font(.title2)
                Text(category)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                ForEach(tips, id: \.self) { tip in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(color)
                        Text(tip)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func feeBreakdownCard(feeType: String, amount: String, avoidable: Bool, howToAvoid: String) -> some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 2) {
                Text(feeType)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(amount)
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if avoidable {
                    Text("Avoidable")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(6)
                } else {
                    Text("Unavoidable")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(6)
                }
                
                Text(howToAvoid)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
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
                Text("Solutions:")
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
                Text("Prevention: \(content.prevention)")
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
        case 0: // Application Rejected
            return (
                problem: "Application Rejected",
                emoji: "❌",
                solutions: [
                    "Try a different bank - requirements vary significantly",
                    "Bring additional documentation (employment letter, etc.)",
                    "Visit during weekdays when senior staff are available",
                    "Consider asking a Chinese friend to accompany you"
                ],
                prevention: "Research bank requirements beforehand and call to confirm document needs"
            )
        case 1: // Card Not Working
            return (
                problem: "Card Not Working",
                emoji: "🚫",
                solutions: [
                    "Check if card is activated - visit ATM or call bank",
                    "Verify PIN hasn't been locked from failed attempts",
                    "Ensure card isn't demagnetized - keep away from phones",
                    "Contact bank's 24-hour customer service hotline"
                ],
                prevention: "Activate your card immediately and set up mobile banking"
            )
        case 2: // Fees Too High
            return (
                problem: "Fees Too High",
                emoji: "💸",
                solutions: [
                    "Use your card 6+ times annually to waive annual fees",
                    "Maintain minimum balance to avoid account fees",
                    "Switch to online banking for cheaper transactions",
                    "Consider upgrading to premium account for fee waivers"
                ],
                prevention: "Understand fee structure before opening and optimize usage patterns"
            )
        case 3: // Account Frozen
            return (
                problem: "Account Frozen",
                emoji: "🧊",
                solutions: [
                    "Contact bank immediately to understand the reason",
                    "Provide requested documentation (often ID verification)",
                    "Visit branch in person with passport and visa",
                    "Update your contact information and address"
                ],
                prevention: "Keep contact info updated and respond to bank communications promptly"
            )
        default:
            return (problem: "", emoji: "", solutions: [], prevention: "")
        }
    }
    
    private func departureOptionCard(scenario: String, duration: String, recommendation: String, benefits: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(scenario)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Text(duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
            
            Text("Recommendation: \(recommendation)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Benefits:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                
                ForEach(benefits, id: \.self) { benefit in
                    Text("• \(benefit)")
                        .font(.caption)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
}

#Preview {
    BankCardArticleView()
}