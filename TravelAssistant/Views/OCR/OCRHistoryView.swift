//
//  OCRHistoryView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct OCRHistoryView: View {
    @StateObject private var dataManager = DataManager.shared
    @StateObject private var speechService = SpeechService.shared
    @State private var searchText = ""
    @State private var showingClearAlert = false
    
    var filteredHistory: [OCRRecord] {
        if searchText.isEmpty {
            return dataManager.ocrHistory
        } else {
            return dataManager.ocrHistory.filter { record in
                record.originalTexts.joined().lowercased().contains(searchText.lowercased()) ||
                record.translatedTexts.joined().lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if filteredHistory.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(filteredHistory, id: \.id) { record in
                            OCRHistoryRow(
                                record: record,
                                onSpeak: { text, isTranslated in
                                    speakText(text, isTranslated: isTranslated)
                                }
                            )
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                        .onDelete(perform: deleteRecords)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Recognition History")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search recognition records")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive, action: {
                            showingClearAlert = true
                        }) {
                            Label("Clear History", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Clear History", isPresented: $showingClearAlert) {
                Button("Clear", role: .destructive) {
                    dataManager.clearOCRHistory()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action will clear all OCR recognition history records and cannot be undone.")
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "text.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Recognition Records")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text("After recognizing text from photos, history will be shown here")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func deleteRecords(at offsets: IndexSet) {
        let recordsToDelete = offsets.map { filteredHistory[$0] }
        
        for record in recordsToDelete {
            if let index = dataManager.ocrHistory.firstIndex(where: { $0.id == record.id }) {
                dataManager.ocrHistory.remove(at: index)
            }
        }
        
        // Save updated history
        if let data = try? JSONEncoder().encode(dataManager.ocrHistory) {
            UserDefaults.standard.set(data, forKey: "OCRHistory")
        }
    }
    
    private func speakText(_ text: String, isTranslated: Bool) {
        let language: SpeechLanguage = isTranslated ? .english : .chinese
        speechService.speak(text: text, language: language)
    }
}

struct OCRHistoryRow: View {
    let record: OCRRecord
    let onSpeak: (String, Bool) -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header information
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(DateFormatter.fullDateTime.string(from: record.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(record.originalTexts.count) Recognition Results")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
            }
            
            // Preview first record
            if let firstOriginal = record.originalTexts.first {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Original")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button(action: {
                            onSpeak(firstOriginal, false)
                        }) {
                            Image(systemName: "speaker.wave.1")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Text(firstOriginal)
                        .font(.body)
                        .lineLimit(isExpanded ? nil : 2)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                if let firstTranslated = record.translatedTexts.first, !firstTranslated.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Translation")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button(action: {
                                onSpeak(firstTranslated, true)
                            }) {
                                Image(systemName: "speaker.wave.2")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Text(firstTranslated)
                            .font(.body)
                            .lineLimit(isExpanded ? nil : 2)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Show all records when expanded
            if isExpanded && record.originalTexts.count > 1 {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                    
                    ForEach(1..<record.originalTexts.count, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Original \(index + 1)")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Button(action: {
                                    onSpeak(record.originalTexts[index], false)
                                }) {
                                    Image(systemName: "speaker.wave.1")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Text(record.originalTexts[index])
                                .font(.body)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            if index < record.translatedTexts.count && !record.translatedTexts[index].isEmpty {
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Translation \(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            onSpeak(record.translatedTexts[index], true)
                                        }) {
                                            Image(systemName: "speaker.wave.2")
                                                .font(.caption)
                                                .foregroundColor(.green)
                                        }
                                    }
                                    
                                    Text(record.translatedTexts[index])
                                        .font(.body)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            
            // Action buttons
            HStack {
                Button(action: {
                    UIPasteboard.general.string = record.originalTexts.joined(separator: "\n")
                }) {
                    Label("Copy Original", systemImage: "doc.on.doc")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                if !record.translatedTexts.isEmpty {
                    Button(action: {
                        UIPasteboard.general.string = record.translatedTexts.joined(separator: "\n")
                    }) {
                        Label("Copy Translation", systemImage: "doc.on.doc.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

extension DateFormatter {
    static let fullDateTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

#Preview {
    OCRHistoryView()
} 