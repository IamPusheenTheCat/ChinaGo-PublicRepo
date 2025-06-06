//
//  TranslatorView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

// Translation message data model
struct TranslationMessage: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
    let isSourceChinese: Bool
    let timestamp = Date()
}

struct TranslatorView: View {
    @StateObject private var networkService = NetworkService.shared
    @StateObject private var speechService = SpeechService.shared
    @StateObject private var dataManager = DataManager.shared
    
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var sourceLanguage: String = "English"
    @State private var targetLanguage: String = "Chinese"
    @State private var isRecording: Bool = false
    @State private var isTranslating: Bool = false
    @State private var showingSavedPhrases: Bool = false
    @State private var showingHistory: Bool = false
    @State private var showingAllPhrases: Bool = false
    @State private var errorMessage: String?
    @State private var showingError: Bool = false
    
    @FocusState private var isTextEditorFocused: Bool
    
    // Available languages list
    let availableLanguages = ["English", "Chinese", "Japanese", "Korean", "French", "Spanish", "German"]
    
    // Language placeholder text mapping
    private var languagePlaceholders: [String: (enter: String, placeholder: String)] {
        return [
            "English": (enter: "Enter English", placeholder: "Enter text here..."),
            "Chinese": (enter: "Enter Chinese", placeholder: "Enter text here..."),
            "Japanese": (enter: "Enter Japanese", placeholder: "Enter text here..."),
            "Korean": (enter: "Enter Korean", placeholder: "Enter text here..."),
            "French": (enter: "Enter French", placeholder: "Enter text here..."),
            "Spanish": (enter: "Enter Spanish", placeholder: "Enter text here..."),
            "German": (enter: "Enter German", placeholder: "Enter text here...")
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top title
                HStack {
                    Text("Translator")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                    
                    Spacer()
                    
                    // Three-point menu
                    Menu {
                        Button(action: {
                            showingHistory = true
                        }) {
                            Label("Translation history", systemImage: "clock")
                        }
                        
                        Button(action: {
                            clearAll()
                        }) {
                            Label("Clear content", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                            .padding(.top, 5)
                            .padding(.bottom, 10)
                    }
                }
                
                // Language selection area
                languageSelectionSection
                
                // Main translation area
                ScrollViewReader { proxy in
                ScrollView {
                        VStack(spacing: 12) {
                        // Input area
                        inputSection
                        
                        // Translation result area
                        if !translatedText.isEmpty || isTranslating {
                            translationResultSection
                        }
                        
                        // Common phrases area
                        if showingSavedPhrases {
                            savedPhrasesSection
                                    .id("savedPhrases")
                        }
                        
                        // Recent translation history quick access
                        if !dataManager.translationHistory.isEmpty && !showingHistory {
                            recentTranslationsSection
                        }
                    }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .onChange(of: showingSavedPhrases) { isShowing in
                        if isShowing {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("savedPhrases", anchor: .top)
                        }
                        }
                    }
                }
                
                // Bottom toolbar
                bottomToolbar
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
            .sheet(isPresented: $showingHistory) {
                TranslationHistoryView()
            }
            .sheet(isPresented: $showingAllPhrases) {
                SavedPhrasesView()
        }
        .onAppear {
            speechService.requestPermission()
                loadDemoTranslation()
            }
        }
    }
    
    // MARK: - Language Selection Section
    private var languageSelectionSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                // Source language dropdown selector
                VStack(spacing: 6) {
                    Text("Source language")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Menu {
                        ForEach(availableLanguages, id: \.self) { language in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                sourceLanguage = language
                                }
                            }) {
                                HStack {
                                    Text(language)
                                    if sourceLanguage == language {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(sourceLanguage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(height: 36)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                }
                
                // Language swap button
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        swapLanguages()
                    }
                }) {
                    Image(systemName: "arrow.triangle.swap")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .pink]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                        .shadow(color: .orange.opacity(0.4), radius: 6, x: 0, y: 3)
                        .rotationEffect(.degrees(90))
                }
                
                // Target language dropdown selector
                VStack(spacing: 6) {
                    Text("Target language")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fontWeight(.medium)
                    
                    Menu {
                        ForEach(availableLanguages.filter { $0 != sourceLanguage }, id: \.self) { language in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                targetLanguage = language
                                }
                            }) {
                                HStack {
                                    Text(language)
                                    if targetLanguage == language {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(targetLanguage)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(height: 36)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .teal]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(languagePlaceholders[sourceLanguage]?.enter ?? "Enter Text")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !inputText.isEmpty {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                        clearInput()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                            .opacity(0.7)
                    }
                }
            }
            
            VStack(spacing: 12) {
                // Speech recording indicator
                if isRecording {
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                                .scaleEffect(1.2)
                                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isRecording)
                            
                            Text("Recording...")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.red)
                        }
                        
                        Text(speechService.recognizedText)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.red.opacity(0.1),
                                Color.orange.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                    )
                }
                
                // Text input field
                ZStack(alignment: .topLeading) {
                    if inputText.isEmpty {
                        VStack {
                            HStack {
                                Text(languagePlaceholders[sourceLanguage]?.placeholder ?? "Enter text here...")
                                    .foregroundColor(.secondary.opacity(0.6))
                                    .font(.body)
                                    .padding(.top, 8)
                                    .padding(.leading, 4)
                                Spacer()
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                TextEditor(text: $inputText)
                    .font(.body)
                    .padding()
                    .frame(minHeight: 80)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .focused($isTextEditorFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isTextEditorFocused = false
                            }
                        }
                    }
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.3),
                            Color.blue.opacity(0.05)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    )
                .cornerRadius(16)
                    .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(inputText.isEmpty ? Color.gray.opacity(0.3) : Color.blue.opacity(0.5), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                
                // Input toolbar
                HStack(spacing: 16) {
                    // Speech input button
                    Button(action: {
                        toggleRecording()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                                .font(.subheadline)
                            Text(isRecording ? "Stop recording" : "Voice input")
                                .font(.caption)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .frame(minWidth: 130)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: isRecording ? [.red, .orange] : [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: (isRecording ? Color.red : Color.blue).opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    
                    Spacer()
                    
                    // Read button
                    if !inputText.isEmpty {
                        Button(action: {
                            speakText(inputText, isTranslated: false)
                        }) {
                            Image(systemName: "speaker.wave.3.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .frame(width: 36, height: 36)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    
                    // Translate button
                    Button(action: {
                        translateText()
                    }) {
                        HStack(spacing: 8) {
                            if isTranslating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.subheadline)
                            }
                            Text("Translate")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .frame(minWidth: 110)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: inputText.isEmpty ? [.gray, .gray] : [.green, .teal]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: (inputText.isEmpty ? Color.gray : Color.green).opacity(0.3), radius: 6, x: 0, y: 3)
                    }
                    .disabled(inputText.isEmpty || isTranslating)
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Translation Result Section
    private var translationResultSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                Text("Results")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Language label placed in title line middle
                if !translatedText.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "globe")
                            .foregroundColor(.green)
                            .font(.subheadline)
                        Text(targetLanguage)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
                
                Spacer()
                
                if !translatedText.isEmpty {
                    Button(action: {
                        saveTranslation()
                    }) {
                        HStack(spacing: 6) {
                        Image(systemName: "bookmark.fill")
                                .font(.subheadline)
                            Text("Save")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .purple]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(10)
                    }
                }
            }
            
            if isTranslating {
                VStack(spacing: 16) {
                    HStack(spacing: 12) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                    Text("Translating...") 
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                            
                            Text("Please wait")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        }
                    }
                    
                    // Load animation bar
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.blue.opacity(0.6))
                                .frame(width: 60, height: 4)
                                .scaleEffect(x: 1, y: 1, anchor: .leading)
                                .animation(
                                    .easeInOut(duration: 1.0)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: isTranslating
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .padding(.horizontal, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.05),
                            Color.purple.opacity(0.03)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            } else if !translatedText.isEmpty {
                VStack(alignment: .leading, spacing: 16) {
                    // Translated text
                VStack(alignment: .leading, spacing: 12) {
                        ScrollView {
                            VStack {
                                HStack {
                    Text(translatedText)
                        .font(.body)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding(.top, 8)
                                        .padding(.leading, 4)
                                    Spacer()
                                }
                                Spacer()
                            }
                        .padding()
                        }
                        .frame(minHeight: 80)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(.systemBackground),
                                    Color.green.opacity(0.05)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                        )
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    }
                    
                    // Result toolbar
                    HStack(spacing: 16) {
                        Button(action: {
                            UIPasteboard.general.string = translatedText
                        }) {
                            Label("Copy Translation", systemImage: "doc.on.doc.fill")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            speakText(translatedText, isTranslated: true)
                        }) {
                            Image(systemName: "speaker.wave.3.fill")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue.opacity(0.1),
                                            Color.purple.opacity(0.05)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color.green.opacity(0.03)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Saved Phrases Section
    private var savedPhrasesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Common phrases")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Collapse") {
                    withAnimation(.spring()) {
                        showingSavedPhrases = false
                    }
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            if dataManager.savedPhrases.isEmpty {
                Text("Unsaved phrases")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(Array(dataManager.savedPhrases.prefix(5)), id: \.id) { phrase in
                        SavedPhraseRow(phrase: phrase) { selectedPhrase in
                            loadPhrase(selectedPhrase)
                        }
                    }
                    
                    if dataManager.savedPhrases.count > 5 {
                        Button("View All Phrases") {
                            showingAllPhrases = true
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Recent Translations Section
    private var recentTranslationsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Translations")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    showingHistory = true
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            LazyVStack(spacing: 8) {
                ForEach(Array(dataManager.translationHistory.prefix(3)), id: \.id) { record in
                    TranslationHistoryCard(record: record) {
                        loadTranslationRecord(record)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Bottom Toolbar
    private var bottomToolbar: some View {
        HStack(spacing: 40) {
            Button(action: {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showingSavedPhrases.toggle()
                }
            }) {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple, .blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 42, height: 42)
                            .shadow(color: .purple.opacity(0.3), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: showingSavedPhrases ? "bookmark.fill" : "bookmark.circle.fill")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Text("Phrases")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(showingSavedPhrases ? .purple : .primary)
                }
            }
            
            Spacer()
            
            Button(action: {
                showingHistory = true
            }) {
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [.green, .teal]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 42, height: 42)
                            .shadow(color: .green.opacity(0.3), radius: 6, x: 0, y: 3)
                        
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                    
                    Text("History")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.3)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(.systemGray5))
                .opacity(0.5),
            alignment: .top
        )
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -2)
    }
    
    // MARK: - Methods
    
    private func translateText() {
        guard !inputText.isEmpty else { return }
        
        Task {
            await performTranslation()
        }
    }
    
    @MainActor
    private func performTranslation() async {
        isTranslating = true
        translatedText = ""
        
        do {
            let fromLanguage = sourceLanguage
            let toLanguage = targetLanguage
            
            // Use DeepSeek for translation
            let systemMessage = APIConfig.DeepSeekRequest.Message(
                role: "system",
                content: "You are a professional translator. Translate the given text from \(fromLanguage) to \(toLanguage). Only return the translated text without any additional explanation."
            )
            
            let userMessage = APIConfig.DeepSeekRequest.Message(
                role: "user",
                content: inputText
            )
            
            let response = try await networkService.sendChatMessage(
                messages: [systemMessage, userMessage],
                temperature: 0.3,
                maxTokens: 500
            )
            
            if let result = response.choices.first?.message.content {
                translatedText = result.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Save to history
                let record = TranslationRecord(
                    originalText: inputText,
                    translatedText: translatedText,
                    fromLanguage: fromLanguage,
                    toLanguage: toLanguage
                )
                dataManager.addTranslationRecord(record)
            } else {
                throw NetworkError.noData
            }
            
        } catch {
            errorMessage = "Translation failed: \(error.localizedDescription)"
            showingError = true
        }
        
        isTranslating = false
    }
    
    private func toggleRecording() {
        if isRecording {
            speechService.stopRecording()
            if !speechService.recognizedText.isEmpty {
                inputText = speechService.recognizedText
            }
            isRecording = false
        } else {
            do {
                // Choose speech recognition language based on source language
                let recognitionLanguage = getSpeechRecognitionLanguage()
                try speechService.startRecording(language: recognitionLanguage)  // Specify speech recognition language
                isRecording = true
            } catch {
                errorMessage = "Speech recognition failed to start: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    // Get speech recognition language based on source language setting
    private func getSpeechRecognitionLanguage() -> SpeechLanguage {
        switch sourceLanguage {
        case "Chinese":
            return .chinese
        case "Japanese":
            return .japanese
        case "Korean":
            return .korean
        case "French":
            return .french
        case "Spanish":
            return .spanish
        case "German":
            return .german
        default:
            return .english
        }
    }
    
    private func speakText(_ text: String, isTranslated: Bool) {
        let language: SpeechLanguage
        
        if isTranslated {
            // Language of translation result
            language = sourceLanguage == "Chinese" ? .english : .chinese
        } else {
            // Language of input text
            language = sourceLanguage == "Chinese" ? .chinese : .english
        }
        
        speechService.speak(text: text, language: language)
    }
    
    private func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        
        // If there's a translation result, swap input and output
        if !translatedText.isEmpty {
            let tempText = inputText
            inputText = translatedText
            translatedText = tempText
        }
    }
    
    private func clearInput() {
        inputText = ""
        translatedText = ""
    }
    
    private func clearAll() {
        inputText = ""
        translatedText = ""
    }
    
    private func saveTranslation() {
        guard !inputText.isEmpty && !translatedText.isEmpty else { return }
        
        // Create new phrase
        let phrase = SavedPhrase(
            english: sourceLanguage == "Chinese" ? translatedText : inputText,
            chinese: sourceLanguage == "Chinese" ? inputText : translatedText,
            category: .custom
        )
        dataManager.addPhrase(phrase)
        
        // Provide feedback
        // Can add a toast notification or other UI feedback here
        print("Phrase saved: \(phrase.english) - \(phrase.chinese)")
    }
    
    private func loadPhrase(_ phrase: SavedPhrase) {
        if sourceLanguage == "Chinese" {
            inputText = phrase.chinese
        } else {
            inputText = phrase.english
        }
        showingSavedPhrases = false
    }
    
    private func loadTranslationRecord(_ record: TranslationRecord) {
        inputText = record.originalText
        translatedText = record.translatedText
        
        // Set language direction based on record
        sourceLanguage = record.fromLanguage
        if sourceLanguage == "Chinese" && record.toLanguage != "Chinese" {
            targetLanguage = record.toLanguage
        }
    }
    
    // MARK: - Demo Translation
    private func loadDemoTranslation() {
        // Only load demo if no existing input
        if inputText.isEmpty && translatedText.isEmpty {
            inputText = "Is there a subway station nearby?"
            translatedText = "附近有地铁站吗？"
            sourceLanguage = "English"
            targetLanguage = "Chinese"
        }
    }
}

// MARK: - Supporting Views

struct SavedPhraseRow: View {
    let phrase: SavedPhrase
    let onTap: (SavedPhrase) -> Void
    
    var body: some View {
        Button(action: {
            onTap(phrase)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(phrase.english)
                        .font(.body)
                        .foregroundColor(.primary)
                    Text(phrase.chinese)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: phrase.category.icon)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TranslationHistoryCard: View {
    let record: TranslationRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("\(record.fromLanguage) → \(record.toLanguage)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(DateFormatter.shortDateTime.string(from: record.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(record.originalText)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(record.translatedText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TranslationHistoryView: View {
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.translationHistory, id: \.id) { record in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(record.fromLanguage) → \(record.toLanguage)")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text(DateFormatter.fullDateTime.string(from: record.timestamp))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(record.originalText)
                            .font(.body)
                        
                        Text(record.translatedText)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        dataManager.translationHistory.remove(at: index)
                    }
                }
            }
            .navigationTitle("Translation History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        dataManager.clearTranslationHistory()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct SavedPhrasesView: View {
    @StateObject private var dataManager = DataManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                if dataManager.savedPhrases.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark.slash")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        
                        Text("No Saved Phrases")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Click the \"Save\" button on the translation result page to save common phrases")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    ForEach(dataManager.savedPhrases, id: \.id) { phrase in
                        SavedPhraseDetailRow(phrase: phrase)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            dataManager.savedPhrases.remove(at: index)
                        }
                    }
                }
            }
            .navigationTitle("Common Phrases")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !dataManager.savedPhrases.isEmpty {
                        Button("Clear") {
                            // Clear all phrases
                            dataManager.savedPhrases.removeAll()
                        }
                        .foregroundColor(.red)
                    } else {
                        EmptyView()
                    }
                }
            }
        }
    }
}

struct SavedPhraseDetailRow: View {
    let phrase: SavedPhrase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: phrase.category.icon)
                    .foregroundColor(.blue)
                
                Text(phrase.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Spacer()
                
                Text("Save Time")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(phrase.english)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(phrase.chinese)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let shortDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    TranslatorView()
}