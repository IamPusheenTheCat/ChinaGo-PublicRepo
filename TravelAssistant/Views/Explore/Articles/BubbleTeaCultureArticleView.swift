//
//  BubbleTeaCultureArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct BubbleTeaCultureArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedBrand = 0
    @State private var selectedFlavor = 0
    @State private var selectedCustomization = 0
    
    let brands = ["Premium", "Affordable", "Local Gems", "Trending"]
    let flavorCategories = ["Beginner Safe", "Adventurous", "Instagram Worthy", "Seasonal"]
    let customizationTypes = ["Sweetness Guide", "Temperature Tips", "Topping Secrets", "Base Selection"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Cultural Hero Section
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.brown, .orange]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 200)
                        
                        VStack(spacing: 12) {
                            Image(systemName: "cup.and.saucer.fill")
                                .font(.system(size: 45))
                                .foregroundColor(.white)
                            
                            Text("Bubble Tea Culture Deep Dive")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Your gateway to understanding modern Chinese youth culture")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Why Bubble Tea Matters
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.pink)
                                Text("Why Bubble Tea Is a Cultural Phenomenon")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                culturalImpactCard(
                                    icon: "💬",
                                    title: "Social Currency",
                                    fact: "Buying someone bubble tea = I care about you",
                                    impact: "Essential for dates, friend meetings, workplace bonding"
                                )
                                
                                culturalImpactCard(
                                    icon: "📸",
                                    title: "Instagram Culture",
                                    fact: "The perfect drink for your social media aesthetic",
                                    impact: "Brands spend millions making drinks photogenic"
                                )
                                
                                culturalImpactCard(
                                    icon: "🎯",
                                    title: "Personal Identity",
                                    fact: "Your order defines you: sweet/health-conscious/adventurous",
                                    impact: "Young people express personality through drink choices"
                                )
                                
                                culturalImpactCard(
                                    icon: "💰",
                                    title: "Economic Force",
                                    fact: "¥200+ billion industry employing millions",
                                    impact: "Bigger than China's entire movie industry"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(15)
                        
                        // Brand Discovery Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                    .foregroundColor(.yellow)
                                Text("Brand Discovery Guide")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("- Find your tribe")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Brand Category", selection: $selectedBrand) {
                                ForEach(0..<brands.count, id: \.self) { index in
                                    Text(brands[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            brandCategoryCard(for: selectedBrand)
                        }
                        
                        // Flavor Journey
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "sparkles")
                                    .foregroundColor(.purple)
                                Text("Your Flavor Journey")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Flavor Category", selection: $selectedFlavor) {
                                ForEach(0..<flavorCategories.count, id: \.self) { index in
                                    Text(flavorCategories[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            flavorGuide(for: selectedFlavor)
                        }
                        
                        // Order Like a Local
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                    .foregroundColor(.blue)
                                Text("Order Like a Local")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("- Master the art of customization")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Customization", selection: $selectedCustomization) {
                                ForEach(0..<customizationTypes.count, id: \.self) { index in
                                    Text(customizationTypes[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            customizationGuide(for: selectedCustomization)
                        }
                        
                        // Psychology Behind the Addiction
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundColor(.green)
                                Text("The Psychology Behind the Addiction")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                psychologyCard(
                                    aspect: "Texture Therapy",
                                    explanation: "Chewing pearls releases stress - it's like bubble wrap but tasty",
                                    science: "Repetitive chewing triggers endorphin release"
                                )
                                
                                psychologyCard(
                                    aspect: "Customization Control",
                                    explanation: "In a structured society, choosing exact sweetness feels liberating",
                                    science: "Personal choice increases satisfaction in small decisions"
                                )
                                
                                psychologyCard(
                                    aspect: "Comfort Ritual",
                                    explanation: "That 3 PM bubble tea break becomes sacred self-care",
                                    science: "Routine rituals reduce anxiety and provide emotional stability"
                                )
                                
                                psychologyCard(
                                    aspect: "Social Bonding",
                                    explanation: "Sharing toppings creates intimacy faster than sharing meals",
                                    science: "Food sharing activates trust-building neural pathways"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Insider Secrets
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Insider Secrets from Tea Addicts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 10) {
                                insiderTipCard(
                                    title: "The 3:30 PM Rule",
                                    tip: "Order between 3-4 PM for maximum enjoyment",
                                    reason: "Perfect timing between meals, plus energy naturally dips"
                                )
                                
                                insiderTipCard(
                                    title: "Photo Before Sip",
                                    tip: "Always photograph within 5 minutes",
                                    reason: "Foam settles and ice melts - perfect shot has short window"
                                )
                                
                                insiderTipCard(
                                    title: "Temperature Strategy",
                                    tip: "Ask for 'less ice' instead of 'no ice' in summer",
                                    reason: "No ice means they add water - less ice keeps it cold without diluting"
                                )
                                
                                insiderTipCard(
                                    title: "The Loyalty Hack",
                                    tip: "Stick to one brand near office/home",
                                    reason: "Staff remember your order and might add extra toppings free"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Health Reality Check
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "heart.text.square.fill")
                                    .foregroundColor(.red)
                                Text("Health Reality Check")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("- The truth about your daily habit")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                healthFactCard(
                                    fact: "One full-sugar bubble tea = 13 sugar cubes",
                                    impact: "Your entire daily sugar limit in one drink",
                                    solution: "Start with 70% sugar, gradually reduce to 30%"
                                )
                                
                                healthFactCard(
                                    fact: "Tapioca pearls are pure carbs with zero nutrition",
                                    impact: "Like eating gummy bears with bouncy texture",
                                    solution: "Try coconut jelly or aloe vera for lower calories"
                                )
                                
                                healthFactCard(
                                    fact: "Caffeine varies wildly (20-100mg per cup)",
                                    impact: "Could be keeping you awake without realizing",
                                    solution: "Ask about caffeine levels, switch to herbal after 3 PM"
                                )
                            }
                        }
                        
                        // Cultural Adventure Awaits
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "map.fill")
                                    .foregroundColor(.brown)
                                Text("Your Cultural Adventure Awaits")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("Bubble tea isn't just a drink - it's your key to understanding how modern China works. From social dynamics to innovation culture, every sip tells a story. Start with COCO (safe and reliable), graduate to HeyTea (trendy and premium), then explore local brands for authentic regional culture. Welcome to the delicious side of Chinese society! 🧋✨")
                                .font(.body)
                                .padding()
                                .background(Color.brown.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Bubble Tea Culture")
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
    private func culturalImpactCard(icon: String, title: String, fact: String, impact: String) -> some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(fact)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text(impact)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func brandCategoryCard(for category: Int) -> some View {
        let content = getBrandContent(for: category)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(content.emoji)
                    .font(.title)
                Text(content.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(content.color)
            }
            
            Text(content.vibe)
                .font(.body)
                .italic()
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content.brands, id: \.name) { brand in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("**\(brand.name)**: \(brand.signature)")
                            .font(.body)
                        Text(brand.personality)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Text("💡 \(content.tip)")
                .font(.callout)
                .italic()
                .foregroundColor(content.color)
                .padding(.top, 5)
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getBrandContent(for category: Int) -> (title: String, emoji: String, vibe: String, brands: [(name: String, signature: String, personality: String)], tip: String, color: Color) {
        switch category {
        case 0: // Premium
            return (
                title: "Premium Experience",
                emoji: "👑",
                vibe: "For when you want to treat yourself and impress others",
                brands: [
                    (name: "HeyTea", signature: "Cheese foam pioneer", personality: "The trendsetter that made bubble tea cool for adults"),
                    (name: "Nayuki", signature: "Fresh fruit + soft bread", personality: "Instagram-perfect aesthetic for refined taste"),
                    (name: "LeLecha", signature: "Dirty brown sugar series", personality: "The artsy choice for creative types"),
                    (name: "ChayiYuese", signature: "Changsha cultural icon", personality: "Local pride meets innovative flavors")
                ],
                tip: "Perfect for dates, business meetings, or feeling fancy",
                color: .purple
            )
        case 1: // Affordable
            return (
                title: "Smart Value Champions",
                emoji: "💝",
                vibe: "Great taste without breaking the bank",
                brands: [
                    (name: "COCO", signature: "Taiwanese classic reliability", personality: "The Honda of bubble tea - consistent and trustworthy"),
                    (name: "Yi Dian Dian", signature: "Student-friendly pricing", personality: "Your reliable daily driver with solid flavors"),
                    (name: "Mixue", signature: "¥3 miracle drinks", personality: "How is this even profitable? But somehow delicious"),
                    (name: "Sweet LaLa", signature: "Tier-2 city champion", personality: "Proves you don't need Shanghai to make great tea")
                ],
                tip: "Perfect for daily consumption and introducing friends",
                color: .green
            )
        case 2: // Local Gems
            return (
                title: "Hidden Local Treasures",
                emoji: "💎",
                vibe: "Discover authentic regional flavors and stories",
                brands: [
                    (name: "Answer Tea", signature: "Fortune-telling bubble tea", personality: "Because why not get life advice with your drink?"),
                    (name: "Shanghai Auntie", signature: "Local Shanghai flavor", personality: "Captures the essence of old Shanghai in a cup"),
                    (name: "Yihetang", signature: "Hunan spicy-sweet fusion", personality: "Brings that Hunan boldness to bubble tea"),
                    (name: "Guming", signature: "Jiangnan generous portions", personality: "Where bigger is always better")
                ],
                tip: "Ask locals for their favorite neighborhood spot",
                color: .orange
            )
        case 3: // Trending
            return (
                title: "Innovation Leaders",
                emoji: "🚀",
                vibe: "The cutting edge of bubble tea evolution",
                brands: [
                    (name: "Heytea", signature: "New Chinese tea culture", personality: "Making traditional tea cool again for Gen Z"),
                    (name: "Jasmine White", signature: "Elegant jasmine base", personality: "Sophistication meets accessibility"),
                    (name: "Seven Sweet", signature: "Taiwan hand-shaken", personality: "Artisanal approach to every cup"),
                    (name: "Tiger Sugar", signature: "Brown sugar tiger stripes", personality: "The Instagram phenomenon that started global trend")
                ],
                tip: "Follow these to see where bubble tea culture is heading",
                color: .blue
            )
        default:
            return (title: "", emoji: "", vibe: "", brands: [], tip: "", color: .gray)
        }
    }
    
    private func flavorGuide(for category: Int) -> some View {
        let content = getFlavorContent(for: category)
        
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
                ForEach(content.flavors, id: \.name) { flavor in
                    HStack(alignment: .top, spacing: 8) {
                        Text("🥤")
                            .font(.caption)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("**\(flavor.name)**: \(flavor.description)")
                                .font(.body)
                            Text(flavor.experience)
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                }
            }
            
            Text("💫 \(content.personalityTip)")
                .font(.callout)
                .italic()
                .foregroundColor(content.color)
                .padding(.top, 5)
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getFlavorContent(for category: Int) -> (title: String, emoji: String, description: String, flavors: [(name: String, description: String, experience: String)], personalityTip: String, color: Color) {
        switch category {
        case 0: // Beginner Safe
            return (
                title: "Beginner-Friendly Classics",
                emoji: "🤗",
                description: "Start your bubble tea journey with these crowd-pleasers",
                flavors: [
                    (name: "Pearl Milk Tea", description: "The original that started it all", experience: "Sweet, creamy, with chewy tapioca pearls"),
                    (name: "Taro Milk Tea", description: "Purple and nutty with vanilla notes", experience: "Like drinking liquid ice cream"),
                    (name: "Brown Sugar Milk Tea", description: "Caramelized sweetness meets fresh milk", experience: "Instagram-worthy and comforting"),
                    (name: "Coconut Milk Tea", description: "Tropical and refreshing", experience: "Beach vacation in a cup")
                ],
                personalityTip: "These say: 'I'm approachable and enjoy life's simple pleasures'",
                color: .blue
            )
        case 1: // Adventurous
            return (
                title: "For the Flavor Adventurers",
                emoji: "🌶️",
                description: "Ready to push your taste boundaries?",
                flavors: [
                    (name: "Cheese Foam Series", description: "Salty cheese foam meets sweet tea", experience: "Weird at first, then completely addictive"),
                    (name: "Dirty Tea", description: "Brown sugar syrup creates marbled patterns", experience: "Drinking art that tastes like heaven"),
                    (name: "Salted Caramel", description: "Sweet meets salty perfection", experience: "Sophisticated comfort food"),
                    (name: "Matcha Red Bean", description: "Earthy green tea with sweet beans", experience: "Japanese elegance in Chinese format")
                ],
                personalityTip: "These say: 'I'm confident and love trying new experiences'",
                color: .red
            )
        case 2: // Instagram Worthy
            return (
                title: "Instagram-Worthy Showstoppers",
                emoji: "📸",
                description: "For when your drink needs to be as photogenic as you",
                flavors: [
                    (name: "Galaxy Tea", description: "Color-changing butterfly pea flower magic", experience: "Drinking a science experiment"),
                    (name: "Strawberry Layered", description: "Pink gradients that don't mix", experience: "Looks too pretty to drink (but drink it anyway)"),
                    (name: "Gold Flake Tea", description: "Actual edible gold in your drink", experience: "Peak luxury flex"),
                    (name: "Tie-Dye Series", description: "Multiple colors swirled together", experience: "Psychedelic in the best way")
                ],
                personalityTip: "Your feed is curated and you know it - embrace the aesthetic lifestyle",
                color: .pink
            )
        case 3: // Seasonal
            return (
                title: "Seasonal Sensations",
                emoji: "🌸",
                description: "Limited-time flavors that capture the moment",
                flavors: [
                    (name: "Cherry Blossom (Spring)", description: "Delicate floral notes with pink petals", experience: "Spring in Tokyo vibes"),
                    (name: "Mango Sticky Rice (Summer)", description: "Thai dessert in liquid form", experience: "Tropical vacation nostalgia"),
                    (name: "Osmanthus Oolong (Autumn)", description: "Traditional Chinese flower meets premium tea", experience: "Ancient elegance meets modern convenience"),
                    (name: "Hot Spiced Chai (Winter)", description: "Warming spices meet milk tea", experience: "Cozy fireplace feelings")
                ],
                personalityTip: "You live in the moment and appreciate life's fleeting experiences",
                color: .orange
            )
        default:
            return (title: "", emoji: "", description: "", flavors: [], personalityTip: "", color: .gray)
        }
    }
    
    private func customizationGuide(for type: Int) -> some View {
        let content = getCustomizationContent(for: type)
        
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
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(content.options, id: \.level) { option in
                    VStack(alignment: .leading, spacing: 2) {
                        Text("**\(option.level)**: \(option.effect)")
                            .font(.body)
                        Text(option.personality)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .italic()
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Text("🎯 \(content.proTip)")
                .font(.callout)
                .italic()
                .foregroundColor(content.color)
                .padding(.top, 5)
        }
        .padding()
        .background(content.color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func getCustomizationContent(for type: Int) -> (title: String, emoji: String, description: String, options: [(level: String, effect: String, personality: String)], proTip: String, color: Color) {
        switch type {
        case 0: // Sweetness
            return (
                title: "Sweetness Levels",
                emoji: "🍯",
                description: "Your sweetness choice reveals your personality",
                options: [
                    (level: "Full Sugar (100%)", effect: "Dessert-level sweetness", personality: "You live life to the fullest, consequences be damned"),
                    (level: "70% Sugar", effect: "Standard sweetness", personality: "Balanced and sensible - the safe choice"),
                    (level: "Half Sugar (50%)", effect: "Mildly sweet", personality: "Health-conscious but still want to enjoy life"),
                    (level: "30% Sugar", effect: "Just a hint of sweetness", personality: "Sophisticated palate, probably drinks wine"),
                    (level: "No Sugar (0%)", effect: "Pure tea flavor", personality: "Discipline incarnate or health concerns")
                ],
                proTip: "Start at 70%, then adjust based on tolerance and goals",
                color: .yellow
            )
        case 1: // Temperature
            return (
                title: "Temperature Choices",
                emoji: "🌡️",
                description: "Ice levels affect both taste and health",
                options: [
                    (level: "Regular Ice", effect: "Cold and refreshing", personality: "No-nonsense, practical person"),
                    (level: "Less Ice", effect: "Cool but not freezing", personality: "You think ahead and plan well"),
                    (level: "No Ice", effect: "Room temperature", personality: "Health-first mindset, into TCM"),
                    (level: "Hot", effect: "Warm and comforting", personality: "Traditional values, seeks comfort"),
                    (level: "Warm", effect: "Gently heated", personality: "Compromise master, diplomat type")
                ],
                proTip: "Less ice in summer, warm in winter - your stomach will thank you",
                color: .cyan
            )
        case 2: // Toppings
            return (
                title: "Topping Personalities",
                emoji: "🧋",
                description: "Your topping choice is basically a personality test",
                options: [
                    (level: "Tapioca Pearls", effect: "Chewy, satisfying texture", personality: "Classic choice - reliable and fun"),
                    (level: "Coconut Jelly", effect: "Light, bouncy texture", personality: "Health-conscious with good taste"),
                    (level: "Pudding", effect: "Creamy, dessert-like", personality: "Comfort-seeking, probably loves hugs"),
                    (level: "Red Beans", effect: "Natural sweetness, filling", personality: "Traditional values, appreciates authenticity"),
                    (level: "Popping Pearls", effect: "Burst of flavor", personality: "Fun-loving, probably good at parties")
                ],
                proTip: "Mix toppings for textural adventure - but expect weird looks",
                color: .purple
            )
        case 3: // Base
            return (
                title: "Base Tea Choices",
                emoji: "🍵",
                description: "The foundation reveals your sophistication level",
                options: [
                    (level: "Black Tea Base", effect: "Strong, robust flavor", personality: "Coffee drinker transitioning to tea"),
                    (level: "Green Tea Base", effect: "Light, refreshing", personality: "Health-conscious, probably does yoga"),
                    (level: "Oolong Base", effect: "Complex, nuanced", personality: "Sophisticated palate, appreciates subtlety"),
                    (level: "Fresh Milk Base", effect: "Creamy, rich", personality: "Comfort-first, practical choice"),
                    (level: "Herbal Base", effect: "Caffeine-free, unique", personality: "Wellness focused or caffeine sensitive")
                ],
                proTip: "Oolong for complexity, black tea for strength, green for health",
                color: .green
            )
        default:
            return (title: "", emoji: "", description: "", options: [], proTip: "", color: .gray)
        }
    }
    
    private func psychologyCard(aspect: String, explanation: String, science: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(aspect)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            Text(explanation)
                .font(.body)
            
            Text("The Science: \(science)")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func insiderTipCard(title: String, tip: String, reason: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.yellow)
            
            Text(tip)
                .font(.body)
                .fontWeight(.medium)
            
            Text("Why: \(reason)")
                .font(.caption)
                .foregroundColor(.secondary)
                .italic()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func healthFactCard(fact: String, impact: String, solution: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("⚠️ \(fact)")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.red)
            
            Text("Impact: \(impact)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Better Choice: \(solution)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.green)
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }
}

struct BubbleTeaCultureArticleView_Previews: PreviewProvider {
    static var previews: some View {
        BubbleTeaCultureArticleView()
    }
}