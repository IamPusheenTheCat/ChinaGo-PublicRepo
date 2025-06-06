//
//  ParkingGuideView.swift
//  TravelAssistant
//
//  Created by taoranmr on 6/2/25.
//

import SwiftUI

struct ParkingGuideView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    ZStack {
                        Rectangle()
                            .fill(LinearGradient(gradient: Gradient(colors: [.green, .green.opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(height: 200)
                            .cornerRadius(15)
                        
                        VStack {
                            Image(systemName: "parkingsign")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                            Text("Complete Parking Guide in China")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Parking Types
                        Text("🅿️ Parking Types")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            parkingTypeItem(
                                icon: "building.2.fill",
                                title: "Mall Parking",
                                description: "Usually 2-3 hours free, shopping extends free duration",
                                color: .blue
                            )
                            
                            parkingTypeItem(
                                icon: "road.lanes",
                                title: "Street Parking",
                                description: "Rates vary by area, higher in city centers",
                                color: .orange
                            )
                            
                            parkingTypeItem(
                                icon: "house.fill",
                                title: "Residential Areas",
                                description: "Mostly for residents, visitors need registration",
                                color: .purple
                            )
                            
                            parkingTypeItem(
                                icon: "car.garage",
                                title: "Parking Garages",
                                description: "24/7 operation, hourly rates, secure parking",
                                color: .green
                            )
                        }
                        
                        // Parking Fees
                        Text("💰 Parking Fee Standards")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("📍 City Center: ¥3-8/hour")
                            Text("🏢 Office Buildings & Malls: ¥2-5/hour, free with purchase")
                            Text("🛣️ Street Parking: ¥1-3/hour")
                            Text("🌙 Overnight Parking: Usually ¥5-15")
                            Text("✈️ Long-term Airport Parking: ¥20-50/day")
                        }
                        .font(.body)
                        
                        // Payment Methods
                        Text("💳 Payment Methods")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            paymentMethodItem(
                                icon: "qrcode.viewfinder",
                                title: "QR Code Payment",
                                description: "Scan code at entrance, pay via phone when leaving, most common method"
                            )
                            
                            paymentMethodItem(
                                icon: "creditcard",
                                title: "Self-Service Kiosk",
                                description: "Accepts cash, cards, Alipay, and WeChat Pay"
                            )
                            
                            paymentMethodItem(
                                icon: "person.fill",
                                title: "Manual Collection",
                                description: "Traditional method, common in smaller lots"
                            )
                            
                            paymentMethodItem(
                                icon: "iphone",
                                title: "Parking Apps",
                                description: "ETCP, PP Parking etc., for reservations and remote payment"
                            )
                        }
                        
                        // Parking Tips
                        Text("🎯 Useful Parking Tips")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Check nearby parking lots using navigation apps beforehand")
                            Text("• Ask about parking discounts when shopping")
                            Text("• Remember your parking spot number, take a photo for safety")
                            Text("• Avoid parking in restricted areas and fire lanes")
                            Text("• Choose monitored parking lots at night")
                        }
                        .font(.body)
                        
                        // Popular Parking Apps
                        Text("📱 Recommended Parking Apps")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            appItem(
                                name: "ETCP Parking",
                                description: "Covers major cities, supports reservations and navigation",
                                features: ["Automatic Payment", "Spot Reservation", "Coupons"]
                            )
                            
                            appItem(
                                name: "PP Parking",
                                description: "Smart parking service, quick spot finding",
                                features: ["Smart Navigation", "Quick Payment", "Member Benefits"]
                            )
                            
                            appItem(
                                name: "Gaode Maps",
                                description: "Not just navigation, also finds nearby parking",
                                features: ["Parking Info", "Real-time Spots", "Price Display"]
                            )
                        }
                        
                        // Important Notes
                        Text("⚠️ Important Notes")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("🚫 No Parking in these areas:")
                            Text("  · Fire lanes and emergency exits")
                            Text("  · Disabled parking spaces")
                            Text("  · Yellow and red line zones")
                            Text("  · Within 50m of bus stops")
                            Text("⏰ Watch for time-limited parking signs")
                            Text("📝 Keep parking receipts for verification")
                            Text("🔒 Don't leave valuables in the car")
                        }
                        .font(.body)
                        
                        // Summary
                        Text("🎉 Summary")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("Smart parking planning is crucial for travel. Research parking options in advance, choose official parking lots, follow traffic rules to save time, money, and avoid violations and safety issues.")
                            .font(.body)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Parking Guide")
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
    
    private func parkingTypeItem(icon: String, title: String, description: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func paymentMethodItem(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
    
    private func appItem(name: String, description: String, features: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(features, id: \.self) { feature in
                    Text(feature)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
}

struct ParkingGuideView_Previews: PreviewProvider {
    static var previews: some View {
        ParkingGuideView()
    }
} 