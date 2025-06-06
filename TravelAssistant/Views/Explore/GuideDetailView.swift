//
//  GuideDetailView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct GuideDetailView: View {
    let category: GuideCategory
    @State private var selectedItem: GuideItem?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 头部介绍
                    GuideHeaderView(category: category)
                    
                    // 详细内容
                    ForEach(category.items) { item in
                        GuideItemDetailView(item: item)
                            .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Completed") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct GuideHeaderView: View {
    let category: GuideCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: category.icon)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(category.title)
                        .font(.title)
                        .bold()
                    Text(category.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}

struct GuideItemDetailView: View {
    let item: GuideItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // 标题
            HStack {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(item.color)
                    .cornerRadius(10)
                
                Text(item.title)
                    .font(.title2)
                    .bold()
                
                Spacer()
            }
            
            // 图片占位符
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("Placeholder")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                )
            
            // 详细内容
            VStack(alignment: .leading, spacing: 10) {
                Text(getDetailedContent(for: item))
                    .font(.body)
                    .lineSpacing(2)
                
                if !getStepByStepGuide(for: item).isEmpty {
                    Text("Steps to Use:")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(Array(getStepByStepGuide(for: item).enumerated()), id: \.offset) { index, step in
                        HStack(alignment: .top) {
                            Text("\(index + 1).")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                            Text(step)
                                .font(.body)
                                .lineSpacing(2)
                        }
                        .padding(.leading, 5)
                    }
                }
                
                if !getTips(for: item).isEmpty {
                    Text("Useful Tips:")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    ForEach(getTips(for: item), id: \.self) { tip in
                        HStack(alignment: .top) {
                            Text("💡")
                                .font(.body)
                            Text(tip)
                                .font(.body)
                                .lineSpacing(2)
                        }
                        .padding(.leading, 5)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
    
    private func getDetailedContent(for item: GuideItem) -> String {
        switch item.category {
        case .transportation:
            switch item.title {
            case "Subway/High-speed Rail":
                return """
                China has the world's most advanced high-speed rail network and subway systems. High-speed trains connect major cities at speeds up to 350km/h, making them the preferred choice for long-distance travel. Subway systems cover major urban areas and are the most convenient way to travel within cities.

                Multiple ticket purchasing options: Available through the 12306 official website, mobile app, station self-service machines, or ticket windows. Supports ID cards, passports, and other valid identification documents.

                Stations typically have bilingual signage in Chinese and English, with major stations offering multilingual announcements.
                """
            case "Bus":
                return """
                Buses are the most economical mode of transportation in Chinese cities. Most city bus fares range from 1-3 RMB, accepting bus cards, mobile payments, or cash.

                Modern buses are usually equipped with air conditioning and voice announcements, with some routes offering English announcements. Bus stops have clear signage showing route maps and arrival times.

                Note: In China, passengers typically board through the front door and exit through the rear door. Buses can be crowded during peak hours.
                """
            case "Taxi/Ride-hailing":
                return """
                China has highly developed taxi and ride-hailing services. Major ride-hailing platforms include DiDi and AutoNavi.

                Advantages of ride-hailing: Advance booking available, transparent pricing, online payment support, trip records. Some platforms offer foreign language services.

                Taxis charge by distance, with base fares varying by city. Ride-hailing is recommended for convenience and safety.
                """
            case "Shared Bikes":
                return """
                Shared bikes are a popular choice for short trips in Chinese cities. Major brands include Meituan Bike, Hello Bike, and Qingju Bike.

                Easy to use: Scan QR code to unlock, pay by time (usually 1.5-2 yuan per half hour). Bikes are widely available and can be parked anywhere permitted.

                Best for: Short trips of 1-5 kilometers, environmentally friendly and great for experiencing city life. Some cities also offer electric-assist bikes.
                """
            default:
                return "Detailed information coming soon..."
            }
            
        case .payment:
            switch item.title {
            case "WeChat Pay":
                return """
                WeChat Pay is one of China's most widespread mobile payment methods, accepted by almost all merchants. From street vendors to large shopping malls, from online shopping to offline consumption, WeChat Pay is ubiquitous.

                Payment methods: QR code scanning, payment code display, transfers, red packets, etc. Can be linked to bank cards and credit cards for recharge.

                Note: Foreign tourists need to bind international credit cards like Visa or Mastercard to use it. Some features require real-name verification.
                """
            case "Alipay":
                return """
                Alipay is Alibaba's mobile payment platform with over 1 billion users in China. Besides payment functions, it integrates lifestyle services, financial management, and travel features.

                Special features: Ant Forest, Zhima Credit, Huabei installment, Yu'ebao investment, etc.

                Foreign tourist friendly: Supports multiple foreign currency credit cards, has English interface, and multilingual customer service.
                """
            case "Bank Cards":
                return """
                Chinese bank cards are mainly divided into debit cards and credit cards. Major banks include ICBC, Construction Bank, Agricultural Bank, Bank of China, etc.

                Foreign tourists can open accounts at banks by providing passport, visa, and other documentation. Some banks have special service counters for foreign customers.

                UnionPay cards are most widely used in China, while Visa and Mastercard are accepted in shopping malls and hotels in major cities.
                """
            case "QR Code Payment":
                return """
                QR code payment is a unique payment culture in China, completing transactions by scanning QR codes with mobile phones. There are two methods: customers scanning merchant codes or merchants scanning customer codes.

                Security: Uses dynamic QR code technology, generating new codes for each payment, ensuring high security.

                Convenience: No need for cash change, payment records are automatically saved, convenient for reconciliation and refunds.
                """
            default:
                return "Detailed information coming soon..."
            }
            
        case .food:
            switch item.title {
            case "Food Delivery":
                return """
                China's food delivery industry is highly developed, with major platforms including Meituan Waimai and Ele.me. They cover food, groceries, medicine, daily necessities, and more.

                Service features: Fast delivery (usually 30-60 minutes), wide selection, affordable prices. Supports scheduled delivery and contactless delivery options.

                For foreign tourists: Apps usually have English interfaces, can recommend nearby restaurants based on location, and support multiple payment methods.
                """
            case "Restaurant Booking":
                return """
                Restaurant reservations in China can be made through various channels: Dianping, Meituan, or direct phone calls. It's recommended to book popular restaurants in advance, especially for weekends and holidays.

                Booking tips: Check user reviews, dish recommendations, and price ranges. Some high-end restaurants require reservations several days in advance.

                Dining culture: Chinese restaurants typically use round tables for sharing, while Western restaurants often serve individual portions. Tipping is not mandatory but appreciated for excellent service.
                """
            case "Bubble Tea Culture":
                return """
                Bubble tea is a beloved beverage among young people in China, with numerous brands like HeyTea, Nayuki, Yi Dian Dian, and MixueIcecream.

                Customization options: Choose sweetness level (no sugar, less sugar, normal sugar), ice level (no ice, less ice, normal ice), and add toppings like pearls, coconut jelly, or pudding.

                Price range: From a few yuan to dozens of yuan, chain brands usually offer standardized taste and service. Many bubble tea shops support mobile ordering and delivery.
                """
            case "Grocery Shopping":
                return """
                China offers diverse grocery shopping channels: traditional markets, supermarkets, and fresh food e-commerce platforms (Hema Fresh, Dingdong, Miss Fresh).

                E-commerce advantages: Quality assurance, home delivery, transparent pricing, traceable origins. Usually same-day delivery, some platforms deliver within 30 minutes.

                Traditional market experience: More affordable prices, rich variety, opportunity to bargain, experience local food culture.
                """
            default:
                return "Detailed information coming soon..."
            }
            
        case .accommodation:
            switch item.title {
            case "Hotel Booking":
                return """
                China's hotel industry is well-developed, offering everything from budget hotels to luxury accommodations. Major booking platforms include Ctrip, Qunar, Fliggy, and Booking.com.

                Hotel types: Star-rated hotels, business hotels, boutique hotels, and budget chain hotels. Prices range from tens to thousands of yuan.

                Booking tips: Book in advance for better rates, check real guest reviews, note cancellation policies, and confirm if breakfast is included.
                """
            case "Homestay/Airbnb":
                return """
                Homestays offer tourists a more localized accommodation experience. Major platforms include Airbnb, Tujia, and Muniao Short-term Rental.

                Accommodation types: Entire apartments, private rooms, traditional courtyards, unique residences. Usually equipped with kitchens, suitable for long-term stays.

                Selection criteria: Location convenience, host ratings, facility completeness, neighborhood safety. Translation apps can help with host communication.
                """
            case "Youth Hostel":
                return """
                Youth hostels are economical accommodation options, ideal for young backpackers and short-term travelers. They typically offer dormitory beds and common areas.

                Facilities: Shared kitchen, laundry room, lounge area, luggage storage. Opportunities to meet travelers from around the world.

                Price range: Dorm beds usually 30-80 yuan/night, private rooms 80-200 yuan/night. Locations are typically near city centers or transportation hubs.
                """
            case "Long-term Rentals":
                return """
                Long-term apartments are suitable for foreigners working or studying in China. Offering flexible rental terms from monthly to yearly.

                Services include: Ready-to-move-in, cleaning service, maintenance service, community activities. Usually fully furnished with appliances, saving the hassle of buying.

                Rental platforms: Ziroom, Danke Apartment, QK365. Contract signing requires ID proof, income proof, and other documents.
                """
            default:
                return "Detailed information coming soon..."
            }
            
        case .services:
            switch item.title {
            case "Banking Services":
                return """
                Major Chinese banks: ICBC, Construction Bank, Agricultural Bank, Bank of China, China Merchants Bank, etc. Most banks offer specialized services for foreign customers.

                Account opening requirements: Passport, visa, proof of residence, phone number. Some banks require minimum deposits.

                Banking services: Deposits and withdrawals, transfers, credit card applications, investment products, foreign exchange. Mobile banking apps are powerful and support multiple languages.
                """
            case "Mobile Services":
                return """
                China's three major carriers: China Mobile, China Unicom, China Telecom. 4G/5G networks have extensive coverage, fast speeds, and reasonable rates.

                Plan options: Monthly plans, data packages, international roaming. Foreign tourists can purchase temporary SIM cards or activate international roaming.

                Purchase methods: Service centers, authorized stores, online service centers. Real-name verification required, foreigners need to provide passport or other ID.
                """
            case "Shopping Guide":
                return """
                China offers diverse shopping venues: Shopping malls, department stores, commercial streets, wholesale markets, e-commerce platforms.

                Popular shopping areas: Beijing's Wangfujing, Shanghai's Nanjing Road, Guangzhou's Tianhe City, Shenzhen's Huaqiangbei.

                E-commerce platforms: Taobao, Tmall, JD.com, Pinduoduo. Support multiple languages, hotel delivery, and returns/exchanges.
                """
            case "Medical Services":
                return """
                China's medical system includes public and private hospitals. Major city tertiary hospitals are advanced, with some having international departments or VIP sections.

                Medical process: Registration → waiting → doctor consultation → payment → medication. Recommended to understand medical insurance policies and international health insurance.

                Emergencies: Call 120 for ambulance. Some hospitals have 24-hour emergency departments, essential medicines available at pharmacies.
                """
            default:
                return "Detailed information coming soon..."
            }
            
        case .entertainment:
            switch item.title {
            case "Cultural Sites":
                return """
                China has rich historical and cultural sites: The Forbidden City, Great Wall, Terracotta Warriors, Temple of Heaven, and other World Heritage sites.

                Ticket purchase: Official websites, tourism apps, on-site ticketing. Recommended to book popular attractions online in advance for better rates.

                Visiting tips: Learn about historical background, hire guides or use audio guides, follow photography rules, protect cultural relics.
                """
            case "Entertainment Venues":
                return """
                China offers diverse entertainment venues: KTV, cinemas, arcades, board game cafes, escape rooms, murder mystery games, etc.

                KTV culture: A unique Chinese entertainment style, charged by hour, includes drinks and snacks. Many KTVs have English song libraries.

                Cinemas: Latest movies released simultaneously, some films have English subtitles or original language versions. Seats can be booked through apps.
                """
            case "Event Tickets":
                return """
                China's event market is active: Concerts, plays, musicals, traditional opera, sports events.

                Ticket platforms: Damai, Maoyan, YongLe. Support online seat selection, e-tickets, courier delivery.

                Event types: Pop concerts, classical music, traditional opera (Peking Opera, Kunqu Opera), modern theater. Recommended to check event content and language beforehand.
                """
            case "Travel Photography":
                return """
                Social media is popular in China, and photo sharing is an important part of travel experience. Popular photo spots usually have dedicated photo areas and props.

                Photo hotspots: Instagram-worthy locations, historic buildings, natural scenery, food, traditional costume experiences.

                Important notes: Respect local culture, follow photography rules, protect personal privacy, don't photograph in restricted areas.
                """
            default:
                return "Detailed information coming soon..."
            }
        }
    }
    
    private func getStepByStepGuide(for item: GuideItem) -> [String] {
        switch item.category {
        case .transportation:
            switch item.title {
            case "Subway/High-speed Rail":
                return [
                    "Download the 12306 app or go to the station",
                    "Choose the departure and destination",
                    "Choose the train and seat type",
                    "Fill in passenger information (name, ID number)",
                    "Choose payment method to complete ticket purchase",
                    "Enter the station with ID card or ticket code"
                ]
            case "Bus":
                return [
                    "Find the bus stop and route information",
                    "Prepare change or download the bus app",
                    "Board through the front door and exit through the rear door",
                    "Find a seat or hold on",
                    "Pay attention to the station name announcement",
                    "Press the bell before getting off the bus"
                ]
            case "Taxi/Ride-hailing":
                return [
                    "Download the DiDi or AutoNavi app",
                    "Register an account and bind the payment method",
                    "Enter the starting point and destination address",
                    "Choose the vehicle type and service type",
                    "Wait for the driver to pick you up and go to the pickup point"
                ]
            case "Shared Bikes":
                return [
                    "Download the corresponding shared bike app",
                    "Register an account and complete real-name authentication",
                    "Recharge deposit and balance",
                    "Find nearby available bikes",
                    "Scan the QR code on the bike to unlock",
                    "Lock the bike and settle the fee after riding"
                ]
            default:
                return []
            }
            
        case .payment:
            switch item.title {
            case "WeChat Pay":
                return [
                    "Download and register the WeChat app",
                    "Enter the \"Me\"-\"Payment\" page",
                    "Choose \"Add Bank Card\"",
                    "Enter bank card information and verify",
                    "Set payment password",
                    "Scan or display payment code to complete payment"
                ]
            case "Alipay":
                return [
                    "Download and register Alipay",
                    "Complete real-name authentication",
                    "Bind bank card or credit card",
                    "Set payment password and fingerprint/face recognition",
                    "Use scan or payment code to pay",
                    "Check transaction records and balance"
                ]
            default:
                return []
            }
            
        case .food:
            switch item.title {
            case "Food Delivery":
                return [
                    "Download the Meituan or Eleme app",
                    "Set delivery address",
                    "Browse nearby merchants and dishes",
                    "Choose goods and add to shopping cart",
                    "Choose delivery time and payment method",
                    "Place an order and wait for the delivery person to deliver"
                ]
            default:
                return []
            }
            
        default:
            return []
        }
    }
    
    private func getTips(for item: GuideItem) -> [String] {
        switch item.category {
        case .transportation:
            switch item.title {
            case "Subway/High-speed Rail":
                return [
                    "Avoid traveling during peak hours, tickets are tight",
                    "Arrive at the station 30 minutes early to reserve ticket time",
                    "Bring ID card or passport, it's a required document",
                    "High-speed trains are prohibited from smoking, offenders will be fined and blacklisted"
                ]
            case "Bus":
                return [
                    "Download the real-time bus app to check the arrival time",
                    "Prepare change, many drivers don't give change",
                    "Buses are very crowded during peak hours, pay attention to property safety",
                    "Giving seats to the elderly, pregnant women, and disabled people is a basic courtesy"
                ]
            case "Taxi/Ride-hailing":
                return [
                    "Check the license plate number and driver photo before getting on",
                    "You can use translation APP to communicate with the driver",
                    "Save trip screenshot for emergencies",
                    "It's recommended to share trip information with friends at night"
                ]
            case "Shared Bikes":
                return [
                    "Check vehicle condition to ensure brake and bell normal",
                    "Follow traffic rules and ride in bicycle lane",
                    "Park in designated area, avoid parking disorderly",
                    "Do not use shared bikes in rainy or snowy weather"
                ]
            default:
                return []
            }
            
        case .payment:
            switch item.title {
            case "WeChat Pay":
                return [
                    "Foreign credit cards may have usage restrictions, it's recommended to test in advance",
                    "Set complex payment password to protect account security",
                    "Small amount payment can open free payment, large amount recommended verification",
                    "Regularly check transaction records, contact customer service in case of abnormal"
                ]
            case "Alipay":
                return [
                    "Open security insurance, account theft can be compensated",
                    "Do not perform payment operations on public WiFi",
                    "Alipay points can be exchanged for various coupon",
                    "High芝麻 credit score can enjoy free deposit service"
                ]
            default:
                return []
            }
            
        case .food:
            switch item.title {
            case "Food Delivery":
                return [
                    "First use usually has new user coupon",
                    "Rainy delivery time may be extended, please be patient",
                    "Be polite to delivery personnel, they work very hard",
                    "If allergic to food, please specify in the order notes"
                ]
            case "Bubble Tea Culture":
                return [
                    "First drink is recommended to choose less sugar, Chinese milk tea is usually very sweet",
                    "Chew the pearls of pearl milk tea before swallowing",
                    "Many milk tea shops have member cards, frequent consumption can enjoy discount",
                    "Some milk tea contains caffeine, avoid drinking at night"
                ]
            default:
                return []
            }
            
        default:
            return []
        }
    }
}

struct GuideDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GuideDetailView(category: GuideCategory.allCategories[0])
    }
} 