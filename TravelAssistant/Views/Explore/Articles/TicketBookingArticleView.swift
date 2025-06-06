//
//  TicketBookingArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct TicketBookingArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlatform = 0
    @State private var selectedTicketType = 0
    @State private var showingProTips = false
    
    let platforms = ["12306 (Rail)", "Ctrip", "Meituan", "Official Apps"]
    let ticketTypes = ["High-Speed Rail", "Flights", "Attractions", "Concerts"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Travel Tech Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan, .teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("Ticket Booking Made Easy")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Your Digital Gateway • Skip the Lines • Book Like a Local")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Quick Stats Dashboard
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .foregroundColor(.green)
                                Text("Booking Revolution")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("By the numbers")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            HStack(spacing: 0) {
                                statCard(
                                    number: "95%",
                                    label: "Mobile Bookings",
                                    icon: "iphone",
                                    color: .blue
                                )
                                
                                statCard(
                                    number: "3 min",
                                    label: "Average Time",
                                    icon: "clock",
                                    color: .orange
                                )
                                
                                statCard(
                                    number: "50+",
                                    label: "Platforms",
                                    icon: "app.fill",
                                    color: .purple
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Platform Selector
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "apps.iphone")
                                    .foregroundColor(.blue)
                                Text("Choose Your Platform")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Find your perfect match")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Platform", selection: $selectedPlatform) {
                                ForEach(0..<platforms.count, id: \.self) { index in
                                    Text(platforms[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            platformContent(for: selectedPlatform)
                        }
                        
                        // Ticket Type Explorer
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "list.bullet.clipboard")
                                    .foregroundColor(.green)
                                Text("Ticket Categories")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Ticket Type", selection: $selectedTicketType) {
                                ForEach(0..<ticketTypes.count, id: \.self) { index in
                                    Text(ticketTypes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            ticketTypeContent(for: selectedTicketType)
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Booking Process Walkthrough
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "figure.walk.circle")
                                    .foregroundColor(.orange)
                                Text("Step-by-Step Guide")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Master the process")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                processStep(
                                    number: 1,
                                    title: "Account Setup",
                                    description: "Download app, register with real ID info",
                                    tip: "Use your passport number for foreigners"
                                )
                                
                                processStep(
                                    number: 2,
                                    title: "Search & Select",
                                    description: "Enter dates, destinations, browse options",
                                    tip: "Flexible dates can save you money"
                                )
                                
                                processStep(
                                    number: 3,
                                    title: "Payment",
                                    description: "WeChat Pay, Alipay, or international cards",
                                    tip: "Screenshot confirmation for backup"
                                )
                                
                                processStep(
                                    number: 4,
                                    title: "Collect Ticket",
                                    description: "E-ticket, station pickup, or mobile check-in",
                                    tip: "Arrive early for first-time users"
                                )
                            }
                        }
                        
                        // Pro Tips Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Insider Secrets")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            if showingProTips {
                                proTipsGrid()
                            } else {
                                proTipsPreview()
                            }
                            
                            Button(action: {
                                showingProTips.toggle()
                            }) {
                                Text(showingProTips ? "Hide Pro Tips" : "Show All Pro Tips 💡")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.yellow)
                                    .cornerRadius(12)
                            }
                        }
                        .padding(20)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Common Mistakes to Avoid
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                Text("Avoid These Mistakes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                mistakeCard(
                                    mistake: "Booking Too Late",
                                    consequence: "Higher prices and limited options",
                                    solution: "Book 1-2 weeks ahead for best deals"
                                )
                                
                                mistakeCard(
                                    mistake: "Wrong Name/ID",
                                    consequence: "Can't board, lost money",
                                    solution: "Double-check spelling and passport numbers"
                                )
                                
                                mistakeCard(
                                    mistake: "Ignoring Cancellation Policy",
                                    consequence: "Surprise fees when plans change",
                                    solution: "Read the fine print before confirming"
                                )
                            }
                        }
                        
                        // Success Story
                        VStack(spacing: 15) {
                            HStack {
                                Text("🌟")
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text("Real User Success")
                                        .font(.title)
                                        .fontWeight(.bold)
                                    Text("From confused to confident")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            
                            Text("\"I was totally overwhelmed by all the Chinese booking platforms at first. But after following this guide, I booked a high-speed rail ticket in under 5 minutes! The step-by-step approach really helped me understand the process. Now I'm booking everything - trains, flights, even concert tickets - like a local. Game changer!\"")
                                .font(.body)
                                .italic()
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            
                            HStack {
                                Text("- Sarah M., Digital Nomad")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("Verified User")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Ticket Booking")
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
    private func statCard(number: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(number)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
    
    private func platformContent(for platform: Int) -> some View {
        let platformData = [
            (
                name: "12306 (Official Rail)",
                pros: ["Official platform", "Best prices", "Most reliable"],
                cons: ["Chinese interface", "Peak time crashes", "Complex for beginners"],
                bestFor: "High-speed rail and regular trains",
                tip: "Download English version or use translation app",
                rating: "⭐⭐⭐⭐"
            ),
            (
                name: "Ctrip (Trip.com)",
                pros: ["English interface", "Package deals", "24/7 support"],
                cons: ["Service fees", "Sometimes higher prices", "Booking confirmations can be slow"],
                bestFor: "International travelers, flight + hotel packages",
                tip: "Great for complex itineraries and English support",
                rating: "⭐⭐⭐⭐⭐"
            ),
            (
                name: "Meituan",
                pros: ["Local insider deals", "Restaurant + activity combos", "User reviews"],
                cons: ["Chinese only", "Limited international payment", "Local focus"],
                bestFor: "Attractions, local experiences, food tours",
                tip: "Perfect for discovering hidden gems locals love",
                rating: "⭐⭐⭐⭐"
            ),
            (
                name: "Official Apps",
                pros: ["No middleman fees", "Direct customer service", "First access to new tickets"],
                cons: ["Multiple apps needed", "Varying quality", "Often Chinese only"],
                bestFor: "Specific venues, concerts, theme parks",
                tip: "Download before you need them - some require verification",
                rating: "⭐⭐⭐"
            )
        ]
        
        let platform = platformData[platform]
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(platform.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                Spacer()
                Text(platform.rating)
                    .font(.callout)
            }
            
            Text("Best for: \(platform.bestFor)")
                .font(.subheadline)
                .foregroundColor(.green)
                .fontWeight(.medium)
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("✅ Pros:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    ForEach(platform.pros, id: \.self) { pro in
                        Text("• \(pro)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("⚠️ Watch out:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    ForEach(platform.cons, id: \.self) { con in
                        Text("• \(con)")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Text("💡 Pro tip: \(platform.tip)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func ticketTypeContent(for type: Int) -> some View {
        VStack(spacing: 15) {
            switch type {
            case 0: // High-Speed Rail
                railTicketGuide()
            case 1: // Flights
                flightTicketGuide()
            case 2: // Attractions
                attractionTicketGuide()
            case 3: // Concerts
                concertTicketGuide()
            default:
                EmptyView()
            }
        }
    }
    
    private func railTicketGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🚄 High-Speed Rail Tickets")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 10) {
                seatClassCard(
                    seatClass: "Business Class",
                    price: "$$$$",
                    perks: ["2+1 seating", "Meals included", "Priority boarding"],
                    worth: "For long journeys or business travel"
                )
                
                seatClassCard(
                    seatClass: "First Class",
                    price: "$$$",
                    perks: ["2+2 seating", "More legroom", "Free drinks"],
                    worth: "Sweet spot for comfort vs. cost"
                )
                
                seatClassCard(
                    seatClass: "Second Class",
                    price: "$$",
                    perks: ["3+2 seating", "Still comfortable", "Great value"],
                    worth: "Perfect for most travelers"
                )
            }
            
            Text("🎯 Booking tip: Second class is perfectly comfortable for journeys under 4 hours!")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func seatClassCard(seatClass: String, price: String, perks: [String], worth: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(seatClass)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(price)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            
            HStack {
                ForEach(perks, id: \.self) { perk in
                    Text(perk)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            
            Text(worth)
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    private func flightTicketGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("✈️ Flight Tickets")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("Domestic flights in China are super affordable compared to international standards!")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                flightTipCard(
                    tip: "Book domestic flights 2-4 weeks in advance",
                    reason: "Sweet spot for price vs. availability"
                )
                
                flightTipCard(
                    tip: "Avoid Golden Week holidays (Oct 1-7, CNY)",
                    reason: "Prices can triple during peak travel times"
                )
                
                flightTipCard(
                    tip: "Check both English and Chinese airline apps",
                    reason: "Sometimes different prices on different platforms"
                )
            }
            
            Text("💰 Average domestic flight: ¥300-800 ($45-120)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func flightTipCard(tip: String, reason: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(tip)
                .font(.subheadline)
                .fontWeight(.semibold)
            Text("Why: \(reason)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(6)
    }
    
    private func attractionTicketGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎡 Attraction Tickets")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            VStack(spacing: 8) {
                Text("📱 Must-know apps:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                HStack {
                    appBadge(name: "Meituan", specialty: "Local deals")
                    appBadge(name: "Dianping", specialty: "Reviews")
                    appBadge(name: "Ctrip", specialty: "English support")
                }
                
                Text("🎫 Booking strategies:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Book popular spots 3-7 days ahead")
                    Text("• Check for student/senior discounts")
                    Text("• Combo tickets often save money")
                    Text("• Skip-the-line tickets worth extra cost")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func appBadge(name: String, specialty: String) -> some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.caption)
                .fontWeight(.bold)
            Text(specialty)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(6)
    }
    
    private func concertTicketGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎵 Concert & Event Tickets")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text("China's live music scene is incredible - don't miss out!")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                Text("🎪 Popular platforms:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                concertPlatformCard(
                    platform: "Damai (大麦)",
                    description: "China's Ticketmaster - biggest events",
                    tip: "Set up alerts for popular shows"
                )
                
                concertPlatformCard(
                    platform: "Maoyan (猫眼)",
                    description: "Movies + live events, good mobile app",
                    tip: "Great for indie concerts and theater"
                )
                
                Text("⚡ Pro tips:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("• Popular shows sell out in minutes")
                    Text("• Have payment method ready before sale starts")
                    Text("• Check resale platforms carefully for authenticity")
                    Text("• Venue location matters - check subway access")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func concertPlatformCard(platform: String, description: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(platform)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("💡 \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(6)
    }
    
    private func processStep(number: Int, title: String, description: String, tip: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.orange)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("💡 \(tip)")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func proTipsPreview() -> some View {
        VStack(spacing: 12) {
            Text("Want to book like a pro? Here's what insiders know...")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                tipPreviewBubble(text: "Peak hours to avoid")
                tipPreviewBubble(text: "Secret discount codes")
                tipPreviewBubble(text: "Refund hacks")
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func tipPreviewBubble(text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.yellow.opacity(0.3))
            .cornerRadius(12)
    }
    
    private func proTipsGrid() -> some View {
        VStack(spacing: 12) {
            HStack {
                proTipCard(
                    icon: "clock.arrow.circlepath",
                    title: "Timing Secrets",
                    tip: "Book Tuesday 2-4 PM for lowest prices"
                )
                
                proTipCard(
                    icon: "percent",
                    title: "Hidden Discounts",
                    tip: "Check university student portals for codes"
                )
            }
            
            HStack {
                proTipCard(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Refund Magic",
                    tip: "Travel insurance can cover 'non-refundable' tickets"
                )
                
                proTipCard(
                    icon: "bell.badge",
                    title: "Alert Setup",
                    tip: "Price tracking apps save hundreds per year"
                )
            }
            
            proTipCard(
                icon: "creditcard.trianglebadge.exclamationmark",
                title: "Payment Power Move",
                tip: "Some credit cards offer purchase protection for tickets - use those for expensive bookings!"
            )
        }
    }
    
    private func proTipCard(icon: String, title: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.yellow)
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Spacer()
            }
            
            Text(tip)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func mistakeCard(mistake: String, consequence: String, solution: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("❌ \(mistake)")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Text("What happens: \(consequence)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("✅ Do this instead: \(solution)")
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    TicketBookingArticleView()
}