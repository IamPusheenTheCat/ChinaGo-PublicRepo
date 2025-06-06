//
//  ShoppingGuideArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct ShoppingGuideArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedShoppingStyle = 0
    @State private var selectedTrendAlert = 0
    @State private var showingStyleGuide = false
    
    let shoppingStyles = ["Luxury Hunter", "Street Fashion", "Tech Savvy", "Local Treasures"]
    let trendAlerts = ["Fashion Week", "Tech Drops", "Beauty Launches", "Cultural Items"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Fashion Influencer Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.pink, .orange, .yellow]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "bag.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("Shopping Like an Insider")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Fashion • Trends • Insider Secrets • Style Your Way Through China")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Style Mood Board
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                                Text("Style Mood Board")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("What's your shopping vibe?")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 15) {
                                vibeCard(
                                    vibe: "Luxury Lifestyle",
                                    emoji: "✨",
                                    description: "When only the finest will do - premium brands and exclusive experiences",
                                    hotspots: ["SKP Mall", "IFC Shanghai", "Luxury boutiques"]
                                )
                                
                                vibeCard(
                                    vibe: "Street Style Chic",
                                    emoji: "🌟",
                                    description: "Discover emerging brands and unique finds in hip neighborhoods",
                                    hotspots: ["798 Art District", "Taikoo Li", "Local designer shops"]
                                )
                                
                                vibeCard(
                                    vibe: "Tech & Innovation",
                                    emoji: "🚀",
                                    description: "Latest gadgets, smart devices, and cutting-edge technology",
                                    hotspots: ["Huaqiangbei", "Zhongguancun", "Xiaomi stores"]
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Shopping Style Selector
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                Text("Your Shopping Persona")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Find your perfect style")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Shopping Style", selection: $selectedShoppingStyle) {
                                ForEach(0..<shoppingStyles.count, id: \.self) { index in
                                    Text(shoppingStyles[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            shoppingStyleContent(for: selectedShoppingStyle)
                        }
                        
                        // Trend Alerts
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "bell.badge.fill")
                                    .foregroundColor(.red)
                                Text("Trend Alerts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Trend Category", selection: $selectedTrendAlert) {
                                ForEach(0..<trendAlerts.count, id: \.self) { index in
                                    Text(trendAlerts[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            trendContent(for: selectedTrendAlert)
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Insider Shopping Secrets
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "eye.fill")
                                    .foregroundColor(.blue)
                                Text("Insider Secrets")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("What locals don't tell you")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                insiderCard(
                                    secret: "VIP Shopping Hours",
                                    tip: "Visit luxury malls before 11 AM for personal shopping service",
                                    impact: "Better service & exclusive access"
                                )
                                
                                insiderCard(
                                    secret: "Local Brand Hidden Gems",
                                    tip: "Check out Chinese brands that aren't available overseas yet",
                                    impact: "Unique finds at amazing prices"
                                )
                                
                                insiderCard(
                                    secret: "Seasonal Timing",
                                    tip: "End of Chinese New Year = massive sales across all categories",
                                    impact: "Up to 70% off luxury items"
                                )
                                
                                insiderCard(
                                    secret: "Payment Hack",
                                    tip: "Some apps give cashback only to local users - ask friends to help",
                                    impact: "Extra 5-15% savings"
                                )
                            }
                        }
                        
                        // Must-Have Shopping Apps
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "iphone.and.arrow.forward")
                                    .foregroundColor(.green)
                                Text("Essential Apps")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                appCard(
                                    name: "Xiaohongshu (Little Red Book)",
                                    category: "Social Shopping",
                                    purpose: "Discover trends, read real reviews, find hidden spots",
                                    mustHave: true
                                )
                                
                                appCard(
                                    name: "Taobao",
                                    category: "Everything Store",
                                    purpose: "Literally anything you can imagine, best prices",
                                    mustHave: true
                                )
                                
                                appCard(
                                    name: "Poizon (得物)",
                                    category: "Authentic Streetwear",
                                    purpose: "Verified sneakers, luxury items, and streetwear",
                                    mustHave: false
                                )
                                
                                appCard(
                                    name: "WeChat Mini Programs",
                                    category: "Brand Direct",
                                    purpose: "Official brand stores within WeChat",
                                    mustHave: false
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Cultural Shopping Etiquette
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "hands.sparkles.fill")
                                    .foregroundColor(.orange)
                                Text("Shopping Etiquette")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                etiquetteCard(
                                    situation: "Luxury Stores",
                                    dos: ["Dress well", "Be polite", "Ask about VIP services"],
                                    donts: ["Touch everything", "Argue about prices", "Be overly casual"]
                                )
                                
                                etiquetteCard(
                                    situation: "Local Markets",
                                    dos: ["Bargain respectfully", "Show interest", "Learn basic Chinese numbers"],
                                    donts: ["Be aggressive", "Walk away rudely", "Ignore vendors completely"]
                                )
                                
                                etiquetteCard(
                                    situation: "Online Shopping",
                                    dos: ["Read reviews carefully", "Contact sellers", "Use platform protection"],
                                    donts: ["Skip return policies", "Trust too-good deals", "Ignore seller ratings"]
                                )
                            }
                        }
                        
                        // Style Guide Creator
                        if showingStyleGuide {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("👗")
                                        .font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text("Your Personal Style Guide")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Curated for your taste")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🌟 **Wardrobe Essentials**: Invest in quality basics first")
                                    Text("✨ **Trend Pieces**: Add 2-3 statement items per season")
                                    Text("🎨 **Local Finds**: Mix in unique Chinese designer pieces")
                                    Text("👟 **Comfort Meets Style**: Don't sacrifice comfort for looks")
                                    Text("📱 **Document Everything**: Share your finds on social media")
                                }
                                .font(.body)
                                .padding()
                                .background(Color.pink.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Call to Action
                        Button(action: {
                            showingStyleGuide.toggle()
                        }) {
                            Text(showingStyleGuide ? "Hide Style Guide" : "Create My Style Guide ✨")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(showingStyleGuide ? Color.gray : Color.pink)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Shopping Style")
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
    private func vibeCard(vibe: String, emoji: String, description: String, hotspots: [String]) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(vibe)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.pink)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Hotspots:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    ForEach(hotspots, id: \.self) { spot in
                        Text(spot)
                            .font(.caption)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(6)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    private func shoppingStyleContent(for style: Int) -> some View {
        let styleData = [
            (
                title: "Luxury Hunter",
                personality: "You appreciate the finer things and know quality when you see it",
                approach: "Research brands, build relationships with sales associates, timing is everything",
                destinations: ["SKP Beijing", "Plaza 66 Shanghai", "Taikoo Li Chengdu"],
                strategy: "Focus on pieces not available in your home country",
                budget: "High investment, long-term value",
                insider: "Many luxury brands offer China-exclusive items and colorways"
            ),
            (
                title: "Street Fashion",
                personality: "You love discovering emerging trends and unique pieces before they go mainstream",
                approach: "Explore local neighborhoods, follow Chinese influencers, visit concept stores",
                destinations: ["798 Art Zone", "Jing'an District", "Caochangdi"],
                strategy: "Mix international streetwear with local designer finds",
                budget: "Mid-range with strategic splurges",
                insider: "Check out Chinese streetwear brands like ROARINGWILD and LABELHOOD"
            ),
            (
                title: "Tech Savvy",
                personality: "You're always on the hunt for the latest gadgets and innovative products",
                approach: "Visit tech districts, compare specifications, test products hands-on",
                destinations: ["Huaqiangbei Shenzhen", "Zhongguancun Beijing", "Xiaomi flagship stores"],
                strategy: "Buy latest releases months before global launch",
                budget: "Research-driven, value for innovation",
                insider: "Many Chinese tech brands offer features not available in international versions"
            ),
            (
                title: "Local Treasures",
                personality: "You seek authentic cultural items and traditional craftsmanship",
                approach: "Visit artisan workshops, learn the stories behind products, support local makers",
                destinations: ["Liulichang Antique Street", "Tianzifang Shanghai", "Jinli Ancient Street"],
                strategy: "Invest in handmade, one-of-a-kind pieces",
                budget: "Quality over quantity mindset",
                insider: "Ask about the artist's story - it adds so much value to your purchase"
            )
        ]
        
        let data = styleData[style]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(data.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Your Personality:")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(data.personality)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
                
                Text("Shopping Approach:")
                    .font(.caption)
                    .fontWeight(.bold)
                Text(data.approach)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Must-Visit Destinations:")
                    .font(.caption)
                    .fontWeight(.bold)
                HStack {
                    ForEach(data.destinations, id: \.self) { destination in
                        Text(destination)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.purple.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                
                Text("Strategy: \(data.strategy)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text("Budget Philosophy: \(data.budget)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
            
            Text("✨ Insider Tip: \(data.insider)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.pink)
                .padding()
                .background(Color.pink.opacity(0.1))
                .cornerRadius(8)
        }
        .padding()
        .background(Color.purple.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func trendContent(for trend: Int) -> some View {
        VStack(spacing: 15) {
            switch trend {
            case 0: // Fashion Week
                fashionTrendContent()
            case 1: // Tech Drops
                techTrendContent()
            case 2: // Beauty Launches
                beautyTrendContent()
            case 3: // Cultural Items
                culturalTrendContent()
            default:
                EmptyView()
            }
        }
    }
    
    private func fashionTrendContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🌟 Fashion Week Buzz")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                trendItem(
                    trend: "Oversized Blazers",
                    status: "Hot Now",
                    location: "Local designer boutiques",
                    price: "¥800-2000",
                    tip: "Look for unique shoulder details"
                )
                
                trendItem(
                    trend: "Chunky Sneakers",
                    status: "Still Rising",
                    location: "Poizon app, concept stores",
                    price: "¥1200-3000",
                    tip: "Chinese collabs have amazing colorways"
                )
                
                trendItem(
                    trend: "Sustainable Fashion",
                    status: "Growing Fast",
                    location: "Reclothing Bank, local brands",
                    price: "¥500-1500",
                    tip: "Support brands with transparency"
                )
            }
            
            Text("📱 Follow @xiaohongshu for real-time trend updates")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func techTrendContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🚀 Tech Drop Alerts")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                trendItem(
                    trend: "Foldable Phones",
                    status: "Next Gen",
                    location: "Official brand stores",
                    price: "¥8000-15000",
                    tip: "Test durability in store first"
                )
                
                trendItem(
                    trend: "Smart Home Ecosystem",
                    status: "Mature Market",
                    location: "Xiaomi, Tmall",
                    price: "¥200-2000/device",
                    tip: "Start with one brand for compatibility"
                )
                
                trendItem(
                    trend: "Wearable Tech",
                    status: "Innovation Peak",
                    location: "Huami, Amazfit stores",
                    price: "¥500-2000",
                    tip: "Health features way ahead of global market"
                )
            }
            
            Text("💡 Chinese tech often leads global releases by 6+ months")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func beautyTrendContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("💄 Beauty Launch Calendar")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                trendItem(
                    trend: "Glass Skin Products",
                    status: "Trending Up",
                    location: "Perfect Diary, Sephora",
                    price: "¥100-500",
                    tip: "Layer light textures for best effect"
                )
                
                trendItem(
                    trend: "Traditional Chinese Medicine Beauty",
                    status: "Ancient Meets Modern",
                    location: "Herborist, Wei Beauty",
                    price: "¥200-800",
                    tip: "Research ingredients for your skin type"
                )
                
                trendItem(
                    trend: "K-Beauty Meets C-Beauty",
                    status: "Fusion Trend",
                    location: "Tmall, concept stores",
                    price: "¥150-600",
                    tip: "Look for limited Asia-exclusive launches"
                )
            }
            
            Text("✨ Chinese beauty brands offer amazing quality at fraction of global prices")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func culturalTrendContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🏮 Cultural Treasures")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(spacing: 10) {
                trendItem(
                    trend: "Modern Hanfu",
                    status: "Cultural Revival",
                    location: "Shisanyu, Huaxichao",
                    price: "¥300-2000",
                    tip: "Choose daily-wear versions for versatility"
                )
                
                trendItem(
                    trend: "Tea Culture Items",
                    status: "Lifestyle Trend",
                    location: "TEA'STONE, local tea shops",
                    price: "¥100-1000",
                    tip: "Learn about tea ceremony for full experience"
                )
                
                trendItem(
                    trend: "Calligraphy Art",
                    status: "Meditation Trend",
                    location: "Art districts, online studios",
                    price: "¥50-500",
                    tip: "Take a class to understand the art form"
                )
            }
            
            Text("🌸 Cultural items make the most meaningful souvenirs")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.red.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func trendItem(trend: String, status: String, location: String, price: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(trend)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(status)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red)
                    .cornerRadius(6)
            }
            
            Text("Where: \(location)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Price: \(price)")
                .font(.caption)
                .foregroundColor(.green)
            
            Text("💡 \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    private func insiderCard(secret: String, tip: String, impact: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(secret)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(tip)
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("Impact: \(impact)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
                .italic()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func appCard(name: String, category: String, purpose: String, mustHave: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Spacer()
                
                if mustHave {
                    Text("MUST HAVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                }
            }
            
            Text(category)
                .font(.caption)
                .foregroundColor(.green)
                .fontWeight(.medium)
            
            Text(purpose)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func etiquetteCard(situation: String, dos: [String], donts: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(situation)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.orange)
            
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("✅ Do:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    ForEach(dos, id: \.self) { item in
                        Text("• \(item)")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("❌ Don't:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    ForEach(donts, id: \.self) { item in
                        Text("• \(item)")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    ShoppingGuideArticleView()
}