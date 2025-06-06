//
//  HighSpeedRailArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct HighSpeedRailArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTicketType = 0
    @State private var selectedClassType = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Hero Section with Interactive Elements
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .cyan, .blue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "train.side.front.car")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("China's High-Speed Rail")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Travel at 350km/h • Connect 40,000km across China")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Quick Facts Card
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "speedometer")
                                    .foregroundColor(.blue)
                                Text("Quick Facts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                quickFactItem(icon: "clock", value: "350km/h", label: "Top Speed")
                                quickFactItem(icon: "map", value: "40,000km", label: "Network Size")
                                quickFactItem(icon: "building.2", value: "1,000+", label: "Stations")
                                quickFactItem(icon: "person.3", value: "3B+", label: "Annual Riders")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Train Types with Interactive Picker
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "train.side.front.car")
                                    .foregroundColor(.green)
                                Text("Train Types")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Train Type", selection: $selectedTicketType) {
                                Text("G-Series").tag(0)
                                Text("D-Series").tag(1)
                                Text("C-Series").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            VStack(spacing: 12) {
                                if selectedTicketType == 0 {
                                    trainTypeCard(
                                        type: "G-Series (High-Speed)",
                                        speed: "300-350 km/h",
                                        description: "The fastest trains connecting major cities. Premium comfort with first-class service.",
                                        routes: ["Beijing-Shanghai: 4.5hrs", "Beijing-Guangzhou: 8hrs"],
                                        color: .blue
                                    )
                                } else if selectedTicketType == 1 {
                                    trainTypeCard(
                                        type: "D-Series (Electric)",
                                        speed: "200-250 km/h",
                                        description: "Reliable intercity service with good speed and comfort balance.",
                                        routes: ["Shanghai-Hangzhou: 1hr", "Guangzhou-Shenzhen: 1.5hrs"],
                                        color: .green
                                    )
                                } else {
                                    trainTypeCard(
                                        type: "C-Series (Intercity)",
                                        speed: "160-200 km/h",
                                        description: "Short-distance travel between nearby cities, frequent departures.",
                                        routes: ["Beijing-Tianjin: 30mins", "Guangzhou-Foshan: 45mins"],
                                        color: .orange
                                    )
                                }
                            }
                        }
                        
                        // Seat Classes with Visual Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "chair")
                                    .foregroundColor(.purple)
                                Text("Seat Classes")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Class Type", selection: $selectedClassType) {
                                Text("Business").tag(0)
                                Text("First Class").tag(1)
                                Text("Second Class").tag(2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            VStack(spacing: 12) {
                                if selectedClassType == 0 {
                                    seatClassCard(
                                        className: "Business Class",
                                        layout: "2+1 seating",
                                        features: ["Lie-flat seats", "Premium meals", "Priority boarding", "Quiet car"],
                                        price: "2-3x Second Class",
                                        color: .purple
                                    )
                                } else if selectedClassType == 1 {
                                    seatClassCard(
                                        className: "First Class",
                                        layout: "2+2 seating",
                                        features: ["Spacious seats", "Power outlets", "Better legroom", "Snack service"],
                                        price: "1.5x Second Class",
                                        color: .blue
                                    )
                                } else {
                                    seatClassCard(
                                        className: "Second Class",
                                        layout: "3+2 seating",
                                        features: ["Standard comfort", "Power outlets", "Basic amenities", "Most popular"],
                                        price: "Base price",
                                        color: .green
                                    )
                                }
                            }
                        }
                        
                        // Step-by-Step Booking Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "ticket")
                                    .foregroundColor(.orange)
                                Text("How to Book Tickets")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                bookingStep(number: 1, title: "Choose Your Platform", description: "12306 app (official) or Trip.com (English-friendly)")
                                bookingStep(number: 2, title: "Select Journey", description: "Pick departure/arrival cities and travel date")
                                bookingStep(number: 3, title: "Choose Train & Seat", description: "Compare times, prices, and seat availability")
                                bookingStep(number: 4, title: "Enter Passenger Info", description: "Passport details for foreigners, ID for locals")
                                bookingStep(number: 5, title: "Pay & Collect", description: "Online payment, then collect at station or scan QR code")
                            }
                        }
                        .padding(20)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Station Navigation Tips
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "building.columns")
                                    .foregroundColor(.red)
                                Text("Station Navigation")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🎫 Ticket Collection")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text("• Use passport at machines")
                                    Text("• Staff counters available")
                                    Text("• QR codes work too")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🔍 Security Check")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    Text("• Similar to airports")
                                    Text("• Allow 15-20 minutes")
                                    Text("• No liquids over 100ml")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("⏰ Boarding Process")
                                        .font(.headline)
                                        .foregroundColor(.orange)
                                    Text("• Find your platform")
                                    Text("• Check car number")
                                    Text("• Board 5-10 mins early")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("🥪 Onboard Services")
                                        .font(.headline)
                                        .foregroundColor(.purple)
                                    Text("• Food cart service")
                                    Text("• WiFi available")
                                    Text("• Clean restrooms")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(20)
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Pro Tips Section
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "lightbulb")
                                    .foregroundColor(.yellow)
                                Text("Pro Traveler Tips")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                tipCard(icon: "calendar", tip: "Book 30 days ahead for best prices and seat selection")
                                tipCard(icon: "clock", tip: "Avoid Golden Week (Oct 1-7) and Spring Festival travel rush")
                                tipCard(icon: "smartphone", tip: "Download offline maps - stations can be huge complexes")
                                tipCard(icon: "bag", tip: "Pack light - luggage storage is limited")
                                tipCard(icon: "battery.100", tip: "Bring power bank - outlets might be occupied")
                            }
                        }
                        
                        // Environmental Impact
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "leaf")
                                    .foregroundColor(.green)
                                Text("Why Choose High-Speed Rail?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                                benefitCard(icon: "airplane", title: "vs Flying", benefit: "No weather delays, city center to city center")
                                benefitCard(icon: "car", title: "vs Driving", benefit: "No traffic jams, no parking hassles")
                                benefitCard(icon: "leaf", title: "Eco-Friendly", benefit: "80% less CO2 than flying same distance")
                                benefitCard(icon: "clock", title: "Time Efficient", benefit: "Factor in airport time - HSR often faster")
                            }
                        }
                        
                        // Bottom Summary
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Ready to Ride!")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Text("China's high-speed rail is more than transportation—it's an experience. With comfort, speed, and reliability, it's the best way to see the country. Book your journey and enjoy the ride! 🚄")
                                .font(.body)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("High-Speed Rail")
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
    private func quickFactItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(height: 80)
    }
    
    private func trainTypeCard(type: String, speed: String, description: String, routes: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(type)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(speed)
                    .font(.subheadline)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Popular Routes:")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                ForEach(routes, id: \.self) { route in
                    Text("• \(route)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func seatClassCard(className: String, layout: String, features: [String], price: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(className)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(price)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            
            Text(layout)
                .font(.body)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .foregroundColor(color)
                        Text(feature)
                            .font(.caption)
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func bookingStep(number: Int, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text("\(number)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.orange)
                .clipShape(Circle())
            
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
    
    private func tipCard(icon: String, tip: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.yellow)
                .frame(width: 25)
            
            Text(tip)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func benefitCard(icon: String, title: String, benefit: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(benefit)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
        .frame(height: 120)
    }
}

#Preview {
    HighSpeedRailArticleView()
}