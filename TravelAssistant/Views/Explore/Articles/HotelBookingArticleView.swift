//
//  HotelBookingArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct HotelBookingArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "building.2.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Hotel Booking in China")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 平台选择：各有优势
                        ArticleSection(title: "Booking Platforms: Choose the Right One to Save Money and Hassle", content: """
                        **Why Book Online?**
                        Over 90% of hotels in China can be booked online! Transparent pricing, diverse options, instant confirmation, and 30-50% cheaper than walk-in rates.
                        
                        **Ctrip (Recommended First Choice)**
                        • **Most Comprehensive**: From 5-star hotels to budget chains, widest selection 🏨
                        • **Foreigner-Friendly**: English interface, international credit card payments 🌍
                        • **Service Guarantee**: 24-hour customer service for issue resolution 📞
                        • **Points System**: Earn points for stays, more value with frequent use 🎁
                        
                        **Fliggy (Alibaba Group)**
                        • **Alipay Integration**: First choice for Alipay users 💳
                        • **Credit Stay**: No deposit required for Sesame Credit above 650 🆔
                        • **Package Deals**: Often offers hotel + attraction ticket combos 🎯
                        • **Member Benefits**: Exclusive discounts for Taobao 88VIP 👑
                        
                        **Meituan Hotels (Best Value)**
                        • **Price Advantage**: Often cheapest for same-star hotels 💰
                        • **Local Services**: Integration with Meituan food delivery and rides 🍔
                        • **Authentic Reviews**: More objective user reviews ⭐
                        • **Last Minute**: Bigger discounts for same-day bookings ⏰
                        
                        **Booking.com (International Brand)**
                        • **Global Usage**: Usable worldwide, familiar interface 🌐
                        • **Free Cancellation**: Most rooms support free cancellation 🔄
                        • **Chinese Support**: Chinese customer service team available 💬
                        
                        💡 **Money-Saving Tip:** Check room types on Booking.com first, then compare prices on Chinese platforms!
                        """)
                        
                        ImagePlaceholder(title: "Hotel Booking Platform Comparison")
                        
                        // 外国人预订：特殊注意
                        ArticleSection(title: "Foreign Guests: Avoid These Pitfalls", content: """
                        **Document Requirements**
                        • **Passport Required**: Required by Chinese law, ID cards not accepted 📘
                        • **Visa Check**: Ensure visa is valid ✅
                        • **Real Name**: Booking name must match passport 👤
                        • **Travel Companions**: Valid ID required for all guests 👥
                        
                        **Booking Considerations**
                        • **English Name**: Use passport name for booking 🔤
                        • **Phone Number**: Provide Chinese phone number for hotel contact 📱
                        • **Arrival Time**: Clearly state expected arrival time 🕐
                        • **Special Requests**: Non-smoking, high floor, quiet room, etc. 📝
                        
                        **Payment Methods**
                        • **Online Payment**: Most platforms accept international credit cards 💳
                        • **Pay at Hotel**: Some hotels accept on-site payment 🏨
                        • **Deposit Policy**: Usually required, refunded at checkout 💰
                        • **Currency Exchange**: Major currencies accepted in big city hotels 💵
                        
                        **Cancellation Policy**
                        • **Free Cancellation**: Note the deadline for free cancellation 🕐
                        • **Fee Rules**: Understand cancellation fee percentages 💸
                        • **Non-Refundable**: Special rates usually non-refundable 🚫
                        • **Change Policy**: Whether free date changes are allowed 📅
                        
                        ⚠️ **Important Note:** Some hotels in remote areas don't accept foreign guests - confirm before booking!
                        """)
                        
                        ImagePlaceholder(title: "Foreign Guest Booking Guidelines")
                        
                        // 酒店类型：找到最适合的
                        ArticleSection(title: "Hotel Types: Different Options for Different Needs", content: """
                        **International 5-Star Hotels**
                        • **Major Brands**: Marriott, Hilton, Shangri-La, InterContinental 🌟
                        • **Price Range**: 500-2000 RMB/night 💰
                        • **Service Standard**: English service, international breakfast, gym & pool 🏊
                        • **Suitable For**: Business travel, vacation, high service requirements 💼
                        
                        **High-End Chinese Hotels**
                        • **Major Brands**: Atour, Ji, Orange Hotels 🏨
                        • **Price Range**: 200-500 RMB/night 💵
                        • **Special Features**: Strong design sense, high-tech amenities 📱
                        • **Suitable For**: Young business travelers, medium quality requirements 🎯
                        
                        **Budget Chain Hotels**
                        • **Major Brands**: Home Inn, Hanting, 7 Days, Jin Jiang 🏪
                        • **Price Range**: 100-250 RMB/night 💸
                        • **Basic Services**: Clean, safe, convenient location, standardized ✅
                        • **Suitable For**: Limited budget, basic accommodation needs 💰
                        
                        **Boutique Guesthouses**
                        • **Platforms**: Airbnb, Xiaozhu, Tujia 🏠
                        • **Price Range**: 80-400 RMB/night 🏡
                        • **Unique Experience**: Local culture, homey atmosphere, personalization 🌸
                        • **Suitable For**: Cultural experience, long stays, group travel 👥
                        
                        **Youth Hostels**
                        • **Major Brands**: YHA, Backpacker Hostels 🎒
                        • **Price Range**: 30-100 RMB/night 💰
                        • **Social Aspect**: Meet friends, cultural exchange 👫
                        • **Suitable For**: Students, backpackers, social needs 🎓
                        
                        🎯 **Selection Tip:** Choose international brands for business, unique ones for tourism, chain hotels for economy!
                        """)
                        
                        ImagePlaceholder(title: "China Hotel Type Selection")
                        
                        // 入住体验：文化差异
                        ArticleSection(title: "Stay Experience: Understanding Chinese Hotel Culture", content: """
                        **Check-in Process**
                        • **Check-in Time**: Usually after 15:00, check-out before 12:00 🕐
                        • **ID Registration**: Passport registration is legally required 📘
                        • **Deposit Payment**: Cash or credit card pre-authorization 💳
                        • **Room Key**: Usually magnetic cards, keep away from magnets 🗝️
                        
                        **Room Facilities**
                        • **Slippers**: Chinese hotels usually provide disposable slippers 👡
                        • **Water Kettle**: In-room electric kettle for boiling water ♨️
                        • **Tea Set**: Usually includes tea bags, experience Chinese tea culture 🍵
                        • **Power Adapters**: International hotels often have universal sockets 🔌
                        
                        **Service Features**
                        • **Breakfast**: Mainly Chinese breakfast with congee, baozi, pickles 🥟
                        • **Room Service**: Food delivery available but may take time 🍜
                        • **Laundry Service**: Available at most hotels but expensive 👔
                        • **Taxi Service**: Front desk can help call taxis 🚖
                        
                        **Etiquette**
                        • **Tipping Culture**: Not common in China, service fees included in room rate 💰
                        • **Quiet Hours**: Keep quiet after 22:00, respect other guests 🤫
                        • **Conservation**: Green stay encouraged, reuse towels 🌱
                        • **Checkout Check**: Take personal items, check room facilities 🔍
                        
                        💖 **Cultural Experience:** Try the Chinese tea in your room, experience the "tea friendship" cultural tradition!
                        """)
                        
                        ImagePlaceholder(title: "Chinese Hotel Stay Culture")
                        
                        // 城市住宿：区域选择
                        ArticleSection(title: "Best Locations: City Area Guide", content: """
                        **Beijing Accommodation Guide**
                        • **Wangfujing/Dongdan**: Convenient for shopping, direct subway to Forbidden City 🏛️
                        • **Sanlitun**: High international standard, bar street nightlife 🍻
                        • **Zhongguancun**: Tech park area, good value accommodation 💻
                        • **Airport Area**: Convenient for transfers but far from city center ✈️
                        
                        **Shanghai Accommodation Guide**
                        • **Bund/Nanjing Road**: Bustling commercial area but expensive 🌆
                        • **Lujiazui**: Financial center, highly modern 🏢
                        • **Xintiandi**: International atmosphere, many restaurants and bars 🍷
                        • **Hongqiao**: Transport hub, convenient for airport and high-speed rail 🚄
                        
                        **Guangzhou Accommodation Guide**
                        • **Tianhe District**: Many shopping centers, convenient transportation 🛍️
                        • **Pearl River New Town**: CBD area, concentration of high-end hotels 🏙️
                        • **Yuexiu District**: Old town area, rich cultural heritage 🏮
                        • **Baiyun Airport Area**: First choice for transit stays ✈️
                        
                        **Shenzhen Accommodation Guide**
                        • **Luohu**: Traditional business district, convenient for Hong Kong border crossing 🚇
                        • **Futian**: Financial center, most subway lines 🏦
                        • **Nanshan**: Tech park area, young people's gathering place 💻
                        • **Bao'an Airport**: Many international flights 🌍
                        
                        **General Selection Principles**
                        • **Subway Lines**: Prioritize locations with direct subway to attractions 🚇
                        • **Commercial Areas**: Convenient for dining and shopping, higher safety 🛒
                        • **Avoid Industrial Areas**: Poor environment, inconvenient transportation 🏭
                        
                        🎯 **Selection Secret:** Use map apps to check subway routes to main attractions, choose locations with fewest transfers!
                        """)
                        
                        ImagePlaceholder(title: "Major Chinese Cities Accommodation Areas")
                        
                        // 预订技巧：省钱有道
                        ArticleSection(title: "Booking Tips: Smart Strategies to Save Money", content: """
                        **Best Booking Times**
                        • **Advance Booking**: Best prices 7-14 days ahead 📅
                        • **Off-Peak Travel**: Avoid holidays and exhibition periods 📈
                        • **Weekday Stays**: Sunday-Thursday 30% cheaper than weekends 📊
                        • **Last Minute**: Same-day bookings sometimes have surprise prices ⏰
                        
                        **Price Comparison Strategy**
                        • **Multi-Platform Compare**: Check Ctrip, Meituan, Fliggy 💻
                        • **Member Prices**: Register for exclusive member discounts 👑
                        • **Package Deals**: Hotel+attraction or hotel+flight more economical 🎫
                        • **Extended Stay**: Discounts for 3+ night stays 🏨
                        
                        **Hidden Discount Discovery**
                        • **New User Offers**: First-order discounts on each platform 🎁
                        • **Credit Card Offers**: Bank credit cards often have hotel deals 💳
                        • **Corporate Rates**: Large company employees may have corporate rates 💼
                        • **Student Discounts**: Some hotels offer special student rates 🎓
                        
                        **Upgrade Tips**
                        • **Member Upgrade**: Hotel members often get free upgrades ⬆️
                        • **Honeymoon Upgrade**: Inform hotel if it's your honeymoon 💕
                        • **Birthday Upgrade**: Birthday stays may get surprises 🎂
                        • **Polite Communication**: Friendly attitude more likely to get better rooms 😊
                        
                        **Cancellation Policy Usage**
                        • **Price Protection**: Can request refund if price drops after booking 💰
                        • **Free Cancellation**: Use free cancellation policy to secure rooms 🔒
                        • **Flexible Changes**: Choose changeable rates if plans might change 🔄
                        
                        💡 **Ultimate Tip:** Follow hotel official WeChat accounts, member days and birthday months often have exclusive offers!
                        """)
                        
                        ImagePlaceholder(title: "Hotel Booking Money-Saving Tips")
                        
                        // 问题处理：有备无患
                        ArticleSection(title: "Problem Handling: Stay Calm in Any Situation", content: """
                        **Booking Issues**
                        • **Overbooking**: Request same-level room arrangement if no room available 🏨
                        • **Room Mismatch**: Request room change if actual room differs from booking 🔄
                        • **Price Disputes**: Keep booking screenshots as evidence 📸
                        • **Cancellation Issues**: Contact booking platform customer service 📞
                        
                        **During Stay Issues**
                        • **Facility Problems**: Contact front desk for maintenance 🔧
                        • **Noise Disturbance**: Request change to quiet floor 🤫
                        • **Cleanliness Issues**: Request re-cleaning or room change 🧹
                        • **Service Attitude**: Stay calm, escalate to management if necessary 😤
                        
                        **Safety Related**
                        • **Valuables**: Use room safe or front desk storage 💎
                        • **Unknown Visitors**: Don't open door to strangers 🚪
                        • **Emergency**: Remember front desk number and emergency exits 🚨
                        • **Personal Information**: Don't lose room card and passport together 📘
                        
                        **Checkout Issues**
                        • **Deposit Refund**: Ensure refund after confirming no extra charges 💳
                        • **Left Items**: Carefully check personal belongings before checkout 🎒
                        • **Invoice Needs**: Remember to request formal invoice for business travel 📄
                        • **Late Checkout**: Can apply for late checkout service if needed 🕐
                        
                        **Complaint Channels**
                        • **Direct Hotel**: First try resolving with hotel manager 🏨
                        • **Platform Complaint**: Apply for compensation through booking platform 📱
                        • **Official Complaint**: 12301 National Tourism Service Hotline 📞
                        • **Online Review**: Provide objective review to help other guests ⭐
                        
                        💪 **Handling Principles:** Stay calm, keep evidence, make reasonable requests, seek official help when necessary!
                        """)
                        
                        ImagePlaceholder(title: "Hotel Problem Handling Guide")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Hotel Booking Guide")
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
    HotelBookingArticleView()
} 