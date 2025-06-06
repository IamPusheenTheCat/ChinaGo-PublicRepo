//
//  SpeechLanguageSelector.swift
//  TravelAssistant
//
//  Created by Assistant on 5/15/25.
//

import SwiftUI

struct SpeechLanguageSelector: View {
    @StateObject private var speechService = SpeechService.shared
    @Binding var selectedLanguage: SpeechLanguage
    @State private var showingLanguageSheet = false
    
    var body: some View {
        Button(action: {
            showingLanguageSheet = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "globe")
                    .font(.caption)
                Text(selectedLanguage.shortName)
                    .font(.caption)
                    .fontWeight(.medium)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .foregroundColor(.blue)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .sheet(isPresented: $showingLanguageSheet) {
            NavigationView {
                List {
                    Section(header: Text("Select Speech Recognition Language")) {
                        ForEach(SpeechLanguage.allCases, id: \.self) { language in
                            LanguageRow(
                                language: language,
                                isSelected: language == selectedLanguage,
                                isAvailable: speechService.isSpeechRecognitionAvailable(for: language)
                            ) {
                                selectedLanguage = language
                                showingLanguageSheet = false
                            }
                        }
                    }
                    
                    Section(footer: Text("Choose the speech recognition language you want to use. The app will recognize voice input based on your selection.")) {
                        EmptyView()
                    }
                }
                .navigationTitle("Speech Recognition Language")
                .navigationBarItems(
                    trailing: Button("Done") {
                        showingLanguageSheet = false
                    }
                )
            }
        }
    }
}

struct LanguageRow: View {
    let language: SpeechLanguage
    let isSelected: Bool
    let isAvailable: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.displayName)
                        .font(.body)
                        .foregroundColor(isAvailable ? .primary : .secondary)
                    
                    if !isAvailable {
                        Text("This language is not available on your device")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                        .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
        }
        .disabled(!isAvailable)
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SpeechLanguageSelector(selectedLanguage: .constant(.chinese))
} 