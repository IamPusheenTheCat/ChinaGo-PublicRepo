//
//  OCRView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import AVFoundation
import Photos

struct OCRView: View {
    @StateObject private var networkService = NetworkService.shared
    @StateObject private var speechService = SpeechService.shared
    @StateObject private var dataManager = DataManager.shared
    
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingPermissionAlert = false
    @State private var permissionAlertMessage = ""
    
    @State private var inputImage: UIImage?
    @State private var originalImage: UIImage?
    @State private var translatedTexts: [TranslatedTextItem] = []
    @State private var isProcessing = false
    @State private var processingMessage = "Processing..."
    
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var errorMessage: String?
    @State private var showingError = false
    
    // Settings
    @State private var useHighAccuracy = true
    @State private var autoTranslate = true
    @State private var targetLanguage = "English"
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部标题
                HStack {
                    Text("Text Recognition")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    // 三个点菜单
                    Menu {
                        Section("Recognition Settings") {
                            Button(action: {
                                useHighAccuracy.toggle()
                            }) {
                                Label(
                                    useHighAccuracy ? "High Accuracy ✓" : "Standard",
                                    systemImage: useHighAccuracy ? "checkmark.circle.fill" : "circle"
                                )
                            }
                            
                            Button(action: {
                                autoTranslate.toggle()
                            }) {
                                Label(
                                    autoTranslate ? "Auto Translate ✓" : "Manual",
                                    systemImage: autoTranslate ? "checkmark.circle.fill" : "circle"
                                )
                            }
                        }
                        
                        Section("Target Language") {
                            Button("English") { targetLanguage = "English" }
                            Button("Japanese") { targetLanguage = "Japanese" }
                            Button("Korean") { targetLanguage = "Korean" }
                            Button("French") { targetLanguage = "French" }
                        }
                        
                        Section("Other Actions") {
                            NavigationLink("View History") {
                                OCRHistoryView()
                            }
                            
                            Button("Clear Results") {
                                clearResults()
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                            .padding(.top, 10)
                            .padding(.bottom, 20)
                    }
                }
                
                ScrollView {
                VStack(spacing: 20) {
                        // 状态显示栏
                        statusSection
                    
                    // 图像显示区域
                    imageDisplaySection
                    
                    // 相机和相册按钮
                    cameraControlsSection
                    
                    // 处理进度
                    if isProcessing {
                        processingSection
                    }
                    
                    // 识别和翻译结果
                    if !translatedTexts.isEmpty {
                        resultsSection
                    }
                    
                    // 历史记录快速访问
                    if !dataManager.ocrHistory.isEmpty {
                        historySection
                    }
                }
                .padding()
            }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(
                    sourceType: sourceType,
                    image: $inputImage,
                    onImageSelected: {
                        processSelectedImage()
                    }
                )
            }
            .alert("Permission Required", isPresented: $showingPermissionAlert) {
                Button("Settings") {
                    openSettings()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(permissionAlertMessage)
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error occurred")
            }
        }
    }
    
    // MARK: - Status Section
    private var statusSection: some View {
            HStack {
                Label(
                    useHighAccuracy ? "High Accuracy" : "Standard",
                    systemImage: "text.viewfinder"
                )
                .font(.caption)
                .foregroundColor(.blue)
                
                Spacer()
                
                Label(
                    targetLanguage,
                    systemImage: "globe"
                )
                .font(.caption)
                .foregroundColor(.green)
            }
            .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Image Display Section
    private var imageDisplaySection: some View {
        ZStack {
            if let image = inputImage {
                GeometryReader { geometry in
            ZStack {
                        Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                            .cornerRadius(12)
                        
                        // 在图片上显示翻译文字（如果有位置信息）
                        ForEach(translatedTexts.filter { $0.location != nil }, id: \.id) { item in
                            if let location = item.location {
                                TranslationOverlay(
                                    item: item,
                                    imageSize: image.size,
                                    displaySize: geometry.size
                                )
                            }
                        }
                    }
                }
                .aspectRatio(inputImage?.aspectRatio ?? 1, contentMode: .fit)
                .frame(maxHeight: 300)
                } else {
                    Rectangle()
                    .fill(Color(.systemGray6))
                    .frame(height: 200)
                    .cornerRadius(12)
                        .overlay(
                        VStack(spacing: 12) {
                                Image(systemName: "text.viewfinder")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("Take a photo or select an image to recognize text")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            
                            Text("Supports multiple languages including Chinese and English")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(nil)
                            }
                            .padding(.horizontal, 20)
                        )
                }
        }
    }
    
    // MARK: - Camera Controls Section
    private var cameraControlsSection: some View {
        HStack(spacing: 30) {
            Button(action: {
                openCamera()
            }) {
                VStack(spacing: 8) {
                    Image(systemName: "camera.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Circle())
                    
                    Text("Camera")
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
            
                Button(action: {
                openPhotoLibrary()
                }) {
                VStack(spacing: 8) {
                    Image(systemName: "photo.fill")
                            .font(.title)
                            .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(
                            LinearGradient(
                                colors: [.green, .blue],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                            .clipShape(Circle())
                    
                    Text("Photos")
                            .font(.caption)
                        .fontWeight(.medium)
                    }
                }
                
            if inputImage != nil {
                Button(action: {
                    clearImage()
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: "trash.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(
                                LinearGradient(
                                    colors: [.red, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .clipShape(Circle())
                        
                        Text("Clear")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
            }
        }
    }
    
    // MARK: - Processing Section
    private var processingSection: some View {
        VStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            
            Text(processingMessage)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Results Section
    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recognition Results")
                    .font(.headline)
                    .fontWeight(.bold)
                
                    Spacer()
                
                    Button(action: {
                    saveToHistory()
                    }) {
                    Image(systemName: "bookmark.fill")
                            .foregroundColor(.blue)
                    }
            }
            
            ForEach(translatedTexts, id: \.id) { item in
                TranslationCard(
                    item: item,
                    targetLanguage: targetLanguage,
                    onSpeak: { text, isTranslated in
                        speakText(text, isTranslated: isTranslated)
                    }
                )
            }
        }
                        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // MARK: - History Section
    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
                    HStack {
                Text("Recent Recognition")
                    .font(.headline)
                    .fontWeight(.bold)
                
                        Spacer()
                
                NavigationLink("View All") {
                    OCRHistoryView()
                }
                .font(.caption)
                                .foregroundColor(.blue)
                        }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(dataManager.ocrHistory.prefix(5)), id: \.id) { record in
                        OCRHistoryCard(record: record) {
                            loadHistoryRecord(record)
                        }
                    }
                        }
                        .padding(.horizontal)
                    }
                }
    }
    
    // MARK: - Methods
    
    private func openCamera() {
        checkCameraPermission { granted in
            if granted {
                sourceType = .camera
                showingImagePicker = true
            } else {
                permissionAlertMessage = "需要相机权限来拍照识别文字。请在设置中允许访问相机。"
                showingPermissionAlert = true
            }
        }
    }
    
    private func openPhotoLibrary() {
        checkPhotoLibraryPermission { granted in
            if granted {
                sourceType = .photoLibrary
                showingImagePicker = true
            } else {
                permissionAlertMessage = "需要相册权限来选择图片。请在设置中允许访问相册。"
                showingPermissionAlert = true
            }
        }
    }
    
    private func processSelectedImage() {
        Task {
            await performOCRAndTranslation(image: inputImage!)
        }
    }
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        case .denied, .restricted:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    private func performOCRAndTranslation(image: UIImage) async {
        isProcessing = true
        processingMessage = "Recognizing text..."
        translatedTexts.removeAll()
        
        do {
            // 将图片转换为数据
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                throw OCRError.imageConversionFailed
            }
            
            // 调用百度OCR API
            let ocrResponse = try await networkService.performOCR(
                on: imageData,
                useAccurateWithLocation: useHighAccuracy
            )
            
            processingMessage = "Translating text..."
            
            // 处理识别结果
            var processedTexts: [TranslatedTextItem] = []
            
            for (index, wordResult) in ocrResponse.wordsResult.enumerated() {
                var translatedText = ""
                
                if autoTranslate {
                    // 自动翻译使用 DeepSeek
                    let systemMessage = APIConfig.DeepSeekRequest.Message(
                        role: "system",
                        content: "You are a Chinese to English translator. Translate the Chinese text to English. Only return the translation without explanation."
                    )
                    
                    let userMessage = APIConfig.DeepSeekRequest.Message(
                        role: "user",
                        content: "Translate: \(wordResult.words)"
                    )
                    
                    do {
                        let response = try await networkService.sendChatMessage(
                            messages: [systemMessage, userMessage],
                            temperature: 0.3,
                            maxTokens: 200
                        )
                        
                        if let content = response.choices.first?.message.content {
                            translatedText = content.trimmingCharacters(in: .whitespacesAndNewlines)
                        }
                    } catch {
                        print("Translation failed for text: \(wordResult.words)")
                        translatedText = "Translation failed"
                    }
                }
                
                let item = TranslatedTextItem(
                    originalText: wordResult.words,
                    translatedText: translatedText,
                    location: wordResult.location
                )
                
                processedTexts.append(item)
            }
            
            translatedTexts = processedTexts
            
        } catch {
            errorMessage = "Processing failed: \(error.localizedDescription)"
            showingError = true
        }
        
        isProcessing = false
    }

    private func clearImage() {
        inputImage = nil
        originalImage = nil
        translatedTexts.removeAll()
    }

    private func speakText(_ text: String, isTranslated: Bool) {
        let language: SpeechLanguage = isTranslated ? .english : .chinese
        speechService.speak(text: text, language: language)
    }
    
    private func saveToHistory() {
        let originalTexts = translatedTexts.map { $0.originalText }
        let translatedTexts = self.translatedTexts.map { $0.translatedText }
        
        let record = OCRRecord(
            originalTexts: originalTexts,
            translatedTexts: translatedTexts
        )
        
        dataManager.addOCRRecord(record)
    }
    
    private func loadHistoryRecord(_ record: OCRRecord) {
        // 从历史记录加载
        var items: [TranslatedTextItem] = []
        
        for i in 0..<record.originalTexts.count {
            let translatedText = i < record.translatedTexts.count ? record.translatedTexts[i] : ""
            let item = TranslatedTextItem(
                originalText: record.originalTexts[i],
                translatedText: translatedText,
                location: nil
            )
            items.append(item)
        }
        
        translatedTexts = items
    }
    
    private func clearResults() {
        translatedTexts.removeAll()
        inputImage = nil
        originalImage = nil
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Supporting Views

struct TranslatedTextItem: Identifiable {
    let id = UUID()
    let originalText: String
    let translatedText: String
    let location: APIConfig.BaiduOCRResponse.WordResult.Location?
}

struct TranslationCard: View {
    let item: TranslatedTextItem
    let targetLanguage: String
    let onSpeak: (String, Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 原文
            VStack(alignment: .leading, spacing: 4) {
                Text("Original")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(item.originalText)
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            // 译文
            if !item.translatedText.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Translation")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(item.translatedText)
                        .font(.body)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // 操作按钮
            HStack {
                Button(action: {
                    UIPasteboard.general.string = item.originalText
                }) {
                    Label("Copy Original", systemImage: "doc.on.doc")
                        .font(.caption)
                }
                
                if !item.translatedText.isEmpty {
                    Button(action: {
                        UIPasteboard.general.string = item.translatedText
                    }) {
                        Label("Copy Translation", systemImage: "doc.on.doc.fill")
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    onSpeak(item.originalText, false)
                }) {
                    Image(systemName: "speaker.wave.1")
                        .foregroundColor(.blue)
                }
                
                if !item.translatedText.isEmpty {
                    Button(action: {
                        onSpeak(item.translatedText, true)
                    }) {
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(12)
    }
}

struct TranslationOverlay: View {
    let item: TranslatedTextItem
    let imageSize: CGSize
    let displaySize: CGSize
    
    var body: some View {
        if let location = item.location,
           !item.translatedText.isEmpty {
            
            let scale = min(displaySize.width / imageSize.width, displaySize.height / imageSize.height)
            let scaledImageSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
            
            let offsetX = (displaySize.width - scaledImageSize.width) / 2
            let offsetY = (displaySize.height - scaledImageSize.height) / 2
            
            let x = CGFloat(location.left) * scale + offsetX
            let y = CGFloat(location.top) * scale + offsetY
            let width = CGFloat(location.width) * scale
            let height = CGFloat(location.height) * scale
            
            Text(item.translatedText)
                .font(.caption)
                .foregroundColor(.white)
                .padding(4)
                .background(Color.black.opacity(0.7))
                .cornerRadius(4)
                .position(x: x + width/2, y: y + height + 20)
        }
    }
}

struct OCRHistoryCard: View {
    let record: OCRRecord
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(record.originalTexts.first ?? "")
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(DateFormatter.shortDate.string(from: record.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(8)
            .frame(width: 120, height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Supporting Types

enum OCRError: Error, LocalizedError {
    case imageConversionFailed
    case noTextRecognized
    
    var errorDescription: String? {
        switch self {
        case .imageConversionFailed:
            return "图片处理失败"
        case .noTextRecognized:
            return "未识别到文字"
        }
    }
}

// MARK: - Extensions

extension UIImage {
    var aspectRatio: CGFloat {
        return size.width / size.height
    }
}

extension DateFormatter {
    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
        }

#Preview {
    OCRView()
}
