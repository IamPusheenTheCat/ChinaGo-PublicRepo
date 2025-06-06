//
//  CulturalSitesArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct CulturalSitesArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.purple, .purple.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "theatermasks.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Cultural Sites")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        ArticleSection(
                            title: "🏛️ The Charm of Cultural Sites",
                            content: """
                            China has 5000 years of rich history, with cultural sites spread throughout the country, offering visitors deep cultural experiences.

                            **Cultural Value:**
                            • World Cultural Heritage: Great Wall, Forbidden City, Terracotta Warriors
                            • Ancient Building Complexes: Temples, Palaces, Garden Art
                            • Historical Relics: Precious Artifacts and Art Treasures
                            • Cultural Heritage: Traditional Skills Live Demonstrations
                            • Educational Significance: Historical Knowledge and Cultural Connotations

                            **Visiting Advantages:**
                            • Professional Interpretation: Chinese and English Guide Services
                            • Digital Experience: AR/VR Interactive Displays
                            • Cultural Activities: Traditional Festivals and Cultural Performances
                            • Shopping Souvenirs: Unique Cultural Creative Products
                            • Photography Value: Excellent Photo Opportunities
                            """
                        )
                        
                        ImagePlaceholder(title: "Chinese Cultural Sites")
                        
                        ArticleSection(
                            title: "🎯 Types of Cultural Sites",
                            content: """
                            Understanding different types of cultural sites to make reasonable visiting plans.

                            **Historical Sites:**
                            • **Great Wall**: World Cultural Heritage, Defense Engineering Marvel
                            • **Forbidden City**: Ming and Qing Imperial Palace, Classic Ancient Architecture
                            • **Terracotta Warriors**: Qin Dynasty Army Formation, Major Archaeological Discovery
                            • **Temple of Heaven**: Imperial Altar, Combination of Architecture and Astronomy

                            **Religious Cultural Sites:**
                            • **Shaolin Temple**: Chan Buddhism Ancestral Temple, Martial Arts Origin
                            • **White Horse Temple**: China's First Ancient Temple
                            • **Potala Palace**: Tibetan Buddhism Holy Site
                            • **Wudang Mountain**: Taoist Holy Site, Tai Chi Origin

                            **Garden Art:**
                            • **Suzhou Gardens**: Jiangnan Private Garden Art
                            • **Summer Palace**: Imperial Garden Model
                            • **Humble Administrator's Garden**: Garden Art Masterpiece
                            • **Master of Nets Garden**: Small Garden Representative

                            **Museums:**
                            • **National Museum**: Chinese Civilization History
                            • **Shanghai Museum**: Ancient Art Treasures
                            • **Shaanxi History Museum**: Ancient Capital Artifacts
                            • **Hunan Provincial Museum**: Mawangdui Han Tomb Artifacts
                            """
                        )
                        
                        ImagePlaceholder(title: "Types of Cultural Sites")
                        
                        ArticleSection(
                            title: "🎫 Ticket Booking Strategy",
                            content: """
                            Master ticket booking skills to avoid missing desired sites.

                            **Online Booking Platforms:**
                            • **Official Websites**: Site Official Ticket Platforms
                            • **Ctrip/Qunar**: Travel Platforms, Price Comparison
                            • **Meituan/Dianping**: Local Life Platforms
                            • **WeChat Mini Programs**: Site Official Mini Programs

                            **Booking Process:**
                            1. **Choose Date** → Check Available Time Slots
                            2. **Select Ticket Type** → Adult, Student, Discount Tickets
                            3. **Fill Information** → Name, ID Document Number
                            4. **Online Payment** → Alipay, WeChat, Bank Card
                            5. **Get Voucher** → E-ticket or Collection Code

                            **💡 Booking Tips:**
                            • Book Popular Sites 1-7 Days in Advance
                            • More Advanced Planning Needed for Holidays
                            • Watch for Promotions and Package Deals
                            • Student Discounts Available (Some Sites)
                            • Group Tickets Usually Discounted

                            **⚠️ Important Notes:**
                            • Real-name Ticket Purchase, Passport Info Required
                            • Some Sites Have Flow Control, Need Visit Time Reservation
                            • Refund/Change Policies Vary by Site
                            • Keep E-tickets and Confirmation Information
                            """
                        )
                        
                        ImagePlaceholder(title: "Ticket Booking Strategy")
                        
                        ArticleSection(
                            title: "🚌 Transportation & Arrival",
                            content: """
                            Plan transportation routes reasonably for efficient arrival at cultural sites.

                            **Public Transportation:**
                            • **Subway**: Major City Sites Have Direct Subway Access
                            • **Bus**: Wide Coverage, Economical
                            • **Tourist Lines**: Special Tourist Buses for Some Sites
                            • **Taxi/Ride-hailing**: Convenient but Higher Cost

                            **Independent Travel Transportation:**
                            • **High-speed Rail/Train**: Inter-city Site Visits
                            • **Long-distance Bus**: Reaching Remote Sites
                            • **Car Rental**: Flexible (Chinese License Required)
                            • **Charter Service**: Suitable for Group Tours

                            **Site Internal Transportation:**
                            • **Walking Tours**: Recommended for Small Sites
                            • **Sightseeing Cars**: Internal Transport in Large Sites
                            • **Cable Cars**: Mountain Sites
                            • **Boats**: Water Sites and Gardens

                            **💡 Transportation Tips:**
                            • Use Gaode Maps or Baidu Maps for Navigation
                            • Download Official Site Apps for Internal Maps
                            • Avoid Rush Hour Periods
                            • Have Backup Transportation Plans for Congestion
                            """
                        )
                        
                        ImagePlaceholder(title: "Transportation Guide")
                        
                        ArticleSection(
                            title: "👥 Guide Service Selection",
                            content: """
                            Choose suitable guide services for deep understanding of cultural content.

                            **Official Guide Services:**
                            • **Chinese Guides**: Professional Interpretation, Moderate Cost
                            • **English Guides**: Foreign Language Service, Higher Price
                            • **VIP Guides**: Personalized Service, In-depth Interpretation
                            • **Group Guides**: Group Service, Economical

                            **Self-guided Tools:**
                            • **Audio Guides**: Site Rental, Multiple Language Options
                            • **Mobile Apps**: Free Download, Listen Anytime
                            • **WeChat Mini Programs**: Scan to Listen, Convenient
                            • **AR Guides**: Tech Experience, Interactive

                            **Guide Content Features:**
                            • **Historical Background**: Artifact History and Time Context
                            • **Architectural Art**: Craftsmanship and Artistic Value
                            • **Cultural Stories**: Legends and Historical Figures
                            • **Visit Routes**: Optimal Tour Path Recommendations

                            **🌟 Guide Suggestions:**
                            • Choose Professional Guides for Important Sites
                            • Combine Multiple Guide Methods for Self-guided Tours
                            • Learn Core Highlights Before Visit
                            • Prepare Notebook for Important Information
                            """
                        )
                        
                        ImagePlaceholder(title: "Guide Service Selection")
                        
                        ArticleSection(
                            title: "📸 Visit Etiquette & Rules",
                            content: """
                            Follow visit etiquette, protect cultural heritage, respect traditional culture.

                            **Basic Etiquette:**
                            • **Keep Quiet**: Avoid Loud Noise
                            • **Orderly Visit**: Follow Designated Routes
                            • **Queue Up**: Follow Order, Civilized Visit
                            • **Respect Others**: Don't Crowd Photo Spots

                            **Photography Rules:**
                            • **No-photo Areas**: Strictly Follow Photo Restrictions
                            • **Flash Restrictions**: Protect Artifacts, No Flash
                            • **Commercial Photography**: Special Permission Required
                            • **Portrait Photos**: Get Others' Consent

                            **Artifact Protection:**
                            • **No Touching**: Don't Touch Artifacts and Exhibits
                            • **Keep Distance**: Maintain Safe Distance from Artifacts
                            • **Protect Facilities**: No Climbing or Carving on Buildings
                            • **Garbage Disposal**: No Littering

                            **Special Requirements for Religious Sites:**
                            • **Proper Dress**: Dress Modestly, Avoid Revealing Clothes
                            • **Hat Etiquette**: Remove Hats in Temples as Respect
                            • **Quiet Prayer**: Respect Worshippers' Religious Activities
                            • **No Food**: Some Areas Prohibit Food and Drink

                            **⚠️ Important Reminders:**
                            • Follow Site Rules, Cooperate with Staff
                            • Protecting Cultural Heritage is Everyone's Responsibility
                            • Civilized Visit Shows Good Quality
                            • Seek Staff Help for Emergencies
                            """
                        )
                        
                        ImagePlaceholder(title: "Visit Etiquette Rules")
                        
                        ArticleSection(
                            title: "🎨 Cultural Creative Products",
                            content: """
                            Select meaningful cultural creative products for memorable souvenirs.

                            **Cultural Product Types:**
                            • **Artifact Replicas**: Museum Quality Reproductions
                            • **Cultural Items**: Bookmarks, Notebooks, Stationery
                            • **Artworks**: Paintings, Ceramics, Crafts
                            • **Daily Items**: Tea Sets, Scarves, Bags

                            **Purchase Locations:**
                            • **Site Shops**: Official Souvenir Stores
                            • **Museum Shops**: High-quality Cultural Products
                            • **Cultural Streets**: Traditional Craft Centers
                            • **Online Stores**: Official Shops and E-commerce

                            **Selection Tips:**
                            • **Cultural Content**: Choose Products with Cultural Meaning
                            • **Craft Quality**: Focus on Craftsmanship and Materials
                            • **Practical Value**: Consider Product Usefulness
                            • **Reasonable Price**: Compare Prices, Rational Consumption

                            **Popular Cultural Products:**
                            • **Palace Museum Products**: Imperial Element Designs
                            • **Dunhuang Products**: Silk Road Culture Theme
                            • **Terracotta Warriors Products**: Qin Dynasty Elements
                            • **Suzhou Garden Products**: Jiangnan Culture Features

                            **💡 Purchase Tips:**
                            • Compare Prices and Quality at Different Stores
                            • Watch for Limited Editions and Special Items
                            • Consider Carrying and Shipping Convenience
                            • Keep Purchase Receipts for After-sales
                            """
                        )
                        
                        ImagePlaceholder(title: "Cultural Creative Products")
                        
                        ArticleSection(
                            title: "🌟 Deep Cultural Experience",
                            content: """
                            Beyond sightseeing, deeply experience Chinese culture essence.

                            **Cultural Activity Participation:**
                            • **Traditional Festivals**: Spring Festival, Mid-Autumn Festival Activities
                            • **Cultural Shows**: Beijing Opera, Kunqu Opera, Folk Dance
                            • **Hands-on Experience**: Calligraphy, Painting, Paper-cutting, Pottery
                            • **Tea Ceremony**: Chinese Tea Culture Experience

                            **Learning Opportunities:**
                            • **Cultural Lectures**: Expert Scholar Cultural Explanations
                            • **Archaeological Experience**: Participate in Archaeological Excavations
                            • **Artifact Restoration**: Learn Artifact Protection Techniques
                            • **Traditional Crafts**: Learn Traditional Handicrafts

                            **Cultural Exchange:**
                            • **International Friends**: Interact with Visitors from Around the World
                            • **Local Residents**: Understand Local Cultural Concepts
                            • **Cultural Volunteers**: Participate in Cultural Spread Activities
                            • **Academic Discussions**: Join Cultural Academic Activities

                            **Spiritual Cultural Experience:**
                            • **Zen Experience**: Experience Zen Culture in Temples
                            • **Tai Chi Health**: Learn Chinese Traditional Health Methods
                            • **Calligraphy Meditation**: Experience Chinese Culture Through Calligraphy
                            • **Garden Aesthetics**: Experience Chinese Aesthetics in Gardens

                            **🎭 Experience Suggestions:**
                            • Maintain Open and Inclusive Attitude
                            • Actively Participate in Interactive Experiences
                            • Respect and Learn Traditional Culture
                            • Record and Share Cultural Insights
                            """
                        )
                        
                        ImagePlaceholder(title: "Deep Cultural Experience")
                        
                        ArticleSection(
                            title: "📚 Cultural Background Knowledge",
                            content: """
                            Understand cultural background for more meaningful and deep visits.

                            **Historical Dynasty Timeline:**
                            • **Xia-Shang-Zhou**: Chinese Civilization Origin (2070-256 BC)
                            • **Qin-Han**: Unified Empire Establishment (221 BC-220 AD)
                            • **Wei-Jin-Southern-Northern**: Cultural Integration Period (220-589)
                            • **Sui-Tang**: Golden Age Culture (581-907)
                            • **Song-Yuan-Ming-Qing**: Cultural Development & Heritage (960-1912)

                            **Core Cultural Concepts:**
                            • **Heaven-Human Unity**: Philosophy of Human-Nature Harmony
                            • **Golden Mean**: Balance, Harmony Philosophy
                            • **Benevolence-Righteousness-Propriety-Wisdom-Faith**: Traditional Moral Values
                            • **Yin-Yang Five Elements**: Ancient Philosophy and Science Theory

                            **Artistic Features:**
                            • **Symmetrical Aesthetics**: Chinese Architecture Symmetry
                            • **Freehand Style**: Chinese Painting Art Features
                            • **Artistic Conception**: Poetry and Garden Spiritual Pursuit
                            • **Craftsmanship Spirit**: Excellence in Making

                            **Religious Culture:**
                            • **Confucianism**: Governance Philosophy System
                            • **Buddhism**: Compassion and Wisdom Spiritual Pursuit
                            • **Taoism**: Natural Non-action Life Philosophy
                            • **Folk Beliefs**: Rich and Diverse Folk Culture

                            **📖 Learning Suggestions:**
                            • Learn Basic Historical Background Before Visit
                            • Read Related Cultural Books and Materials
                            • Watch Documentaries for Cultural Understanding
                            • Consult Professional Guides and Cultural Scholars
                            """
                        )
                        
                        ImagePlaceholder(title: "Cultural Background Knowledge")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Cultural Sites Guide")
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
}

#Preview {
    CulturalSitesArticleView()
} 