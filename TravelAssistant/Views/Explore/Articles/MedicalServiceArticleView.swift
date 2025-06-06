//
//  MedicalServiceArticleView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct MedicalServiceArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedHealthTopic = 0
    @State private var selectedCareLevel = 0
    @State private var showingWellnessPlan = false
    
    let healthTopics = ["Preventive Care", "Emergency Prep", "Traditional Medicine", "Mental Wellness"]
    let careLevels = ["Self-Care", "Community Clinics", "General Hospitals", "Specialized Centers"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Wellness Guide Hero
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.mint, .green, .teal]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(height: 280)
                        .cornerRadius(20)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .shadow(radius: 10)
                            
                            Text("Your Health Journey")
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            Text("Holistic Wellness Guide • Stay Healthy • Feel Confident • Live Better")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 30) {
                        
                        // Health Philosophy
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.green)
                                Text("Our Wellness Philosophy")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Health is a journey, not a destination")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            
                            VStack(spacing: 15) {
                                wellnessCard(
                                    principle: "Prevention First",
                                    icon: "🛡️",
                                    description: "Small daily choices create lasting health habits",
                                    benefit: "Avoid 80% of health issues"
                                )
                                
                                wellnessCard(
                                    principle: "Mind-Body Connection", 
                                    icon: "🧘‍♀️",
                                    description: "Mental wellness is just as important as physical health",
                                    benefit: "Stress resilience & emotional balance"
                                )
                                
                                wellnessCard(
                                    principle: "Cultural Integration",
                                    icon: "🌸",
                                    description: "Embrace both modern and traditional healing approaches",
                                    benefit: "Best of both worlds"
                                )
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        }
                        .background(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(15)
                        
                        // Health Topic Explorer
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                    .foregroundColor(.pink)
                                Text("Health & Wellness Topics")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Choose your focus area")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            Picker("Health Topic", selection: $selectedHealthTopic) {
                                ForEach(0..<healthTopics.count, id: \.self) { index in
                                    Text(healthTopics[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            healthTopicContent(for: selectedHealthTopic)
                        }
                        
                        // Care Level Guide
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "building.2.crop.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Your Care Journey")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            Picker("Care Level", selection: $selectedCareLevel) {
                                ForEach(0..<careLevels.count, id: \.self) { index in
                                    Text(careLevels[index]).tag(index)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            careLevelContent(for: selectedCareLevel)
                        }
                        .padding(20)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Daily Wellness Habits
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.yellow)
                                Text("Daily Wellness Habits")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Text("Small steps, big changes")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(spacing: 12) {
                                habitCard(
                                    time: "Morning",
                                    habit: "Mindful Start",
                                    activities: ["5-min meditation", "Hydrate with warm water", "Light stretching"],
                                    benefit: "Sets positive tone for the day"
                                )
                                
                                habitCard(
                                    time: "Midday",
                                    habit: "Energy Balance",
                                    activities: ["Nutritious lunch", "10-min walk", "Deep breathing"],
                                    benefit: "Maintains steady energy levels"
                                )
                                
                                habitCard(
                                    time: "Evening",
                                    habit: "Recovery & Rest",
                                    activities: ["Digital sunset", "Gentle yoga", "Gratitude practice"],
                                    benefit: "Quality sleep & stress relief"
                                )
                            }
                        }
                        
                        // Health Emergency Kit
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "cross.circle.fill")
                                    .foregroundColor(.red)
                                Text("Health Emergency Kit")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                emergencySection(
                                    category: "Essential Medications",
                                    items: ["Pain relievers (ibuprofen/acetaminophen)", "Stomach remedies", "Allergy antihistamines", "Thermometer"],
                                    tip: "Keep medicines in original packaging with labels"
                                )
                                
                                emergencySection(
                                    category: "Health Documentation",
                                    items: ["Insurance cards", "Medical history summary", "Emergency contacts", "Prescription list"],
                                    tip: "Store digital copies in cloud storage"
                                )
                                
                                emergencySection(
                                    category: "Communication Tools",
                                    items: ["Translation app", "Medical dictionary", "Hospital finder app", "Emergency numbers"],
                                    tip: "Test apps before you need them"
                                )
                            }
                        }
                        .padding(20)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(15)
                        
                        // Traditional Chinese Medicine Journey
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "leaf.arrow.circlepath")
                                    .foregroundColor(.green)
                                Text("Traditional Medicine Discovery")
                                    .font(.title2)
                                    .fontWeight(.bold)
                            }
                            
                            VStack(spacing: 12) {
                                tcmCard(
                                    practice: "Acupuncture",
                                    description: "Ancient healing through energy flow balance",
                                    benefits: ["Pain relief", "Stress reduction", "Better sleep"],
                                    experience: "Many visitors find it surprisingly relaxing"
                                )
                                
                                tcmCard(
                                    practice: "Herbal Medicine",
                                    description: "Personalized natural remedies for wellness",
                                    benefits: ["Digestive health", "Immune support", "Energy balance"],
                                    experience: "Great for addressing chronic conditions"
                                )
                                
                                tcmCard(
                                    practice: "Tuina Massage",
                                    description: "Therapeutic massage with pressure point therapy",
                                    benefits: ["Muscle tension relief", "Circulation boost", "Relaxation"],
                                    experience: "Perfect after long days of travel"
                                )
                            }
                        }
                        
                        // Wellness Plan Creator
                        if showingWellnessPlan {
                            VStack(spacing: 15) {
                                HStack {
                                    Text("📋")
                                        .font(.largeTitle)
                                    VStack(alignment: .leading) {
                                        Text("Your Personal Wellness Plan")
                                            .font(.title)
                                            .fontWeight(.bold)
                                        Text("Tailored for your journey")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("🌅 **Morning**: Start with intention and self-care")
                                    Text("🌿 **Nutrition**: Explore healthy local foods and TCM teas")
                                    Text("🚶‍♀️ **Movement**: Include walking, tai chi, or local fitness options")
                                    Text("🧘‍♀️ **Mindfulness**: Practice stress management and cultural mindfulness")
                                    Text("💤 **Rest**: Prioritize quality sleep and recovery")
                                }
                                .font(.body)
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                        
                        // Call to Action
                        Button(action: {
                            showingWellnessPlan.toggle()
                        }) {
                            Text(showingWellnessPlan ? "Hide Wellness Plan" : "Create My Wellness Plan 🌟")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(showingWellnessPlan ? Color.gray : Color.green)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Health & Wellness")
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
    private func wellnessCard(principle: String, icon: String, description: String, benefit: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Text(icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(principle)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                Text("✨ \(benefit)")
                    .font(.caption)
                    .foregroundColor(.green)
                    .italic()
            }
            
            Spacer()
        }
    }
    
    private func healthTopicContent(for topic: Int) -> some View {
        VStack(spacing: 15) {
            switch topic {
            case 0: // Preventive Care
                preventiveCareContent()
            case 1: // Emergency Prep
                emergencyPrepContent()
            case 2: // Traditional Medicine
                traditionalMedicineContent()
            case 3: // Mental Wellness
                mentalWellnessContent()
            default:
                EmptyView()
            }
        }
    }
    
    private func preventiveCareContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preventive Care - Your Best Investment")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            VStack(spacing: 10) {
                preventiveItem(
                    action: "Regular Health Checkups",
                    frequency: "Annually",
                    benefit: "Early detection saves lives and money",
                    tip: "Many expat-friendly clinics offer comprehensive packages"
                )
                
                preventiveItem(
                    action: "Dental Care",
                    frequency: "Every 6 months",
                    benefit: "Prevent costly emergency procedures",
                    tip: "China has excellent dental care at affordable prices"
                )
                
                preventiveItem(
                    action: "Eye Exams",
                    frequency: "Every 2 years",
                    benefit: "Maintain good vision and detect early issues",
                    tip: "Great opportunity to update your prescription glasses"
                )
                
                preventiveItem(
                    action: "Vaccination Updates",
                    frequency: "As recommended",
                    benefit: "Stay protected against local health risks",
                    tip: "Check with international clinics for travel vaccines"
                )
            }
            
            Text("💡 Remember: Prevention is always better (and cheaper) than treatment!")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func preventiveItem(action: String, frequency: String, benefit: String, tip: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(action)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text(frequency)
                    .font(.caption)
                    .foregroundColor(.pink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.pink.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Text(benefit)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("💡 \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    private func emergencyPrepContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Emergency Preparedness - Stay Confident")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            VStack(spacing: 10) {
                emergencyStepCard(
                    step: "1",
                    title: "Know Your Numbers",
                    details: ["120 - Emergency medical", "110 - Police emergency", "119 - Fire emergency"],
                    action: "Save these in your phone contacts"
                )
                
                emergencyStepCard(
                    step: "2",
                    title: "Identify Nearby Hospitals",
                    details: ["Find 2-3 options near home/work", "Check which accept foreigners", "Know their emergency entrance"],
                    action: "Visit during non-emergency to familiarize"
                )
                
                emergencyStepCard(
                    step: "3",
                    title: "Prepare Communication",
                    details: ["Learn basic medical Chinese phrases", "Download translation apps", "Keep insurance info accessible"],
                    action: "Practice explaining your condition beforehand"
                )
            }
            
            Text("🆘 Stay calm, be prepared, and remember help is always available")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func emergencyStepCard(step: String, title: String, details: [String], action: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(step)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.red)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                ForEach(details, id: \.self) { detail in
                    Text("• \(detail)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text("→ \(action)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(8)
    }
    
    private func traditionalMedicineContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Traditional Medicine - Ancient Wisdom")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            Text("Traditional Chinese Medicine offers a holistic approach to health, focusing on balance and prevention. It's a beautiful complement to modern healthcare.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                tcmApproachCard(
                    approach: "Holistic Assessment",
                    description: "Practitioners look at your whole lifestyle, not just symptoms",
                    benefit: "Addresses root causes, not just surface issues"
                )
                
                tcmApproachCard(
                    approach: "Natural Remedies",
                    description: "Herbal formulas customized to your specific constitution",
                    benefit: "Gentle, side-effect minimal treatments"
                )
                
                tcmApproachCard(
                    approach: "Lifestyle Integration",
                    description: "Diet, exercise, and stress management recommendations",
                    benefit: "Sustainable long-term health improvements"
                )
            }
            
            Text("🌿 TCM works best alongside modern medicine, not as a replacement")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func tcmApproachCard(approach: String, description: String, benefit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(approach)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("✨ \(benefit)")
                .font(.caption)
                .foregroundColor(.green)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func mentalWellnessContent() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mental Wellness - Inner Harmony")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.pink)
            
            Text("Your mental health journey is just as important as your physical health. Living in a new culture can be both exciting and challenging.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                mentalWellnessCard(
                    area: "Stress Management",
                    techniques: ["Deep breathing exercises", "Mindfulness meditation", "Regular exercise"],
                    tip: "Start with just 5 minutes daily - consistency beats duration"
                )
                
                mentalWellnessCard(
                    area: "Cultural Adaptation",
                    techniques: ["Join expat communities", "Learn local customs", "Practice language skills"],
                    tip: "It's normal to feel overwhelmed sometimes - be patient with yourself"
                )
                
                mentalWellnessCard(
                    area: "Social Connection",
                    techniques: ["Video calls with family", "Join hobby groups", "Volunteer locally"],
                    tip: "Quality relationships are the strongest predictor of happiness"
                )
            }
            
            Text("💙 Remember: Seeking help for mental health is a sign of strength, not weakness")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.pink.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func mentalWellnessCard(area: String, techniques: [String], tip: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(area)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.purple)
            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(techniques, id: \.self) { technique in
                    Text("• \(technique)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("💡 \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func careLevelContent(for level: Int) -> some View {
        let careData = [
            (
                title: "Self-Care - Your Daily Foundation",
                description: "The most important healthcare happens at home through daily habits",
                approaches: ["Healthy nutrition choices", "Regular exercise routine", "Adequate sleep schedule", "Stress management"],
                when: "Use for: Daily wellness, minor issues, prevention",
                tip: "80% of health outcomes come from lifestyle choices, not medical care"
            ),
            (
                title: "Community Clinics - Your Neighborhood Support",
                description: "Local clinics for routine care and minor health concerns",
                approaches: ["Regular checkups", "Vaccinations", "Minor illness treatment", "Health education"],
                when: "Use for: Routine care, minor illnesses, ongoing conditions",
                tip: "Build relationships with local healthcare providers for continuity"
            ),
            (
                title: "General Hospitals - Comprehensive Care",
                description: "Full-service hospitals for serious conditions and complex care",
                approaches: ["Emergency services", "Specialist referrals", "Advanced diagnostics", "Surgical procedures"],
                when: "Use for: Serious conditions, emergencies, complex diagnoses",
                tip: "Larger hospitals often have international departments with English support"
            ),
            (
                title: "Specialized Centers - Expert Care",
                description: "Specialized facilities for specific conditions or advanced treatments",
                approaches: ["Cancer treatment centers", "Cardiac specialists", "Rehabilitation facilities", "Mental health centers"],
                when: "Use for: Specialized conditions, second opinions, advanced treatments",
                tip: "Many specialized centers have partnerships with international hospitals"
            )
        ]
        
        let care = careData[level]
        
        return VStack(alignment: .leading, spacing: 12) {
            Text(care.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text(care.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Key Approaches:")
                    .font(.caption)
                    .fontWeight(.bold)
                ForEach(care.approaches, id: \.self) { approach in
                    Text("• \(approach)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(care.when)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            
            Text("💡 \(care.tip)")
                .font(.caption)
                .foregroundColor(.green)
                .italic()
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
    }
    
    private func habitCard(time: String, habit: String, activities: [String], benefit: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(time)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.yellow)
                Text(habit)
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(activities, id: \.self) { activity in
                    Text("• \(activity)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("✨ \(benefit)")
                .font(.caption)
                .foregroundColor(.green)
                .italic()
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func emergencySection(category: String, items: [String], tip: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(items, id: \.self) { item in
                    Text("• \(item)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text("💡 \(tip)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(10)
    }
    
    private func tcmCard(practice: String, description: String, benefits: [String], experience: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(practice)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.green)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Benefits:")
                    .font(.caption)
                    .fontWeight(.bold)
                ForEach(benefits, id: \.self) { benefit in
                    Text("• \(benefit)")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Text("✨ \(experience)")
                .font(.caption)
                .foregroundColor(.blue)
                .italic()
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    MedicalServiceArticleView()
}