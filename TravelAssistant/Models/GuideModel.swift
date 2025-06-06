//
//  GuideModel.swift
//  TravelAssistant
//
//  Created by Assistant on 6/5/25.
//

import SwiftUI

// MARK: - Guide Category Types
enum GuideCategoryType: String, CaseIterable {
    case transportation = "transportation"
    case payment = "payment"
    case food = "food"
    case accommodation = "accommodation"
    case services = "services"
    case entertainment = "entertainment"
}

// MARK: - Guide Item Model
struct GuideItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let title: String
    let color: Color
    let category: GuideCategoryType
}

// MARK: - Guide Category Model
struct GuideCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let items: [GuideItem]
    let description: String
    
    init(title: String, icon: String, items: [GuideItem], description: String) {
        self.title = title
        self.icon = icon
        self.items = items
        self.description = description
    }
}

// MARK: - Static Data
extension GuideCategory {
    static let allCategories: [GuideCategory] = [
        // Transportation
        GuideCategory(
            title: "Transportation",
            icon: "car.fill",
            items: [
                GuideItem(icon: "tram.fill", title: "High-speed Rail", color: .blue, category: .transportation),
                GuideItem(icon: "train.side.front.car", title: "Subway", color: .green, category: .transportation),
                GuideItem(icon: "bus.fill", title: "Bus Transport", color: .orange, category: .transportation),
                GuideItem(icon: "car.fill", title: "Taxi", color: .purple, category: .transportation),
                GuideItem(icon: "bicycle", title: "Shared Bikes", color: .yellow, category: .transportation),
                GuideItem(icon: "parkingsign", title: "Parking Guide", color: .gray, category: .transportation)
            ],
            description: "Complete guide to China's transportation system"
        ),
        
        // Payment
        GuideCategory(
            title: "Payment",
            icon: "creditcard.fill",
            items: [
                GuideItem(icon: "message.fill", title: "WeChat Pay", color: .green, category: .payment),
                GuideItem(icon: "qrcode.viewfinder", title: "Alipay", color: .blue, category: .payment),
                GuideItem(icon: "creditcard.fill", title: "Bank Cards", color: .red, category: .payment),
                GuideItem(icon: "qrcode", title: "QR Code Payment", color: .indigo, category: .payment)
            ],
            description: "Master China's digital payment methods"
        ),
        
        // Food
        GuideCategory(
            title: "Food & Dining",
            icon: "fork.knife",
            items: [
                GuideItem(icon: "takeoutbag.and.cup.and.straw.fill", title: "Food Delivery", color: .orange, category: .food),
                GuideItem(icon: "fork.knife.circle.fill", title: "Restaurant Booking", color: .red, category: .food),
                GuideItem(icon: "cup.and.saucer.fill", title: "Bubble Tea Culture", color: .brown, category: .food),
                GuideItem(icon: "cart.fill", title: "Grocery Shopping", color: .green, category: .food)
            ],
            description: "Explore China's food culture and dining options"
        ),
        
        // Accommodation
        GuideCategory(
            title: "Accommodation",
            icon: "house.fill",
            items: [
                GuideItem(icon: "building.2.fill", title: "Hotel Booking", color: .blue, category: .accommodation),
                GuideItem(icon: "house.fill", title: "Homestay/Airbnb", color: .pink, category: .accommodation),
                GuideItem(icon: "bed.double.fill", title: "Youth Hostel", color: .cyan, category: .accommodation),
                GuideItem(icon: "key.fill", title: "Long-term Rental", color: .purple, category: .accommodation)
            ],
            description: "Find the perfect place to stay in China"
        ),
        
        // Services
        GuideCategory(
            title: "Essential Services",
            icon: "gear.badge.questionmark",
            items: [
                GuideItem(icon: "building.columns.fill", title: "Banking Services", color: .blue, category: .services),
                GuideItem(icon: "antenna.radiowaves.left.and.right", title: "Telecom Services", color: .red, category: .services),
                GuideItem(icon: "bag.fill", title: "Shopping Guide", color: .orange, category: .services),
                GuideItem(icon: "cross.fill", title: "Medical Services", color: .red, category: .services)
            ],
            description: "Navigate important services and utilities"
        ),
        
        // Entertainment
        GuideCategory(
            title: "Entertainment",
            icon: "theatermasks.fill",
            items: [
                GuideItem(icon: "ticket.fill", title: "Ticket Booking", color: .purple, category: .entertainment),
                GuideItem(icon: "music.note", title: "Recreation Centers", color: .pink, category: .entertainment),
                GuideItem(icon: "location.fill", title: "Cultural Sites", color: .brown, category: .entertainment),
                GuideItem(icon: "camera.fill", title: "Travel Photography", color: .indigo, category: .entertainment)
            ],
            description: "Discover entertainment and cultural activities"
        )
    ]
} 