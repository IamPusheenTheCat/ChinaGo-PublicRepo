//
//  AirbnbArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct AirbnbArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.pink, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "house.lodge.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Homestay Booking")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 民宿基础：家的感觉
                        ArticleSection(title: "Homestay Experience: Live Like a Local", content: """
                        **Why Choose Homestay?**
                        Live like a local with homestays! More personal than hotels, better cultural immersion, cost-effective, and fully equipped - the best way to experience China in depth.
                        
                        **Homestay Advantages**
                        • **Home Feeling**: Cozy and homey atmosphere 🏠
                        • **Cost-Effective**: 30-50% cheaper than equivalent hotels 💰
                        • **Cultural Experience**: Experience local lifestyle 🌍
                        • **Full Amenities**: Kitchen, washing machine, and other facilities 🔧
                        
                        **Types of Homestays**
                        • **Entire House**: Independent apartments or villas, great privacy 🏘️
                        • **Private Room**: Shared common spaces with host 🚪
                        • **Traditional Houses**: Siheyuan, historic buildings 🏛️
                        • **Boutique Homestays**: Designer homes, themed stays 🎨
                        
                        **Suitable For**
                        • **Budget Travelers**: Perfect for students and backpackers 🎒
                        • **Long-term Stays**: Business or study stays over a week 📅
                        • **Family Trips**: Families traveling with children 👨‍👩‍👧‍👦
                        • **Culture Enthusiasts**: Those seeking deep cultural understanding 📚
                        
                        💡 **Selection Tip:** The experience is about the host - choose ones with good reviews and smooth communication!
                        """)
                        
                        ImagePlaceholder(title: "China Homestay Experience")
                        
                        // 预订平台：多元选择
                        ArticleSection(title: "Booking Platforms: Finding Your Perfect Stay", content: """
                        **International Platforms**
                        • **Airbnb**: World's largest homestay platform, highly international 🌍
                        • **Booking.com**: Not just hotels, many homestay options 🏨
                        • **Agoda**: Strong in Asia, rich in Chinese listings 🏢
                        • **Expedia**: American brand, well-integrated ✈️
                        
                        **Chinese Platforms**
                        • **Tujia**: China's largest homestay platform, most listings 🏠
                        • **Xiaozhu**: Popular among youth, strong design focus 🐷
                        • **Zhenguo**: ByteDance's platform, great user experience 📱
                        • **Muniao**: Wide coverage, affordable prices 🦆
                        
                        **Specialty Platforms**
                        • **Meituan**: Integrated with Meituan ecosystem, many deals 🛵
                        • **Ctrip**: Reliable traditional travel platform ✈️
                        • **Qunar**: Easy price comparison, diverse options 💰
                        • **Mafengwo**: Travel guides + homestay booking 📖
                        
                        **Direct Booking**
                        • **WeChat Groups**: Local host WeChat groups 💬
                        • **Friend Referrals**: Most reliable through friends 👥
                        • **On-site Booking**: Direct contact after arrival 🚶
                        • **Homestay Associations**: Local industry association recommendations 🏛️
                        
                        **Selection Strategy**
                        • **Read Reviews**: Focus on recent reviews and criticisms ⭐
                        • **Compare Prices**: Check multiple platforms, watch for hidden fees 💰
                        • **Check Location**: Transportation convenience and surroundings 🗺️
                        • **Contact Host**: Communicate in advance for details 📞
                        
                        🎯 **Platform Tip:** International platforms are language-friendly, local platforms offer better prices and more options!
                        """)
                        
                        ImagePlaceholder(title: "Homestay Booking Platforms")
                        
                        // 预订流程：详细指南
                        ArticleSection(title: "Booking Process: From Search to Check-in", content: """
                        **Search Filters**
                        • **Set Criteria**: Check-in dates, number of guests, price range 📅
                        • **Choose Area**: City center, near attractions, transport hubs 🗺️
                        • **Facility Filters**: WiFi, AC, kitchen, washing machine 🔧
                        • **Room Type**: Entire place, private room, shared room 🏠
                        
                        **Detailed Review**
                        • **Property Photos**: Check all photos carefully for reality 📸
                        • **Property Description**: Read details, note house rules 📝
                        • **Amenity List**: Confirm all needed facilities ✅
                        • **Surroundings**: Check map location and nearby facilities 📍
                        
                        **Review Analysis**
                        • **Overall Rating**: 4.5+ is relatively reliable ⭐
                        • **Review Count**: More reviews mean more reference 📊
                        • **Recent Reviews**: Focus on latest reviews 📅
                        • **Negative Reviews**: Understand potential issues ⚠️
                        
                        **Booking Confirmation**
                        • **Contact Host**: Ask specific questions, confirm availability 📞
                        • **Confirm Price**: Include cleaning fee, service fee 💰
                        • **Payment Method**: Choose secure payment options 💳
                        • **Get Confirmation**: Save booking confirmation info 📱
                        
                        **Check-in Preparation**
                        • **Plan Route**: Plan arrival route in advance 🚗
                        • **Key Collection**: Confirm key collection method and time 🔑
                        • **Contact Info**: Save host contact information 📞
                        • **Backup Plan**: Prepare alternative accommodation plan 🆘
                        
                        💪 **Success Secret:** Early communication, careful review, rational evaluation for worry-free booking!
                        """)
                        
                        ImagePlaceholder(title: "Homestay Booking Process")
                        
                        // 入住体验：宾至如归
                        ArticleSection(title: "Check-in Experience: Feel at Home", content: """
                        **Arrival & Check-in**
                        • **On-time Arrival**: Arrive as agreed, call ahead to confirm 📞
                        • **Find Location**: Use map navigation, note house number 🗺️
                        • **Get Keys**: Digital lock, key box, or meet host 🔑
                        • **Check Property**: Take photos of condition upon arrival 📸
                        
                        **Using Facilities**
                        • **WiFi Connection**: Get WiFi password, ensure connection 📶
                        • **Appliance Use**: Learn AC, water heater operation 🔌
                        • **Kitchen Use**: Cook if allowed 👨‍🍳
                        • **Laundry Service**: Use washing machine, note detergent location 👕
                        
                        **Host Interaction**
                        • **Polite Communication**: Stay friendly, respect property 🤝
                        • **Ask Advice**: Get local recommendations from host 💬
                        • **Follow Rules**: Strictly follow house rules 📋
                        • **Timely Feedback**: Communicate issues promptly 📱
                        
                        **Living Experience**
                        • **Buy Groceries**: Shop at nearby markets or supermarkets 🛒
                        • **Cook Meals**: Experience Chinese home-style living 🍳
                        • **Neighbor Relations**: Greet neighbors friendly 👋
                        • **Cultural Learning**: Observe local living habits 📚
                        
                        **Safety Notes**
                        • **Door Security**: Lock doors and windows when leaving 🔒
                        • **Valuables**: Safeguard personal belongings 💎
                        • **Emergency Contacts**: Save host and local emergency numbers 📞
                        • **Insurance Coverage**: Check if accommodation is insured 🛡️
                        
                        🏠 **Experience Spirit:** Treat the homestay as your temporary home, care for it and be courteous!
                        """)
                        
                        ImagePlaceholder(title: "Homestay Check-in Experience")
                        
                        // 外国人专用：文化适应
                        ArticleSection(title: "For Foreigners: Bridging Cultural Differences", content: """
                        **Language Communication**
                        • **Translation Tools**: Prepare translation apps for communication 📱
                        • **Basic Chinese**: Learn basic house-related vocabulary 🗣️
                        • **Body Language**: Use gestures and expressions to help communicate 👋
                        • **Picture Explanation**: Use pictures to show needs more clearly 📸
                        
                        **Cultural Understanding**
                        • **Living Habits**: Understand Chinese daily routines ⏰
                        • **Noise Control**: Keep quiet after 10 PM 🤫
                        • **Waste Sorting**: Learn basic waste classification ♻️
                        • **Conservation**: Save water and electricity, show consideration 💡
                        
                        **Document Requirements**
                        • **Passport Registration**: Need passport for check-in 📘
                        • **Visa Verification**: Ensure visa is valid ✅
                        • **Accommodation Registration**: Register at local police station 🏛️
                        • **Keep Records**: Keep all accommodation documentation 📄
                        
                        **Payment Methods**
                        • **Security Deposit**: Usually requires deposit payment 💰
                        • **Payment Options**: WeChat, Alipay, bank cards 💳
                        • **Invoice Needs**: Remember to ask for invoice for business stays 🧾
                        • **Refund Policy**: Understand cancellation and refund policies 📋
                        
                        **Emergency Situations**
                        • **Medical Emergency**: Remember 120 for ambulance 🚑
                        • **Police Help**: 110 for police, 119 for fire 📞
                        • **Embassy Contact**: Keep your embassy contact information 🏛️
                        • **Insurance Claims**: Understand travel insurance claim process 📋
                        
                        ⚠️ **Important Reminder:** Respect local culture, follow laws and regulations, safety first!
                        """)
                        
                        ImagePlaceholder(title: "Foreigner's Homestay Guide")
                        
                        // 特色民宿：文化体验
                        ArticleSection(title: "Special Homestays: Deep Cultural Experience", content: """
                        **Traditional Architecture**
                        • **Beijing Siheyuan**: Experience old Beijing hutong culture 🏛️
                        • **Jiangnan Watertown**: Suzhou, Hangzhou ancient town stays 🏘️
                        • **Yunnan Houses**: Dali, Lijiang characteristic buildings 🏔️
                        • **Hakka Tulou**: Fujian earth buildings, World Heritage sites 🏰
                        
                        **Modern Design**
                        • **Industrial Style**: Converted factories and warehouses 🏭
                        • **Nordic Minimalist**: Modern style popular with youth 🎨
                        • **Japanese Zen**: Meditation space, peaceful experience 🍃
                        • **Mediterranean**: Blue and white tones, romantic atmosphere 🌊
                        
                        **Natural Scenery**
                        • **Seaside Stays**: Qingdao, Sanya ocean views 🏖️
                        • **Mountain Retreats**: Huangshan, Zhangjiajie mountain views ⛰️
                        • **Rural Homestays**: Experience countryside life 🌾
                        • **Lakeside Houses**: West Lake, Erhai Lake views 🏞️
                        
                        **Themed Homestays**
                        • **Art Theme**: Artist studios, music houses 🎭
                        • **Food Theme**: Homestays with cooking lessons 👨‍🍳
                        • **Book Theme**: Cultural spaces full of books 📚
                        • **Sports Theme**: Outdoor enthusiasts' gathering spots 🏃
                        
                        **City Distribution**
                        • **Beijing**: Hutong siheyuan, rich historical culture 🏛️
                        • **Shanghai**: Shikumen lilong, Shanghai style culture 🏙️
                        • **Chengdu**: Sichuan culture, relaxed lifestyle 🐼
                        • **Xi'an**: Inside ancient city walls, ancient capital charm 🏰
                        
                        🌟 **Selection Tip:** Choose themes based on your travel purpose, make accommodation a highlight of your trip!
                        """)
                        
                        ImagePlaceholder(title: "Special Homestay Types")
                        
                        // 文化体验：深度感受
                        ArticleSection(title: "Cultural Experience: China's Stories in Homestays", content: """
                        **Lifestyle Experience**
                        • **Morning Market**: Go to morning markets with hosts 🌅
                        • **Home Cooking**: Learn to cook Chinese home dishes 👨‍🍳
                        • **Neighbor Relations**: Observe Chinese neighborhood interactions 👥
                        • **Daily Rhythm**: Experience Chinese daily life patterns ⏰
                        
                        **Cultural Exchange**
                        • **Language Practice**: Practice Chinese in daily conversations 🗣️
                        • **Custom Learning**: Learn local customs and habits 🎭
                        • **Festival Participation**: Join local festival activities 🎊
                        • **Story Sharing**: Listen to local stories from hosts 📚
                        
                        **Community Integration**
                        • **Square Dancing**: Join evening square dancing with locals 💃
                        • **Morning Tai Chi**: Practice Tai Chi in parks 🥋
                        • **Community Activities**: Participate in community events 👥
                        • **Volunteer Work**: Help neighbors when possible 🤝
                        
                        **Traditional Arts**
                        • **Calligraphy**: Learn Chinese traditional calligraphy 🖌️
                        • **Tea Culture**: Experience tea ceremonies 🍵
                        • **Handicrafts**: Learn paper-cutting, weaving ✂️
                        • **Music**: Try guzheng, erhu 🎵
                        
                        **Modern Life**
                        • **Mobile Payments**: Experience cashless living 📱
                        • **Online Shopping**: Convenient online shopping and delivery 📦
                        • **Sharing Economy**: Use shared bikes, cars 🚲
                        • **Live Streaming**: Understand Chinese internet culture 📺
                        
                        **Social Responsibility**
                        • **Elderly Care**: Participate in caring for elderly in the community 👴
                        • **Child Care**: Spend time with children and learn 👶
                        • **Environmental Awareness**: Participate in environmental protection activities 🌱
                        • **Cultural Preservation**: Support traditional culture preservation 🏛️
                        
                        🎊 **Deep Experience:** Homestays are more than just accommodation, they're a window into real Chinese culture!
                        """)
                        
                        ImagePlaceholder(title: "Homestay Cultural Experience")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Homestay Booking Guide")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Complete") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AirbnbArticleView()
} 