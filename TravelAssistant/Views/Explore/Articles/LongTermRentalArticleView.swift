//
//  LongTermRentalArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct LongTermRentalArticleView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部图片区域
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.gray, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 250)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "key.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                            Text("Complete Guide to Long-term Rentals")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 文章内容
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // 长租公寓基础：安家之选
                        ArticleSection(title: "Long-term Rentals: The Best Choice for Settling in China", content: """
                        **What are Long-term Rentals?**
                        Long-term rentals are modern rental accommodations designed for extended stays! Well-furnished, fully equipped, professionally serviced, especially suitable for foreigners working or studying in China.
                        
                        **Rental Advantages**
                        • **Move-in Ready**: Fully furnished with all appliances 🏠
                        • **Professional Service**: Property management, maintenance services 🔧
                        • **Prime Location**: Near business districts and subway lines 📍
                        • **Community Amenities**: Gym, lounge, laundry room, etc. 🏋️
                        
                        **Apartment Types**
                        • **Brand Apartments**: Ziroom, Danke, and other known brands 🏢
                        • **Serviced Apartments**: Hotel-style management, full service 🏨
                        • **Centralized Apartments**: Entire buildings dedicated to rentals 🏬
                        • **Distributed Apartments**: Units in regular residential buildings 🏘️
                        
                        **Suitable For**
                        • **Foreign Employees**: Foreigners working in China 💼
                        • **International Students**: Long-term students in China 🎓
                        • **Business Travelers**: Long-term business trips or projects ✈️
                        • **Digital Nomads**: Remote workers and freelancers 💻
                        
                        💡 **Selection Advice:** Long-term rentals are more hassle-free than traditional rentals, cheaper than hotels, best for extended stays!
                        """)
                        
                        ImagePlaceholder(title: "China Long-term Rentals")
                        
                        // 主要品牌：各有特色
                        ArticleSection(title: "Major Brands: Choose a Reliable Rental Platform", content: """
                        **Ziroom (Largest Brand)**
                        • **Most Properties**: Coverage in tier 1-2 cities, abundant choices 🏙️
                        • **Consistent Quality**: Standardized renovation, quality assurance ⭐
                        • **Complete Service**: APP management, easy maintenance requests 📱
                        • **Transparent Pricing**: No agency fees, clear pricing 💰
                        
                        **Danke Apartment**
                        • **Youth-Oriented**: Designed for young tenants 👥
                        • **Smart Management**: Smart locks, smart home features 🤖
                        • **Social Activities**: Regular tenant events 🎉
                        • **Installment Payment**: Supports rent installments 💳
                        
                        **Mofang Apartment**
                        • **High-End Positioning**: Higher quality, slightly more expensive 💎
                        • **Business Amenities**: Meeting rooms, business center 💼
                        • **International**: More foreign tenants, international atmosphere 🌍
                        • **Good Security**: Complete access control system 🔒
                        
                        **YOU+ International Youth Community**
                        • **Community Concept**: Emphasizes social and community culture 👥
                        • **Shared Spaces**: Shared kitchen, living room, gym 🏋️
                        • **Rich Activities**: Concerts, book clubs, gatherings 🎵
                        • **Young Professionals**: Mainly for young professionals 🎯
                        
                        **Other Brands**
                        • **QingKe Apartment**: Covers Shanghai and East China 🏢
                        • **Xiangyu**: Brand under I Love My Home 🏠
                        • **Port Apartment**: Vanke's long-term rental brand 🏗️
                        • **Guan Apartment**: Longfor Group's brand 🏛️
                        
                        🎯 **Brand Choice:** Ziroom has most options, Danke is youth-oriented, Mofang more upscale, YOU+ focuses on social!
                        """)
                        
                        ImagePlaceholder(title: "Long-term Rental Brands")
                        
                        // 租房流程：详细步骤
                        ArticleSection(title: "Rental Process: From Viewing to Moving In", content: """
                        **Preparation**
                        • **Define Needs**: Location, price, type, amenity requirements 📝
                        • **Budget Planning**: Rent + deposit + service fees total cost 💰
                        • **Document Prep**: Passport, visa, work certification 📘
                        • **Bank Account**: Chinese bank account for rent payment 💳
                        
                        **Finding Properties**
                        • **Official Apps**: Most authoritative through brand apps 📱
                        • **Online Viewing**: VR tours, video tours 📹
                        • **On-site Visits**: Schedule physical viewings 🏠
                        • **Comparison**: View several units, compare comprehensively 📊
                        
                        **Viewing Points**
                        • **Property Condition**: Check renovation, furniture, appliances 🔍
                        • **Light & Ventilation**: Orientation, floor level, window size ☀️
                        • **Surroundings**: Transportation, shopping, dining convenience 🗺️
                        • **Security**: Access control, surveillance, property management 🛡️
                        
                        **Contract Signing**
                        • **Careful Reading**: Contract terms, move-out policy 📋
                        • **Fee Confirmation**: Monthly rent, deposit, service fee details 💰
                        • **Move-in Date**: Confirm specific move-in date 📅
                        • **Contact Info**: Manager, customer service, maintenance numbers 📞
                        
                        **Move-in Process**
                        • **Payment**: First month rent + deposit + service fee 💳
                        • **Property Handover**: Check facilities, take photos 📸
                        • **Get Keys**: Password or physical keys 🔑
                        • **Registration**: Complete residence registration 📝
                        
                        💪 **Success Tips:** Plan ahead, inspect thoroughly, sign carefully, move in smoothly!
                        """)
                        
                        ImagePlaceholder(title: "Long-term Rental Process")
                        
                        // 外国人租房：特殊要求
                        ArticleSection(title: "Foreign Renters: Understanding Special Regulations", content: """
                        **Document Requirements**
                        • **Passport Original**: Valid passport and copies 📘
                        • **Visa Pages**: Valid visa and copies ✅
                        • **Work Permit**: Work visa requires work permit 💼
                        • **Student Proof**: Student visa needs admission letter 🎓
                        
                        **Residence Registration**
                        • **Police Registration**: Must register within 24 hours of move-in 🏛️
                        • **Registration Materials**: Passport, visa, rental contract 📋
                        • **Registration Process**: Landlord accompaniment or assistance 👥
                        • **Registration Receipt**: Keep residence registration receipt 📄
                        
                        **Bank Account Opening**
                        • **Salary Account**: For monthly rent payment 💳
                        • **Opening Requirements**: Passport, visa, work proof 📝
                        • **Bank Selection**: Big 4 or Merchants, Minsheng banks 🏦
                        • **Online Banking**: Convenient for rent payment 📱
                        
                        **Tax Issues**
                        • **Personal Income Tax**: Rent may involve personal tax 💰
                        • **Tax Registration**: High income needs tax registration 📊
                        • **Invoice Needs**: Company reimbursement needs rental invoice 🧾
                        • **Tax Consultation**: Complex cases consult tax advisors 👨‍💼
                        
                        **Language Communication**
                        • **Translation Tools**: Prepare translation apps for communication 📱
                        • **Chinese Learning**: Learn basic housing-related vocabulary 🗣️
                        • **English Service**: Choose apartments with English service 🌍
                        • **Friend Help**: Ask Chinese friends to assist viewing and signing 🤝
                        
                        ⚠️ **Important Reminder:** Follow legal regulations strictly, ensure legal residence!
                        """)
                        
                        ImagePlaceholder(title: "Foreign Renter Guide")
                        
                        // 生活配套：便利生活
                        ArticleSection(title: "Living Amenities: Enjoy Convenient Urban Life", content: """
                        **Basic Facilities**
                        • **Furniture & Appliances**: Bed, tables, chairs, fridge, washer, AC 🏠
                        • **Internet & TV**: Broadband WiFi, cable TV 📶
                        • **Kitchen Equipment**: Gas stove, microwave, utensils 👨‍🍳
                        • **Bathroom Facilities**: Water heater, toiletries 🚿
                        
                        **Property Services**
                        • **24-hour Front Desk**: Always available for resident issues 🕐
                        • **Cleaning Service**: Regular public area cleaning 🧹
                        • **Maintenance Service**: Quick repairs for appliances and facilities 🔧
                        • **Security**: Access control, surveillance, security patrols 🛡️
                        
                        **Community Amenities**
                        • **Gym**: Basic fitness equipment, free use 🏋️
                        • **Shared Spaces**: Lounge, reading area, work area 📚
                        • **Laundry Room**: Self-service washers and dryers 👕
                        • **Package Room**: Smart package delivery system 📦
                        
                        **Surrounding Amenities**
                        • **Transportation**: Walking distance to metro and bus stations 🚇
                        • **Shopping**: Supermarkets, convenience stores, malls 🛒
                        • **Dining**: Various restaurants, food delivery 🍜
                        • **Life Services**: Banks, hospitals, pharmacies 🏥
                        
                        **Value-Added Services**
                        • **Package Reception**: Front desk accepts deliveries 📮
                        • **Cleaning Service**: Paid deep cleaning for rooms 🧽
                        • **Moving Service**: Assistance with moving and room changes 🚚
                        • **Visa Service**: Help with visa extension 📘
                        
                        🌟 **Service Advantage:** One-stop life services make living a pleasure!
                        """)
                        
                        ImagePlaceholder(title: "Long-term Rental Living Amenities")
                        
                        // 费用构成：明明白白
                        ArticleSection(title: "Cost Structure: Every Payment Clear and Transparent", content: """
                        **Basic Costs**
                        • **Monthly Rent**: Basic room rent, paid monthly 💰
                        • **Deposit**: Usually 1-2 months rent as deposit 🔒
                        • **Service Fee**: Property management fee, paid monthly or quarterly 🏢
                        • **Utilities**: Charged by actual usage 💡
                        
                        **One-time Fees**
                        • **Agency Fee**: Some platforms charge service fee 💳
                        • **Cleaning Fee**: Deep cleaning fee at move-out 🧹
                        • **Key Fee**: Door card production fee 🔑
                        • **Internet Fee**: Internet installation or upgrade fee 📶
                        
                        **Optional Fees**
                        • **Cleaning Service**: Regular room cleaning 🧽
                        • **Laundry Service**: Clothes washing and drying 👕
                        • **Parking Fee**: Parking space rental fee 🚗
                        • **Pet Fee**: Extra fee for allowing pets 🐕
                        
                        **Cost Saving Tips**
                        • **Long-term Contract**: Sign longer lease for discounts 📅
                        • **Off-peak Move-in**: Avoid peak season, better prices 🌸
                        • **Group Rental**: Company group rentals get discounts 👥
                        • **Referral Rewards**: Get rewards for referring friends 🎁
                        
                        **Payment Methods**
                        • **Bank Transfer**: Most common payment method 🏦
                        • **Mobile Payment**: WeChat, Alipay 📱
                        • **Credit Card**: Some apartments accept credit cards 💳
                        • **Cash Payment**: Accepted in rare cases 💵
                        
                        💡 **Money-saving Advice:** Plan ahead, long-term contract, group discounts, save reasonably!
                        """)
                        
                        ImagePlaceholder(title: "Long-term Rental Costs")
                        
                        // 文化体验：都市生活
                        ArticleSection(title: "Cultural Experience: Experience Chinese Urban Life", content: """
                        **Modern Lifestyle**
                        • **Smart Living**: Experience smart locks, smart home features 🤖
                        • **Cashless Payment**: Experience mobile payment convenience 📱
                        • **Delivery Culture**: Various food delivery apps, stay-at-home service 🛵
                        • **Sharing Economy**: Shared bikes, shared cars 🚲
                        
                        **Social Culture**
                        • **Neighbor Relations**: Modern apartment neighbor interaction 👥
                        • **Community Activities**: Participate in apartment organized events 🎉
                        • **Online Social**: Make friends through online platforms 💬
                        • **Work Culture**: Understand Chinese work rhythm 💼
                        
                        **Consumer Culture**
                        • **Online Shopping**: Taobao, JD.com e-commerce shopping 📦
                        • **Consumption Habits**: Understand Chinese consumer preferences 🛒
                        • **Price Sensitivity**: Learn price comparison and finding deals 💰
                        • **Brand Awareness**: International vs local brands 🏷️
                        
                        **City Rhythm**
                        • **Fast-paced Life**: Experience big city life rhythm ⚡
                        • **Efficiency Focus**: Chinese pursuit of efficiency 📈
                        • **Time Concept**: Importance of punctuality ⏰
                        • **Competitive Environment**: Competition in work and life 🏆
                        
                        **Environmental Awareness**
                        • **Waste Sorting**: Learn waste classification knowledge ♻️
                        • **Energy Conservation**: Save water and electricity, eco-friendly travel 🌱
                        • **Green Living**: Choose eco-friendly products and services 🍃
                        • **Sustainable Development**: Support sustainable lifestyle 🌍
                        
                        **Future Trends**
                        • **Rent & Buy Balance**: Renting becomes mainstream living choice 🏠
                        • **Service Upgrade**: More personalized services 🎯
                        • **Tech Application**: AI, IoT and other new technologies 🤖
                        • **Internationalization**: More international community environment 🌐
                        
                        **Deep Experience:** Long-term rentals aren't just accommodation, they're a window to experience modern Chinese life!
                        """)
                        
                        ImagePlaceholder(title: "Long-term Rental Cultural Experience")
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Long-term Rental Guide")
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
    LongTermRentalArticleView()
} 