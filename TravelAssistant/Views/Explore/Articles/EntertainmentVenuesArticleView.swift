//
//  EntertainmentVenuesArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct EntertainmentVenuesArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCity = 0
    @State private var selectedVenueType = 0
    @State private var showingNightlifeGuide = false
    
    let cities = ["Shanghai", "Beijing", "Guangzhou", "Chengdu"]
    let venueTypes = ["KTV & Karaoke", "Bars & Clubs", "Live Music", "Gaming Centers"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Lifestyle Magazine Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.pink, .purple, .blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "party.popper.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("China's Entertainment Scene")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Where Fun Meets Culture • Nightlife Guide • Local Hotspots")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Editor's Picks
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Editor's Picks")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("This month's must-try spots")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 15) {
                                editorPickCard(
                                    category: "Hidden Gem",
                                    venue: "Jazz at Lincoln Center Shanghai",
                                    rating: "4.8/5",
                                    highlight: "Intimate jazz performances with NYC vibes",
                                    why: "Perfect blend of international sophistication and local charm"
                                )
                                
                                editorPickCard(
                                    category: "Local Favorite",
                                    venue: "Beijing Hutong KTV",
                                    rating: "4.6/5",
                                    highlight: "Traditional architecture meets modern fun",
                                    why: "Experience karaoke culture in an authentic setting"
                                )
                                
                                editorPickCard(
                                    category: "Trendsetter",
                                    venue: "Guangzhou Rooftop Scene",
                                    rating: "4.9/5",
                                    highlight: "Sky-high views with craft cocktails",
                                    why: "Where young professionals go to see and be seen"
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // City Spotlight
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "building.2.crop.circle")
                                    .foregroundColor(.blue)
                                Text("City Spotlight")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("What's happening where")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("City", selection: $selectedCity) {
                                ForEach(0..<cities.count, id: \.self) { index in
                                    Text(cities[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            citySpotlightContent(for: selectedCity)
                        }
                        
                        // Venue Deep Dive
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "music.note.house.fill")
                                    .foregroundColor(.purple)
                                Text("Venue Guide")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Venue Type", selection: $selectedVenueType) {
                                ForEach(0..<venueTypes.count, id: \.self) { index in
                                    Text(venueTypes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            venueTypeContent(for: selectedVenueType)
                        }
                        .padding(20)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Local Insider Reviews
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "person.2.circle.fill")
                                    .foregroundColor(.green)
                                Text("Local Insider Reviews")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Real people, real experiences")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                insiderReviewCard(
                                    reviewer: "Mike Chen",
                                    location: "Shanghai",
                                    venue: "M1NT Club",
                                    experience: "The view from the 24th floor is insane! Worth the dress code hassle.",
                                    tip: "Book a table if you're going with a group - worth the splurge",
                                    rating: 5
                                )
                                
                                insiderReviewCard(
                                    reviewer: "Emma Liu",
                                    location: "Beijing",
                                    venue: "Temple Bar",
                                    experience: "Best craft beer selection in the city. The cozy vibe is perfect for dates.",
                                    tip: "Try their Beijing Blonde - it's a local brew that's actually good",
                                    rating: 4
                                )
                                
                                insiderReviewCard(
                                    reviewer: "Alex Wang",
                                    location: "Chengdu",
                                    venue: "Little Bar",
                                    experience: "Tiny space, huge personality. The bartender remembers your order after two visits.",
                                    tip: "Cash only, but there's an ATM around the corner",
                                    rating: 5
                                )
                            }
                        }
                        
                        // Cultural Context
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "globe.asia.australia.fill")
                                    .foregroundColor(.orange)
                                Text("Cultural Guide")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                culturalTipCard(
                                    topic: "KTV Etiquette",
                                    context: "Karaoke is serious business in China - it's not just singing, it's bonding",
                                    tips: ["Let the host pick the first song", "Cheer for everyone, even bad singers", "Order snacks and drinks to share", "Expect sessions to last 3+ hours"]
                                )
                                
                                culturalTipCard(
                                    topic: "Bar Culture",
                                    context: "Chinese bar culture blends traditional hospitality with modern trends",
                                    tips: ["Group buying drinks is common", "Business cards are often exchanged", "WeChat QR codes for new connections", "Closing time varies widely by city"]
                                )
                            }
                        }
                        
                        // Budget Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dollarsign.circle.fill")
                                    .foregroundColor(.green)
                                Text("Budget Breakdown")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            budgetGuideGrid()
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Nightlife Safety Guide
                        if showingNightlifeGuide {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("🛡️")
                                        .font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text("Nightlife Safety Guide")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Party smart, stay safe")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🚨 **Always tell someone where you're going**")
                                    Text("💰 **Keep cash and cards in separate places**")
                                    Text("📱 **Have DiDi and local taxi apps ready**")
                                    Text("🍺 **Watch your drink, trust your instincts**")
                                    Text("🏠 **Know your address in Chinese characters**")
                                }
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Call to Action
                        Button(action: {
                            showingNightlifeGuide.toggle()
                        }) {
                            Text(showingNightlifeGuide ? "Hide Safety Guide" : "Show Nightlife Safety Guide 🛡️")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(showingNightlifeGuide ? Color.gray : Color.orange)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Entertainment Guide")
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
    private func editorPickCard(category: String, venue: String, rating: String, highlight: String, why: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            VStack(spacing: 4) {
                Text("✨")
                    .font(.title2)
                Text(rating)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(category)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                    .textCase(.uppercase)
                
                Text(venue)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(highlight)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Why we love it: \(why)")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .italic()
            }
            
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func citySpotlightContent(for city: Int) -> some View {
        let cityData = [
            (
                name: "Shanghai",
                vibe: "International sophistication meets local creativity",
                hotDistricts: ["The Bund", "French Concession", "Xintiandi"],
                signature: "Rooftop bars with skyline views",
                bestFor: "Upscale nightlife and cocktail culture",
                insider: "Dress codes are strict at high-end places - plan accordingly"
            ),
            (
                name: "Beijing",
                vibe: "Historic charm with underground energy",
                hotDistricts: ["Sanlitun", "Gulou", "798 Art District"],
                signature: "Hutong bars in traditional courtyards",
                bestFor: "Alternative culture and live music",
                insider: "Many venues close early on weekdays - weekends are when it gets wild"
            ),
            (
                name: "Guangzhou",
                vibe: "Laid-back Cantonese culture with modern flair",
                hotDistricts: ["Tianhe", "Zhujiang New Town", "Shamian Island"],
                signature: "Dim sum bars and tea house clubs",
                bestFor: "Food-focused entertainment and tea culture",
                insider: "Cantonese hospitality means you'll be offered food constantly - go with it!"
            ),
            (
                name: "Chengdu",
                vibe: "Spicy food, spicier nightlife",
                hotDistricts: ["Chunxi Road", "Jinli", "Kuanzhai Alley"],
                signature: "Mahjong parlors and hot pot after-parties",
                bestFor: "Authentic local culture and spicy food adventures",
                insider: "The party starts late and goes until dawn - pace yourself with the baijiu"
            )
        ]
        
        let city = cityData[city]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(city.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("The vibe: \(city.vibe)")
                .font(.body)
                .foregroundColor(.secondary)
                .italic()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("🔥 Hot districts:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                HStack {
                    ForEach(city.hotDistricts, id: \.self) { district in
                        Text(district)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                    }
                    Spacer()
                }
            }
            
            Text("Signature experience: \(city.signature)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.purple)
            
            Text("Best for: \(city.bestFor)")
                .font(.caption)
                .foregroundColor(.green)
            
            Text("💡 Local tip: \(city.insider)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
                .padding()
                .background(Color.orange.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func venueTypeContent(for type: Int) -> some View {
        VStack(spacing: 15) {
            switch type {
            case 0: // KTV & Karaoke
                ktvGuide()
            case 1: // Bars & Clubs
                barsClubsGuide()
            case 2: // Live Music
                liveMusicGuide()
            case 3: // Gaming Centers
                gamingGuide()
            default:
                EmptyView()
            }
        }
    }
    
    private func ktvGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎤 KTV & Karaoke Culture")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            Text("KTV isn't just singing - it's China's favorite way to bond with friends, celebrate, and let loose.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                ktvTierCard(
                    tier: "Premium KTV",
                    price: "¥200-500/hour",
                    features: ["Private suites", "High-end sound systems", "Food & drink service"],
                    experience: "Business entertainment and special occasions"
                )
                
                ktvTierCard(
                    tier: "Standard KTV",
                    price: "¥50-150/hour",
                    features: ["Basic private rooms", "Decent song selection", "BYOB allowed"],
                    experience: "Regular hangouts with friends"
                )
                
                ktvTierCard(
                    tier: "Mini KTV",
                    price: "¥30-60/hour",
                    features: ["2-person booths", "Modern touchscreens", "Perfect for dates"],
                    experience: "Quick fun sessions in malls"
                )
            }
            
            Text("🎵 Pro tip: Download songs to your phone beforehand - English song selection varies by venue!")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func ktvTierCard(tier: String, price: String, features: [String], experience: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(tier)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(price)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(features, id: \.self) { feature in
                    Text("• \(feature)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("Best for: \(experience)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    private func barsClubsGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🍸 Bars & Clubs Scene")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(spacing: 10) {
                Text("🍻 Bar types:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                barTypeCard(
                    type: "Craft Beer Bars",
                    description: "Local and imported brews",
                    atmosphere: "Casual, international crowd",
                    price: "¥40-80 per beer"
                )
                
                barTypeCard(
                    type: "Cocktail Lounges",
                    description: "Sophisticated mixology",
                    atmosphere: "Upscale, dress code enforced",
                    price: "¥80-200 per cocktail"
                )
                
                barTypeCard(
                    type: "Sports Bars",
                    description: "International sports on big screens",
                    atmosphere: "Expat-friendly, English spoken",
                    price: "¥30-60 per drink"
                )
                
                Text("🎪 Club scene:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Most clubs have table service culture - splitting a table with friends is common and often cheaper than individual drinks. Entry fees range from ¥50-200 depending on the night and DJ.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func barTypeCard(type: String, description: String, atmosphere: String, price: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(type)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("Vibe: \(atmosphere)")
                .font(.caption)
                .foregroundColor(.green)
            Text("Price: \(price)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.orange)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(6)
    }
    
    private func liveMusicGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎸 Live Music Scene")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            Text("China's live music scene is exploding with talent - from underground rock to jazz fusion.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                musicVenueCard(
                    venue: "Livehouse Venues",
                    description: "Intimate concerts, emerging artists",
                    ticketRange: "¥80-300",
                    tips: "Book ahead for popular bands, shows often sell out"
                )
                
                musicVenueCard(
                    venue: "Jazz Clubs",
                    description: "Sophisticated atmosphere, international acts",
                    ticketRange: "¥150-500",
                    tips: "Dinner packages available, dress smart"
                )
                
                musicVenueCard(
                    venue: "Rock Bars",
                    description: "Local bands, grungy atmosphere",
                    ticketRange: "¥50-150",
                    tips: "Cash only at many venues, shows start late"
                )
                
                Text("🎫 Where to find shows:")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                
                HStack {
                    appBadge(name: "Douban", use: "Events")
                    appBadge(name: "WeChat", use: "Venue accounts")
                    appBadge(name: "Showstart", use: "Tickets")
                }
            }
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func musicVenueCard(venue: String, description: String, ticketRange: String, tips: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(venue)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(ticketRange)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("💡 \(tips)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(6)
    }
    
    private func appBadge(name: String, use: String) -> some View {
        VStack(spacing: 2) {
            Text(name)
                .font(.caption)
                .fontWeight(.bold)
            Text(use)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(6)
    }
    
    private func gamingGuide() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎮 Gaming & Tech Entertainment")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            Text("Gaming culture is huge in China - from internet cafes to VR experiences and mobile gaming lounges.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                gamingVenueCard(
                    type: "Internet Cafes (网吧)",
                    experience: "High-end gaming PCs, competitive gaming",
                    price: "¥10-30/hour",
                    vibe: "Serious gamers, tournament atmosphere"
                )
                
                gamingVenueCard(
                    type: "VR Centers",
                    experience: "Virtual reality games and experiences",
                    price: "¥50-150/hour",
                    vibe: "High-tech, family-friendly"
                )
                
                gamingVenueCard(
                    type: "Board Game Cafes",
                    experience: "International and Chinese board games",
                    price: "¥30-80/person",
                    vibe: "Social, good for groups and dates"
                )
                
                gamingVenueCard(
                    type: "Mobile Gaming Lounges",
                    experience: "Comfortable seating for mobile gaming",
                    price: "¥20-50/hour",
                    vibe: "Casual, snacks and drinks available"
                )
            }
            
            Text("🎯 Gamer tip: Many venues offer group packages and all-night deals. Bring your passport for registration!")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func gamingVenueCard(type: String, experience: String, price: String, vibe: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(price)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }
            Text(experience)
                .font(.caption)
                .foregroundColor(.secondary)
            Text("Vibe: \(vibe)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(6)
    }
    
    private func insiderReviewCard(reviewer: String, location: String, venue: String, experience: String, tip: String, rating: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(reviewer)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(location)
                        .font(.caption)
                        .foregroundColor(.secondary)
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
            
            Text(venue)
                .font(.subheadline)
                .foregroundColor(.blue)
                .fontWeight(.medium)
            
            Text("\"\(experience)\"")
                .font(.body)
                .italic()
            
            Text("Local tip: \(tip)")
                .font(.caption)
                .foregroundColor(.green)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func culturalTipCard(topic: String, context: String, tips: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(topic)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            Text(context)
                .font(.body)
                .foregroundColor(.secondary)
                .italic()
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(tips, id: \.self) { tip in
                    Text("• \(tip)")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func budgetGuideGrid() -> some View {
        VStack(spacing: 15) {
            Text("Typical night out costs:")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                budgetCard(activity: "KTV Night", price: "¥100-300", duration: "3-4 hours")
                budgetCard(activity: "Bar Crawl", price: "¥200-500", duration: "Full evening")
                budgetCard(activity: "Club Night", price: "¥300-800", duration: "Late night")
                budgetCard(activity: "Gaming Session", price: "¥50-150", duration: "2-3 hours")
            }
            
            Text("💰 Money-saving tip: Group bookings and early-bird specials can cut costs by 30-50%")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
    }
    
    private func budgetCard(activity: String, price: String, duration: String) -> some View {
        VStack(spacing: 6) {
            Text(activity)
                .font(.subheadline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text(price)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text(duration)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
}

#Preview {
    EntertainmentVenuesArticleView()
}