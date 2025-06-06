//
//  RestaurantBookingArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct RestaurantBookingArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header image area
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "building.2.crop.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Restaurant Booking Guide")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Article content
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Restaurant Booking Basics
                        ArticleSection(title: "Restaurant Booking: Smart Choice to Avoid Queues", content: """
                        **Why Book Restaurants?**
                        Popular restaurants in China are often full, especially trending spots and traditional famous restaurants! Booking ahead ensures a table, avoids queuing, and makes dining more enjoyable.
                        
                        **Booking Benefits**
                        • **Guaranteed Seating**: No worries about availability during peak hours 💺
                        • **Time Saving**: Avoid long on-site waiting ⏰
                        • **Room Choice**: Book special seating or private rooms 🏠
                        • **Special Requests**: Inform dietary restrictions and special needs in advance 🍽️
                        
                        **Ideal Booking Scenarios**
                        • **Trending Restaurants**: Popular spots from Xiaohongshu, Douyin 📱
                        • **Fine Dining**: Michelin, Black Pearl rated restaurants ⭐
                        • **Group Dining**: Multiple guests, business meals 👥
                        • **Holiday Dining**: Spring Festival, Mid-Autumn Festival etc. 🎊
                        
                        **Restaurant Types**
                        • **Full-Service**: Chinese, Western, Japanese-Korean cuisine 🍜
                        • **Hot Pot**: Haidilao, Xiabuxiabu chains 🍲
                        • **Tea Houses**: Hong Kong style tea restaurants, Cantonese dim sum 🍵
                        • **Theme Restaurants**: Special decor, cultural themes 🎭
                        
                        💡 **Booking Tip**: Book 1-3 days ahead for safety, popular spots may need a week!
                        """)
                        
                        ImagePlaceholder(title: "Restaurant Booking in China")
                        
                        // Booking Platforms
                        ArticleSection(title: "Booking Platforms: Finding the Right Channel", content: """
                        **Dianping (Most Comprehensive)**
                        • **Complete Info**: Dishes, prices, reviews, photos detailed 📸
                        • **Easy Booking**: Online seat selection, time slots 🕐
                        • **Many Deals**: Group buys, vouchers, point redemption 💰
                        • **Real Reviews**: User reviews help selection ⭐
                        
                        **Meituan (Best Value)**
                        • **Price Advantage**: Frequent discount activities 💸
                        • **Delivery Option**: Book + takeout dual choice 🛵
                        • **Easy Payment**: WeChat, Alipay, bank cards 💳
                        • **Flexible Cancel**: Easier to change plans 🔄
                        
                        **Ele.me**
                        • **Alibaba System**: Links with Taobao, Alipay 🔗
                        • **Member Benefits**: 88VIP special discounts 👑
                        • **Location Based**: Recommendations by location 📍
                        • **Instant Book**: Some restaurants support immediate booking ⚡
                        
                        **Official Restaurant Channels**
                        • **Phone Booking**: Direct call to restaurant front desk 📞
                        • **WeChat Mini-Program**: Restaurant's own booking system 📱
                        • **Official Website**: High-end restaurants usually have websites 💻
                        • **On-site Booking**: Book next visit while at restaurant 🏪
                        
                        **International Platforms**
                        • **OpenTable**: Some international restaurants support 🌍
                        • **Quandoo**: European booking platform's China service 🇪🇺
                        • **Hotel Concierge**: Five-star hotels can book for you 🏨
                        • **Travel Platforms**: Ctrip, Qunar also offer restaurant booking ✈️
                        
                        🎯 **Platform Choice**: Dianping for reviews, Meituan for deals, official channels for high-end!
                        """)
                        
                        ImagePlaceholder(title: "Restaurant Booking Platforms")
                        
                        // Booking Process
                        ArticleSection(title: "Booking Process: From Selection to Dining", content: """
                        **Choose Restaurant**
                        • **Check Rating**: 4.5+ stars generally reliable ⭐
                        • **Read Reviews**: Focus on recent and photo reviews 📝
                        • **Location Check**: Choose convenient location 🗺️
                        • **Menu Review**: Preview dishes and prices 📋
                        
                        **Booking Information**
                        • **Dining Time**: Select exact date and time slot 📅
                        • **Party Size**: Accurate number affects seating 👥
                        • **Contact Info**: Leave valid phone number 📱
                        • **Special Needs**: Vegetarian, high chair, private room 📝
                        
                        **Confirm Booking**
                        • **Get Confirmation**: Wait for restaurant confirmation ✅
                        • **Save Proof**: Screenshot booking confirmation 📸
                        • **Set Reminder**: Phone reminder before meal ⏰
                        • **Know Policy**: Check cancellation and change policies 📄
                        
                        **At Restaurant**
                        • **Arrive Early**: 5-10 minutes before booking 🕐
                        • **Show Booking**: Show booking info to staff 📱
                        • **Verify Details**: Check party size and seating 🪑
                        • **Start Dining**: Begin meal as arranged 🍽️
                        
                        **After Dining**
                        • **Payment**: Confirm bill, choose payment method 💳
                        • **Review**: Give honest platform review ⭐
                        • **Keep Receipt**: Remember invoice for business meals 🧾
                        • **Share Experience**: Recommend to friends 👫
                        
                        💪 **Success Key**: Detailed info, punctuality, polite communication!
                        """)
                        
                        ImagePlaceholder(title: "Restaurant Booking Process")
                        
                        // Foreigner's Guide
                        ArticleSection(title: "Foreigner's Guide: Avoiding Language & Cultural Barriers", content: """
                        **Language Prep**
                        • **Chinese Address**: Save restaurant's Chinese name and address 📍
                        • **Key Words**: Booking, dining, bill in Chinese 🗣️
                        • **Translation Tool**: Prepare translation app backup 📱
                        • **Numbers**: Learn Chinese numbers for communication 🔢
                        
                        **Cultural Understanding**
                        • **Meal Times**: Chinese lunch 12-2pm, dinner 6-8pm 🕐
                        • **Seating Custom**: Round table culture, host faces door 🪑
                        • **Ordering Amount**: Usually dishes = people + 1 📝
                        • **Split Bill**: Young people prefer splitting, business meals hosted 💰
                        
                        **Dietary Restrictions**
                        • **Vegetarian**: Vegetarian (素食主义者) 🥬
                        • **Religious**: No pork (不吃猪肉), Halal (清真) 🚫
                        • **Allergies**: Allergic to seafood (海鲜过敏) ⚠️
                        • **Spice Level**: Not spicy (不要辣), Mild spicy (微辣) 🌶️
                        
                        **Payment Methods**
                        • **Mobile Pay**: WeChat, Alipay most convenient 📱
                        • **Bank Cards**: Most accept UnionPay cards 💳
                        • **Cash**: Prepare cash as backup 💰
                        • **Invoice**: Invoice (发票) for business 🧾
                        
                        **Emergency Handling**
                        • **Cancel Booking**: Cancel 2+ hours ahead ❌
                        • **Change Party Size**: Call restaurant promptly 📞
                        • **Late Arrival**: Call ahead, try to hold table ⏰
                        • **Complaints**: Via platform or 12315 consumer hotline 📱
                        
                        ⚠️ **Important Note**: Respect local dining culture, stay patient and polite!
                        """)
                        
                        ImagePlaceholder(title: "Foreigner's Restaurant Guide")
                        
                        // Restaurant Types
                        ArticleSection(title: "Restaurant Types: Choose Your Best Dining Experience", content: """
                        **Chinese Cuisine**
                        • **Cantonese**: Light and fresh, good for non-spicy eaters 🦐
                        • **Sichuan**: Numbing spicy, taste challenge 🌶️
                        • **Beijing**: Imperial style, Peking duck specialty 🦆
                        • **Jiangzhe**: Sweet taste, delicate portions 🐟
                        
                        **Hot Pot**
                        • **Sichuan Hot Pot**: Spicy numbing, social dining 🍲
                        • **Beijing Style**: Clear broth, rich dipping sauce 🥩
                        • **Hong Kong Style**: Seafood focus, light broth 🦀
                        • **Korean Style**: Kimchi based, youth favorite 🥬
                        
                        **International Cuisine**
                        • **Japanese**: Sushi, sashimi, wagyu 🍣
                        • **Korean**: BBQ, stone bowl rice, fried chicken 🥩
                        • **Western**: Steak, pasta, salads 🥩
                        • **Southeast Asian**: Thai, Vietnamese, Indian 🌿
                        
                        **Special Snacks**
                        • **Tea House**: Hong Kong dim sum, morning tea 🥟
                        • **Noodle Shop**: Regional noodles, quick meal 🍜
                        • **BBQ**: Night culture, beer and BBQ 🍢
                        • **Dessert Shop**: Hong Kong style, Taiwan style 🍮
                        
                        **High-End Dining**
                        • **Michelin**: International certification, top experience ⭐
                        • **Black Pearl**: China's Michelin equivalent 🖤
                        • **Hotel Restaurants**: Top service, elegant environment 🏨
                        • **Private Kitchen**: Home-style cooking, reservation only 🏠
                        
                        🌟 **Selection Tip**: Choose based on taste preference, budget and occasion!
                        """)
                        
                        ImagePlaceholder(title: "Restaurant Types Classification")
                        
                        // Dining Etiquette
                        ArticleSection(title: "Dining Etiquette: Show International Guest Class", content: """
                        **Seating Etiquette**
                        • **Wait to be Seated**: Let staff arrange seating 💺
                        • **Guest Honor**: Guest sits facing door (honor position) 👑
                        • **Elder Priority**: Let elders be seated first 👴
                        • **Ladies First**: Gentlemanly courtesy for women 👩
                        
                        **Ordering Etiquette**
                        • **Ask Restrictions**: Check dietary restrictions first ❓
                        • **Balance**: Balance meat and vegetables, flavors 🥗
                        • **Right Amount**: Avoid waste, order by headcount 📏
                        • **Price Consider**: When hosting, choose mid-high range 💰
                        
                        **Dining Etiquette**
                        • **Serving Chopsticks**: Use public chopsticks for serving 🥢
                        • **Toast Culture**: Appropriate toasting shows respect 🍻
                        • **Eating Pace**: Don't rush, maintain elegance 🍽️
                        • **Conversation**: Moderate chat enhances relationships 💬
                        
                        **Chopstick Use**
                        • **Correct Hold**: Learn basic chopstick technique 🥢
                        • **Taboo Actions**: Don't point or drum with chopsticks ❌
                        • **Rest Position**: Rest flat on bowl edge when pausing 📍
                        • **Ask Help**: Request fork if needed 🍴
                        
                        **Payment Etiquette**
                        • **Bill Fight**: Hosting is important in Chinese culture 💰
                        • **Show Thanks**: Express gratitude when treated 🙏
                        • **Split Bill**: Mention splitting beforehand 💳
                        • **No Tipping**: Tipping not needed in Chinese restaurants 🚫
                        
                        💖 **Etiquette Spirit**: Respect local culture, show international guest class!
                        """)
                        
                        ImagePlaceholder(title: "Dining Etiquette Culture")
                        
                        // Cultural Experience
                        ArticleSection(title: "Cultural Experience: Understanding China Through Food", content: """
                        **Food Culture Meaning**
                        • **Food Therapy**: Chinese believe food can heal body 🌿
                        • **Seasonal Eating**: Choose ingredients by season 🍂
                        • **Complete Art**: Pursue visual and taste perfection 🎨
                        • **Symbolism**: Many dish names have lucky meanings 🍀
                        
                        **Regional Features**
                        • **South Sweet North Salty**: South sweeter, North saltier 🗺️
                        • **Sichuan Hunan Spicy**: Sichuan numbing, Hunan pure spicy 🌶️
                        • **Cantonese Refined**: Guangdong cuisine delicate, light 💎
                        • **Northeast Hearty**: Large portions, strong flavors 💪
                        
                        **Festival Food**
                        • **Spring Festival**: Family reunion, lucky dishes 🧧
                        • **Mid-Autumn**: Mooncakes symbolize reunion 🥮
                        • **Dragon Boat**: Zongzi to remember Qu Yuan 🍃
                        • **Winter Solstice**: Northern dumplings tradition 🥟
                        
                        **Business Culture**
                        • **Hosting Culture**: Important in business settings 💼
                        • **Drinking Culture**: Important in business meals 🍷
                        • **Seating Arrangement**: Shows rank and respect 🪑
                        • **Toast Order**: Fixed toasting etiquette 🥂
                        
                        **Social Function**
                        • **Build Relations**: Chinese build bonds through dining 👥
                        • **Problem Solving**: Many issues solved at dinner table 🤝
                        • **Celebrations**: Important events celebrated with meals 🎉
                        • **Cultural Exchange**: Different cultures meet at table 🌍
                        
                        **Modern Changes**
                        • **Health Focus**: Youth more nutrition conscious 🥗
                        • **Social Media**: Social media influences restaurant choice 📱
                        • **Global Fusion**: Chinese-foreign cuisine fusion 🌐
                        • **Green Concept**: Reduce waste, clean plate campaign ♻️
                        
                        🎊 **Deep Experience**: Understanding China through food is the tastiest cultural journey!
                        """)
                        
                        ImagePlaceholder(title: "Restaurant Cultural Experience")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Restaurant Booking Guide")
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
    RestaurantBookingArticleView()
} 