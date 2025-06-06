//
//  APIKeySetupView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct APIKeySetupView: View {
    @State private var deepSeekAPIKey = ""
    @State private var baiduAPIKey = ""
    @State private var baiduSecretKey = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    @State private var keysSaved = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("To use the full functionality of Travel Assistant, please configure the following API keys. These keys will be securely stored in your device's Keychain.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } header: {
                    Text("API Key Configuration")
                }
                
                Section {
                    SecureField("Enter DeepSeek API Key", text: $deepSeekAPIKey)
                        .textContentType(.password)
                    
                    Text("Used for AI chat and translation features")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } header: {
                    Text("DeepSeek API")
                }
                
                Section {
                    SecureField("Enter Baidu API Key", text: $baiduAPIKey)
                        .textContentType(.password)
                    
                    SecureField("Enter Baidu Secret Key", text: $baiduSecretKey)
                        .textContentType(.password)
                    
                    Text("Used for OCR text recognition feature")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } header: {
                    Text("Baidu OCR API")
                }
                
                Section {
                    Button(action: saveAPIKeys) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text(keysSaved ? "Keys Saved" : "Save Keys")
                        }
                    }
                    .disabled(isLoading || !allFieldsFilled)
                    
                    if keysSaved {
                        Button("Test API Connection") {
                            testAPIConnections()
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Button("Skip Configuration") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                } footer: {
                    Text("You can configure these API keys later in settings. The app will prioritize using the Supabase server-side API.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("API Key Setup")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("API Key Setup", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
        .onAppear {
            loadExistingKeys()
        }
    }
    
    private var allFieldsFilled: Bool {
        !deepSeekAPIKey.isEmpty && !baiduAPIKey.isEmpty && !baiduSecretKey.isEmpty
    }
    
    private func loadExistingKeys() {
        // Check for existing saved keys
        if let existingDeepSeek = APIConfig.SecureKeys.getDeepSeekAPIKey() {
            deepSeekAPIKey = String(existingDeepSeek.prefix(8)) + "..." // Only show first few characters
        }
        
        if let existingBaiduAPI = APIConfig.SecureKeys.getBaiduAPIKey() {
            baiduAPIKey = String(existingBaiduAPI.prefix(8)) + "..."
        }
        
        if let existingBaiduSecret = APIConfig.SecureKeys.getBaiduSecretKey() {
            baiduSecretKey = String(existingBaiduSecret.prefix(8)) + "..."
        }
        
        keysSaved = APIConfig.SecureKeys.areAllKeysConfigured()
    }
    
    private func saveAPIKeys() {
        isLoading = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            var success = true
            var errors: [String] = []
            
            // Only save when input is not empty and not masked value
            if !deepSeekAPIKey.isEmpty && !deepSeekAPIKey.contains("...") {
                if !APIConfig.SecureKeys.setDeepSeekAPIKey(deepSeekAPIKey) {
                    success = false
                    errors.append("Failed to save DeepSeek API key")
                }
            }
            
            if !baiduAPIKey.isEmpty && !baiduAPIKey.contains("...") {
                if !APIConfig.SecureKeys.setBaiduAPIKey(baiduAPIKey) {
                    success = false
                    errors.append("Failed to save Baidu API key")
                }
            }
            
            if !baiduSecretKey.isEmpty && !baiduSecretKey.contains("...") {
                if !APIConfig.SecureKeys.setBaiduSecretKey(baiduSecretKey) {
                    success = false
                    errors.append("Failed to save Baidu Secret key")
                }
            }
            
            DispatchQueue.main.async {
                isLoading = false
                
                if success {
                    keysSaved = true
                    alertMessage = "API keys have been securely saved to Keychain"
                    
                    // Clear input fields
                    deepSeekAPIKey = ""
                    baiduAPIKey = ""
                    baiduSecretKey = ""
                } else {
                    alertMessage = "Save failed: \(errors.joined(separator: ", "))"
                }
                
                showingAlert = true
            }
        }
    }
    
    private func testAPIConnections() {
        isLoading = true
        
        Task {
            let results = await NetworkService.shared.testAllAPIs()
            
            DispatchQueue.main.async {
                isLoading = false
                
                var resultMessages: [String] = []
                
                if results.deepSeek {
                    resultMessages.append("✅ DeepSeek API: Connection successful")
                } else {
                    resultMessages.append("❌ DeepSeek API: Connection failed")
                }
                
                if results.baiduOCR {
                    resultMessages.append("✅ Baidu OCR API: Connection successful")
                } else {
                    resultMessages.append("❌ Baidu OCR API: Connection failed")
                }
                
                if results.maps {
                    resultMessages.append("✅ Map Search: Connection successful")
                } else {
                    resultMessages.append("❌ Map Search: Connection failed")
                }
                
                alertMessage = resultMessages.joined(separator: "\n")
                showingAlert = true
            }
        }
    }
}

#Preview {
    APIKeySetupView()
}