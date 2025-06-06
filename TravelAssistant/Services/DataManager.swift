//
//  DataManager.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation

// MARK: - Data Manager
class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var savedPhrases: [SavedPhrase] = []
    @Published var savedPlaces: [SavedPlace] = []
    @Published var chatHistory: [DataChatMessage] = []
    @Published var translationHistory: [TranslationRecord] = []
    @Published var ocrHistory: [OCRRecord] = []
    
    private let userDefaults = UserDefaults.standard
    private let phrasesKey = "SavedPhrases"
    private let placesKey = "SavedPlaces"
    private let chatHistoryKey = "ChatHistory"
    private let translationHistoryKey = "TranslationHistory"
    private let ocrHistoryKey = "OCRHistory"
    
    private init() {
        loadData()
    }
    
    // MARK: - Data Loading
    
    private func loadData() {
        loadSavedPhrases()
        loadSavedPlaces()
        loadChatHistory()
        loadTranslationHistory()
        loadOCRHistory()
    }
    
    private func loadSavedPhrases() {
        if let data = userDefaults.data(forKey: phrasesKey),
           let phrases = try? JSONDecoder().decode([SavedPhrase].self, from: data) {
            self.savedPhrases = phrases
        } else {
            // Load default phrases
            self.savedPhrases = getDefaultPhrases()
            savePhrases()
        }
    }
    
    private func loadSavedPlaces() {
        if let data = userDefaults.data(forKey: placesKey),
           let places = try? JSONDecoder().decode([SavedPlace].self, from: data) {
            self.savedPlaces = places
        }
    }
    
    private func loadChatHistory() {
        if let data = userDefaults.data(forKey: chatHistoryKey),
           let history = try? JSONDecoder().decode([DataChatMessage].self, from: data) {
            self.chatHistory = history
        }
    }
    
    private func loadTranslationHistory() {
        if let data = userDefaults.data(forKey: translationHistoryKey),
           let history = try? JSONDecoder().decode([TranslationRecord].self, from: data) {
            self.translationHistory = history
        }
    }
    
    private func loadOCRHistory() {
        if let data = userDefaults.data(forKey: ocrHistoryKey),
           let history = try? JSONDecoder().decode([OCRRecord].self, from: data) {
            self.ocrHistory = history
        }
    }
    
    // MARK: - Data Saving
    
    private func savePhrases() {
        if let data = try? JSONEncoder().encode(savedPhrases) {
            userDefaults.set(data, forKey: phrasesKey)
        }
    }
    
    private func savePlaces() {
        if let data = try? JSONEncoder().encode(savedPlaces) {
            userDefaults.set(data, forKey: placesKey)
        }
    }
    
    private func saveChatHistory() {
        if let data = try? JSONEncoder().encode(chatHistory) {
            userDefaults.set(data, forKey: chatHistoryKey)
        }
    }
    
    private func saveTranslationHistory() {
        if let data = try? JSONEncoder().encode(translationHistory) {
            userDefaults.set(data, forKey: translationHistoryKey)
        }
    }
    
    private func saveOCRHistory() {
        if let data = try? JSONEncoder().encode(ocrHistory) {
            userDefaults.set(data, forKey: ocrHistoryKey)
        }
    }
    
    // MARK: - Phrase Management
    
    func addPhrase(_ phrase: SavedPhrase) {
        savedPhrases.append(phrase)
        savePhrases()
    }
    
    func removePhrase(at index: Int) {
        guard index < savedPhrases.count else { return }
        savedPhrases.remove(at: index)
        savePhrases()
    }
    
    func updatePhrase(at index: Int, with phrase: SavedPhrase) {
        guard index < savedPhrases.count else { return }
        savedPhrases[index] = phrase
        savePhrases()
    }
    
    // MARK: - Place Management
    
    func addPlace(_ place: SavedPlace) {
        savedPlaces.append(place)
        savePlaces()
    }
    
    func removePlace(at index: Int) {
        guard index < savedPlaces.count else { return }
        savedPlaces.remove(at: index)
        savePlaces()
    }
    
    // MARK: - Chat History Management
    
    func addChatMessage(_ message: DataChatMessage) {
        chatHistory.append(message)
        // Keep only last 100 messages
        if chatHistory.count > 100 {
            chatHistory.removeFirst(chatHistory.count - 100)
        }
        saveChatHistory()
    }
    
    func clearChatHistory() {
        chatHistory.removeAll()
        saveChatHistory()
    }
    
    // MARK: - Translation History Management
    
    func addTranslationRecord(_ record: TranslationRecord) {
        translationHistory.insert(record, at: 0)
        // Keep only last 50 translations
        if translationHistory.count > 50 {
            translationHistory.removeLast(translationHistory.count - 50)
        }
        saveTranslationHistory()
    }
    
    func clearTranslationHistory() {
        translationHistory.removeAll()
        saveTranslationHistory()
    }
    
    // MARK: - OCR History Management
    
    func addOCRRecord(_ record: OCRRecord) {
        ocrHistory.insert(record, at: 0)
        // Keep only last 30 OCR records
        if ocrHistory.count > 30 {
            ocrHistory.removeLast(ocrHistory.count - 30)
        }
        saveOCRHistory()
    }
    
    func clearOCRHistory() {
        ocrHistory.removeAll()
        saveOCRHistory()
    }
    
    // MARK: - Default Data
    
    func getDefaultPhrases() -> [SavedPhrase] {
        return [
            SavedPhrase(english: "Hello", chinese: "你好", category: .greeting),
            SavedPhrase(english: "Thank you", chinese: "谢谢", category: .greeting),
            SavedPhrase(english: "Excuse me", chinese: "不好意思", category: .greeting),
            SavedPhrase(english: "How much is this?", chinese: "这个多少钱？", category: .shopping),
            SavedPhrase(english: "Where is the bathroom?", chinese: "洗手间在哪里？", category: .basic),
            SavedPhrase(english: "I don't speak Chinese", chinese: "我不会说中文", category: .basic),
            SavedPhrase(english: "Can you help me?", chinese: "你能帮助我吗？", category: .basic),
            SavedPhrase(english: "How do I get to...?", chinese: "怎么去...？", category: .transportation),
            SavedPhrase(english: "I need a taxi", chinese: "我需要打车", category: .transportation),
            SavedPhrase(english: "Where is the subway station?", chinese: "地铁站在哪里？", category: .transportation),
            SavedPhrase(english: "I'm looking for a hotel", chinese: "我在找酒店", category: .accommodation),
            SavedPhrase(english: "Do you have a room available?", chinese: "有空房间吗？", category: .accommodation),
            SavedPhrase(english: "I have a reservation", chinese: "我有预订", category: .accommodation),
            SavedPhrase(english: "Can I see the menu?", chinese: "可以看看菜单吗？", category: .dining),
            SavedPhrase(english: "I'm vegetarian", chinese: "我是素食主义者", category: .dining),
            SavedPhrase(english: "No spicy food please", chinese: "请不要辣的", category: .dining),
            SavedPhrase(english: "Call the police", chinese: "叫警察", category: .emergency),
            SavedPhrase(english: "I need a doctor", chinese: "我需要看医生", category: .emergency),
            SavedPhrase(english: "Help!", chinese: "救命！", category: .emergency)
        ]
    }
    
    func getPresetQuestions() -> [PresetQuestion] {
        return [
            PresetQuestion(
                question: "How do I register for WeChat?",
                category: .apps,
                icon: "message.circle"
            ),
            PresetQuestion(
                question: "How to use Alipay for payments?",
                category: .apps,
                icon: "creditcard.circle"
            ),
            PresetQuestion(
                question: "How to use DiDi for taxi rides?",
                category: .transportation,
                icon: "car.circle"
            ),
            PresetQuestion(
                question: "How to buy subway tickets in Beijing?",
                category: .transportation,
                icon: "tram.circle"
            ),
            PresetQuestion(
                question: "What are the best Chinese food apps?",
                category: .dining,
                icon: "takeoutbag.and.cup.and.straw"
            ),
            PresetQuestion(
                question: "How to rent a shared bike?",
                category: .transportation,
                icon: "bicycle.circle"
            ),
            PresetQuestion(
                question: "What should I know about Chinese culture?",
                category: .culture,
                icon: "globe.asia.australia"
            ),
            PresetQuestion(
                question: "How to tip in China?",
                category: .culture,
                icon: "yensign.circle"
            ),
            PresetQuestion(
                question: "Emergency numbers in China",
                category: .emergency,
                icon: "phone.circle"
            ),
            PresetQuestion(
                question: "How to connect to WiFi in public places?",
                category: .technology,
                icon: "wifi.circle"
            )
        ]
    }
}

// MARK: - Data Models

struct SavedPhrase: Codable, Identifiable {
    let id: UUID
    let english: String
    let chinese: String
    let category: PhraseCategory
    let dateAdded: Date
    
    init(english: String, chinese: String, category: PhraseCategory) {
        self.id = UUID()
        self.english = english
        self.chinese = chinese
        self.category = category
        self.dateAdded = Date()
    }
}

struct SavedPlace: Codable, Identifiable {
    let id: UUID
    let englishName: String
    let chineseName: String
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let dateAdded: Date
    
    init(englishName: String, chineseName: String, address: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = UUID()
        self.englishName = englishName
        self.chineseName = chineseName
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.dateAdded = Date()
    }
}

struct DataChatMessage: Codable, Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    init(content: String, isUser: Bool) {
        self.id = UUID()
        self.content = content
        self.isUser = isUser
        self.timestamp = Date()
    }
}

struct TranslationRecord: Codable, Identifiable {
    let id: UUID
    let originalText: String
    let translatedText: String
    let fromLanguage: String
    let toLanguage: String
    let timestamp: Date
    
    init(originalText: String, translatedText: String, fromLanguage: String, toLanguage: String) {
        self.id = UUID()
        self.originalText = originalText
        self.translatedText = translatedText
        self.fromLanguage = fromLanguage
        self.toLanguage = toLanguage
        self.timestamp = Date()
    }
}

struct OCRRecord: Codable, Identifiable {
    let id: UUID
    let originalTexts: [String]
    let translatedTexts: [String]
    let timestamp: Date
    
    init(originalTexts: [String], translatedTexts: [String]) {
        self.id = UUID()
        self.originalTexts = originalTexts
        self.translatedTexts = translatedTexts
        self.timestamp = Date()
    }
}

struct PresetQuestion: Identifiable {
    let id = UUID()
    let question: String
    let category: QuestionCategory
    let icon: String
}

enum PhraseCategory: String, Codable, CaseIterable {
    case greeting = "Greeting"
    case basic = "Basic"
    case shopping = "Shopping"
    case transportation = "Transportation"
    case accommodation = "Accommodation"
    case dining = "Dining"
    case emergency = "Emergency"
    case custom = "Custom"
    
    var displayName: String {
        return self.rawValue
    }
    
    var icon: String {
        switch self {
        case .greeting:
            return "hand.wave"
        case .basic:
            return "bubble.left.and.bubble.right"
        case .shopping:
            return "bag"
        case .transportation:
            return "car"
        case .accommodation:
            return "bed.double"
        case .dining:
            return "fork.knife"
        case .emergency:
            return "exclamationmark.triangle"
        case .custom:
            return "star"
        }
    }
}

enum QuestionCategory: String, CaseIterable {
    case apps = "Apps"
    case transportation = "Transportation"
    case dining = "Dining"
    case culture = "Culture"
    case emergency = "Emergency"
    case technology = "Technology"
    
    var displayName: String {
        return self.rawValue
    }
} 