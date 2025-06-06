//
//  HostelArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct HostelArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "bed.double.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Youth Hostels")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // Youth Hostel Basics: Backpacker's Home
                        ArticleSection(title: "Youth Hostels: A Warm Haven for Backpackers", content: """
                        **What is a Youth Hostel?**
                        Youth Hostels are budget-friendly accommodations designed for young travelers! With affordable prices, friendly atmosphere, and active social life, they're the top choice for backpackers and students.
                        
                        **Hostel Advantages**
                        • **Affordable Price**: 30-80 yuan per night, excellent value 💰
                        • **Active Social Life**: Meet friends from around the world 👥
                        • **Complete Facilities**: Kitchen, laundry, lounge areas available 🏠
                        • **Prime Location**: Often near city centers or attractions 📍
                        
                        **Room Types**
                        • **Dormitories**: 4-12 bed rooms, most economical 🛏️
                        • **Single-Gender Rooms**: Male or female dorms, safe and comfortable 👥
                        • **Mixed Dorms**: Co-ed rooms, more social atmosphere 🌍
                        • **Private Rooms**: Double or single rooms, better privacy 🚪
                        
                        **Suitable For**
                        • **Backpackers**: Independent travelers on a budget 🎒
                        • **Students**: Current students, graduation trips 🎓
                        • **Social Butterflies**: People who love meeting new friends 🤝
                        • **Short-term Stays**: 1-7 day trips 📅
                        
                        💡 **Hostel Spirit:** More than just accommodation, it's a lifestyle and travel culture!
                        """)
                        
                        ImagePlaceholder(title: "Chinese Youth Hostels")
                        
                        // Booking Platforms: Multiple Channels
                        ArticleSection(title: "Booking Platforms: Finding Your Ideal Hostel", content: """
                        **International Booking Platforms**
                        • **Hostelworld**: World's largest hostel booking website 🌍
                        • **Booking.com**: Not just hotels, many hostel options too 🏨
                        • **YHA Official**: International Youth Hostel Association website 🏛️
                        • **Agoda**: Rich in Asian hostel resources 🏢
                        
                        **Chinese Platforms**
                        • **Qunar**: Most comprehensive domestic hostel resources ✈️
                        • **Ctrip**: Reliable traditional travel platform 🚄
                        • **eLong**: Notable price advantages 💰
                        • **Tongcheng**: Good coverage in tier 2-3 cities 🚌
                        
                        **Hostel Chain Brands**
                        • **City Youth Hostels**: Largest domestic hostel chain 🏙️
                        • **Panda International Hostels**: Famous brand from Chengdu 🐼
                        • **Backpacker Ten Years**: Focused on backpacker culture 🎒
                        • **YHA China**: International Hostel Association China Branch 🌐
                        
                        **Direct Booking**
                        • **Hostel Websites**: Book directly through hostel websites 💻
                        • **Phone Booking**: Call hostel front desk directly 📞
                        • **Walk-in**: Book on arrival (higher risk) 🚶
                        • **Friend Recommendations**: Backpacker community recommendations 👫
                        
                        **Booking Tips**
                        • **Book Ahead**: At least one week in advance during peak season 📅
                        • **Compare Prices**: Check multiple platforms, watch for hidden fees 💰
                        • **Read Reviews**: Focus on cleanliness and safety reviews ⭐
                        • **Check Location**: Choose convenient transport locations 🗺️
                        
                        🎯 **Selection Tips:** Check reviews on Hostelworld, compare prices on local platforms, trust chain brands!
                        """)
                        
                        ImagePlaceholder(title: "Hostel Booking Platforms")
                        
                        // Stay Experience: Youth and Vitality
                        ArticleSection(title: "Stay Experience: Feel the Youth and Energy", content: """
                        **Check-in Process**
                        • **ID Registration**: Show passport or ID card for registration 📘
                        • **Payment Methods**: Cash, bank cards, or mobile payment 💳
                        • **Deposit**: Usually 50-100 yuan deposit required 💰
                        • **Room Key**: Keep room key or password safe 🔑
                        
                        **Dormitory Life**
                        • **Bed Selection**: Top/bottom bunks have pros and cons 🛏️
                        • **Organize Items**: Make good use of lockers and space 🎒
                        • **Meet Roommates**: Introduce yourself friendly and proactively 👋
                        • **Follow Rules**: Learn and follow hostel regulations 📋
                        
                        **Public Facilities**
                        • **Shared Kitchen**: Cook your own meals to save money 👨‍🍳
                        • **Laundry Facilities**: Coin-operated washers or hand wash area 👕
                        • **Common Areas**: Lounge, game area, reading corner 📚
                        • **Internet Access**: WiFi password and connection speed 📶
                        
                        **Social Activities**
                        • **Make Friends**: Meet travelers from around the world 🌍
                        • **Share Experiences**: Exchange travel tips and stories 💬
                        • **Group Tours**: Explore attractions or find food together 👥
                        • **Cultural Exchange**: Learn about different cultures 🎭
                        
                        **Daily Etiquette**
                        • **Schedule**: Respect quiet hours, stay quiet after 10 PM 🤫
                        • **Personal Hygiene**: Keep personal and public areas clean 🧼
                        • **Valuables**: Use lockers for valuable items 🔒
                        • **Mutual Respect**: Respect roommates' schedules and habits 💖
                        
                        💪 **Stay Tips:** Open mind, friendly attitude, hostel life is full of adventures!
                        """)
                        
                        ImagePlaceholder(title: "Hostel Stay Experience")
                        
                        // Safety and Hygiene: Top Priority
                        ArticleSection(title: "Safety and Hygiene: Essential Hostel Guidelines", content: """
                        **Personal Safety**
                        • **Valuables**: Use lockers, keep important documents with you 💎
                        • **Night Safety**: Avoid going out alone at night, travel in groups 🌙
                        • **Strangers**: Stay alert, don't trust strangers easily ⚠️
                        • **Emergency Contacts**: Remember hostel front desk and local police numbers 📞
                        
                        **Hygiene Conditions**
                        • **Bed Cleanliness**: Check sheets and covers for cleanliness 🛏️
                        • **Bathrooms**: Monitor bathroom cleanliness and maintenance 🚿
                        • **Public Areas**: Observe cleanliness of common areas 🧹
                        • **Personal Protection**: Bring own towels, slippers, and personal items 🧴
                        
                        **Property Safety**
                        • **Locker Usage**: Valuable items must be locked in lockers 🔐
                        • **Cash Distribution**: Don't keep all cash in one place 💰
                        • **Electronic Devices**: Keep phones, cameras with you 📱
                        • **Insurance**: Buy travel insurance to protect belongings 🛡️
                        
                        **Health Protection**
                        • **Personal Items**: Bring own toiletries to avoid cross-contamination 🦷
                        • **Ventilation**: Choose well-ventilated rooms 💨
                        • **Disease Prevention**: Maintain personal hygiene, wear mask if needed 😷
                        • **Emergency Medical**: Know nearby hospital locations 🏥
                        
                        **Female Safety**
                        • **Female Dorms**: Prioritize female-only dormitories 👩
                        • **Travel Together**: Partner with other female travelers 👭
                        • **Trust Instincts**: Change accommodation if feeling unsafe 🚨
                        • **Family Contact**: Regular check-ins with family 👨‍👩‍👧‍👦
                        
                        🛡️ **Safety Principle:** Stay alert, trust your instincts, safety first, happy travels!
                        """)
                        
                        ImagePlaceholder(title: "Hostel Safety and Hygiene")
                        
                        // Hostel Culture: International Friendship
                        ArticleSection(title: "Hostel Culture: Bridge of Global Youth Friendship", content: """
                        **International Atmosphere**
                        • **Cultural Diversity**: Backpackers from around the world 🌍
                        • **Language Practice**: Great opportunity to practice English and Chinese 🗣️
                        • **Cultural Exchange**: Learn different countries' customs 🎭
                        • **Friendship Building**: Make lifelong international friends 👫
                        
                        **Hostel Activities**
                        • **Welcome Parties**: Welcome events for new guests 🎉
                        • **City Walks**: Hostel-organized city tours 🚶
                        • **Cooking Sharing**: International food cooking and sharing 👨‍🍳
                        • **Game Nights**: Board games, movies, music sharing 🎮
                        
                        **Knowledge Sharing**
                        • **Travel Tips**: Share travel experiences and advice 📚
                        • **Budget Tips**: Exchange money-saving travel methods 💰
                        • **Safety Reminders**: Share travel safety tips ⚠️
                        • **Cultural Introduction**: Introduce your country's culture 🏛️
                        
                        **Volunteer Spirit**
                        • **Mutual Help**: Assist travelers in need 🤝
                        • **Environmental Awareness**: Maintain hostel environment together 🌱
                        • **Cultural Respect**: Respect local culture and other travelers 💖
                        • **Sharing Philosophy**: Share resources, grow together 🌟
                        
                        **Social Networks**
                        • **Social Media**: Stay connected through various platforms 📱
                        • **Travel Groups**: Join backpacker WeChat or QQ groups 💬
                        • **Photo Sharing**: Share beautiful travel moments 📸
                        • **Future Meetups**: Meet again in other cities ✈️
                        
                        🌟 **Hostel Spirit:** Open and inclusive, helping each other, let travel become the start of friendship!
                        """)
                        
                        ImagePlaceholder(title: "Hostel Cultural Exchange")
                        
                        // City Recommendations: Popular Hostels
                        ArticleSection(title: "City Guide: Popular Hostel Destinations in China", content: """
                        **Beijing Hostels**
                        • **Hutong Hostels**: Experience old Beijing hutong culture 🏛️
                        • **International Hostels**: Near Tiananmen, Forbidden City 🎯
                        • **University Area**: Near Peking and Tsinghua Universities 🎓
                        • **Convenient Transport**: Along subway lines 🚇
                        
                        **Shanghai Hostels**
                        • **The Bund Area**: Enjoy Huangpu River night views 🌃
                        • **Tianzifang Hostels**: Strong artistic atmosphere 🎨
                        • **Xintiandi Area**: Modern fashionable district 🛍️
                        • **Metro Access**: Citywide subway network 🚇
                        
                        **Xi'an Hostels**
                        • **City Wall Area**: Feel ancient capital charm 🏰
                        • **Muslim Quarter**: Taste local specialties 🍜
                        • **Giant Wild Goose Pagoda**: Historical cultural area 🏛️
                        • **Terracotta Warriors**: Easy access to warriors 🏺
                        
                        **Chengdu Hostels**
                        • **Kuanzhai Alley**: Experience Sichuan culture 🐼
                        • **Chunxi Road**: Shopping and entertainment center 🛍️
                        • **Wuhou Temple**: Three Kingdoms culture experience ⚔️
                        • **Food Streets**: Taste authentic Sichuan cuisine 🌶️
                        
                        **Other Popular Cities**
                        • **Dali Old Town**: Romantic wind, flower, snow, moon 🌸
                        • **Lijiang Old Town**: Naxi culture experience 🏔️
                        • **Guilin Yangshuo**: Best landscape under heaven 🏞️
                        • **Xiamen Gulangyu**: Garden on the sea 🏖️
                        
                        🗺️ **Selection Tips:** Choose based on your route and interests, each city has its unique charm!
                        """)
                        
                        ImagePlaceholder(title: "Popular Hostel Cities")
                        
                        // Cultural Experience: Youth Memories
                        ArticleSection(title: "Cultural Experience: Youth Stories in Hostels", content: """
                        **Youth Memories**
                        • **First Solo Trip**: Many people's first independent travel 🎒
                        • **Unforgettable Friendships**: Friends become life's treasures 👫
                        • **Growth Experience**: Learn independence through travel 🌱
                        • **Precious Memories**: Cherished memories of youth 💫
                        
                        **Chinese Hostel Culture Features**
                        • **High Inclusivity**: Welcome travelers from worldwide 🌍
                        • **Budget-Friendly**: Affordable for more young people 💰
                        • **Thoughtful Service**: Provide various convenient services 💝
                        • **Safety Guarantee**: Focus on guest safety and privacy 🛡️
                        
                        **Social Value**
                        • **Cultural Exchange**: Promote international cultural exchange 🤝
                        • **Youth Development**: Platform for young people's growth 📈
                        • **Tourism Promotion**: Drive tourism development ✈️
                        • **City Vitality**: Inject youth energy into cities 🌟
                        
                        **Environmental Concepts**
                        • **Resource Sharing**: Reduce waste through sharing ♻️
                        • **Eco-friendly Stay**: Promote green travel concepts 🌱
                        • **Waste Sorting**: Foster environmental awareness 🗑️
                        • **Sustainable Development**: Support sustainable tourism 🌍
                        
                        **Educational Value**
                        • **Independence**: Develop independent living skills 💪
                        • **Communication**: Improve cross-cultural communication 🗣️
                        • **Adaptability**: Enhance environmental adaptation 🔄
                        • **Worldview**: Broaden horizons, form global perspective 🌐
                        
                        **Future Development**
                        • **Smart Upgrade**: Introduce more tech elements 🤖
                        • **Personalized Service**: Provide more customized services 🎯
                        • **Quality Improvement**: Enhance quality while maintaining price advantage ⭐
                        • **Cultural Depth**: Deeper cultural experience programs 📚
                        
                        🎊 **Hostel Meaning:** Not just accommodation, but a witness to youth and cradle of friendship!
                        """)
                        
                        ImagePlaceholder(title: "Hostel Cultural Experience")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Youth Hostel Guide")
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
    HostelArticleView()
} 