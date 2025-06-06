//
//  ChatAssistantView.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

struct ChatAssistantView: View {
    @StateObject private var networkService = NetworkService.shared
    @StateObject private var speechService = SpeechService.shared
    @StateObject private var dataManager = DataManager.shared
    
    @State private var messages: [ChatMessage] = []
    @State private var newMessage: String = ""
    @State private var isRecording: Bool = false
    @State private var showingPresetQuestions: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @State private var showingError: Bool = false
    @State private var showingSettings: Bool = false
    
    // 语音识别语言设置
    @State private var speechRecognitionLanguage: SpeechLanguage = .chinese
    
    // 流式生成相关状态
    @State private var isStreaming: Bool = false
    @State private var streamingText: String = ""
    @State private var fullResponseText: String = ""
    @State private var streamingTimer: Timer?
    @State private var currentStreamingMessageId: UUID?
    
    @FocusState private var isTextFieldFocused: Bool
    
    var presetQuestions: [PresetQuestion] {
        return dataManager.getPresetQuestions()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 顶部标题 - 使用安全区域
            HStack {
                Text("Travel Assistant")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                Spacer()
                
                // 三个点菜单
                Menu {
                    Button(action: {
                        Task {
                            await testAPIDirectly()
                        }
                    }) {
                        Label("Test API", systemImage: "antenna.radiowaves.left.and.right")
                    }
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Label("Settings", systemImage: "gearshape")
                    }
                    
                    Button(action: {
                        clearChat()
                    }) {
                        Label("Clear Chat", systemImage: "trash")
                    }
                    
                    Button(action: {
                        showChatHistory()
                    }) {
                        Label("Chat History", systemImage: "clock")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title2)
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
            }
            .background(Color(.systemBackground))
            
            // 聊天记录
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            ChatBubble(
                                message: message,
                                onSpeak: { text in
                                    speakText(text, isUser: message.isUser)
                                },
                                isStreaming: isStreaming && message.id == currentStreamingMessageId
                            )
                            .id(message.id)
                        }
                        
                        if isLoading && !isStreaming {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                Text("AI is thinking...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(16)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                    
                    // 底部空白空间，优化置顶效果
                    Spacer()
                        .frame(height: 200)
                }
                .onChange(of: messages.count) {
                    // 只有在不是初始demo对话时才自动滚动
                    if messages.count > 3, let lastMessage = messages.last {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            proxy.scrollTo(lastMessage.id, anchor: .top)
                        }
                    }
                }
            }
            
            // 预设问题区域
            if showingPresetQuestions {
                presetQuestionsSection
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 输入区域
            inputSection
        }
        .navigationBarHidden(false)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                EmptyView() // 隐藏导航栏标题，使用自定义标题
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Unknown error")
        }
        .sheet(isPresented: $showingSettings) {
            ChatSettingsView()
        }
        .onAppear {
            requestSpeechPermission()
            loadDemoConversation()
            setupNotificationObservers()
        }
        .onDisappear {
            // 清理定时器
            streamingTimer?.invalidate()
            streamingTimer = nil
            
            // 移除通知监听
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    // MARK: - Preset Questions Section
    private var presetQuestionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Common Questions")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Collapse") {
                    withAnimation(.spring()) {
                        showingPresetQuestions = false
                    }
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(presetQuestions.chunked(into: 2), id: \.first?.id) { questionPair in
                        VStack(spacing: 8) {
                            ForEach(questionPair, id: \.id) { question in
                                PresetQuestionCard(question: question) {
                                    sendMessage(question.question)
                                    withAnimation(.spring()) {
                                        showingPresetQuestions = false
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Input Section
    private var inputSection: some View {
        VStack(spacing: 12) {
            // 语音录制指示器
            if isRecording {
                VStack(spacing: 12) {
                    // 录音状态提示（保持原有设计）
                    VStack(spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .opacity(0.8)
                            
                            Text("Recording...")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                        
                        Text(speechService.recognizedText)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                    
                    // 语音识别语言选择器（仅在录音时显示）
                    if speechService.authorizationStatus == .authorized {
                        HStack(spacing: 8) {
                            Text("Recognition Language:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Menu {
                                ForEach(SpeechLanguage.allCases, id: \.self) { language in
                                    Button(action: {
                                        speechRecognitionLanguage = language
                                        // 如果正在录音，重新启动录音以应用新语言
                                        if isRecording {
                                            speechService.stopRecording()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                do {
                                                    try speechService.startRecording(language: speechRecognitionLanguage)
                                                } catch {
                                                    errorMessage = "Switch language failed: \(error.localizedDescription)"
                                                    showingError = true
                                                    isRecording = false
                                                }
                                            }
                                        }
                                    }) {
                                        HStack {
                                            Text(language.displayName)
                                            if speechRecognitionLanguage == language {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "globe")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                    Text(speechRecognitionLanguage.displayName)
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                    Image(systemName: "chevron.down")
                                        .font(.caption2)
                                        .foregroundColor(.blue)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // 输入栏
            HStack(alignment: .center, spacing: 12) {
                Button(action: {
                    withAnimation(.spring()) {
                    showingPresetQuestions.toggle()
                    }
                }) {
                    Image(systemName: showingPresetQuestions ? "chevron.down" : "text.bubble")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                        .frame(width: 44, height: 44)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                
                TextField("Enter your question...", text: $newMessage, axis: .vertical)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.systemGray4), lineWidth: 0.5)
                    )
                    .lineLimit(1...5)
                    .focused($isTextFieldFocused)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isTextFieldFocused = false
                            }
                        }
                    }
                    .onSubmit {
                        if !newMessage.isEmpty {
                            sendMessage(newMessage)
                        }
                    }
                
                Button(action: {
                    toggleRecording()
                }) {
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(isRecording ? Color.red : Color.blue)
                        .clipShape(Circle())
                }
                
                Button(action: {
                    if isStreaming || isLoading {
                        stopStreaming()
                    } else if !newMessage.isEmpty {
                        sendMessage(newMessage)
                    }
                }) {
                    Image(systemName: (isStreaming || isLoading) ? "stop.circle.fill" : "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor((isStreaming || isLoading) ? .red : (newMessage.isEmpty ? .gray : .blue))
                }
                .disabled(!(isStreaming || isLoading) && (newMessage.isEmpty || isLoading))
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .background(Color(.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                .foregroundColor(Color(.systemGray4)),
                alignment: .top
            )
        }
    
    // MARK: - Methods
    
    private func sendMessage(_ text: String) {
        let userMessage = ChatMessage(text: text, isUser: true)
        messages.append(userMessage)
        newMessage = ""
        
        // 保存到数据管理器
        let dataChatMessage = DataChatMessage(content: text, isUser: true)
        dataManager.addChatMessage(dataChatMessage)
        
        Task {
            await getAIResponse(for: text)
        }
    }
    
    @MainActor
    private func getAIResponse(for userText: String) async {
        isLoading = true
        print("🚀 开始获取AI响应: \(userText)")
        
        let systemMessage = APIConfig.DeepSeekRequest.Message(
            role: "system",
            content: "You are a friendly travel assistant specialized in helping foreigners navigate China. Provide helpful, accurate, and practical advice about travel, culture, language, and daily life in China. Always be conversational and encouraging."
        )
        
        let userMessage = APIConfig.DeepSeekRequest.Message(
            role: "user",
            content: userText
        )
        
        // 创建空的AI消息用于流式显示
        let aiMessage = ChatMessage(text: "", isUser: false)
        messages.append(aiMessage)
        currentStreamingMessageId = aiMessage.id
        
        isLoading = false
        isStreaming = true
        streamingText = ""
        
        print("📡 调用流式网络服务...")
        
        // 使用真正的流式API调用
        await networkService.sendChatMessageStreaming(
            messages: [systemMessage, userMessage],
            onChunk: { chunk in
                Task { @MainActor in
                    // 累积流式文本
                    self.streamingText += chunk
                    
                    // 更新UI中的消息
                    if let index = self.messages.firstIndex(where: { $0.id == self.currentStreamingMessageId }) {
                        self.messages[index] = ChatMessage(text: self.streamingText, isUser: false, id: self.currentStreamingMessageId!)
                    }
                }
            },
            onComplete: {
                Task { @MainActor in
                    print("✅ 流式响应完成")
                    
                    // 保存完整的AI回复到数据管理器
                    if !self.streamingText.isEmpty {
                        let dataAIMessage = DataChatMessage(content: self.streamingText, isUser: false)
                        self.dataManager.addChatMessage(dataAIMessage)
                    }
                    
                    self.finishStreaming()
                }
            },
            onError: { error in
                Task { @MainActor in
                    print("❌ 流式API调用失败: \(error)")
                    
                    // 如果流式失败，尝试使用普通API调用作为备用
                    self.isStreaming = false
                    await self.getFallbackAIResponse(for: userText)
                }
            }
        )
    }
    
    // 备用的非流式API调用
    @MainActor
    private func getFallbackAIResponse(for userText: String) async {
        print("🔄 使用备用非流式API...")
        
        let systemMessage = APIConfig.DeepSeekRequest.Message(
            role: "system",
            content: "You are a friendly travel assistant specialized in helping foreigners navigate China. Provide helpful, accurate, and practical advice about travel, culture, language, and daily life in China. Always be conversational and encouraging."
        )
        
        let userMessage = APIConfig.DeepSeekRequest.Message(
            role: "user",
            content: userText
        )
        
        do {
            print("📡 调用普通网络服务...")
            let response = try await networkService.sendChatMessage(
                messages: [systemMessage, userMessage]
            )
            
            print("✅ 收到备用API响应: \(response)")
            
            if let aiResponse = response.choices.first?.message.content {
                print("📝 备用AI响应内容: \(aiResponse)")
                
                // 如果当前有流式消息，更新它；否则创建新消息
                if let messageId = currentStreamingMessageId,
                   let index = messages.firstIndex(where: { $0.id == messageId }) {
                    messages[index] = ChatMessage(text: aiResponse, isUser: false, id: messageId)
                } else {
                    let aiMessage = ChatMessage(text: aiResponse, isUser: false)
                    messages.append(aiMessage)
                }
                
                // 保存完整的AI回复到数据管理器
                let dataAIMessage = DataChatMessage(content: aiResponse, isUser: false)
                dataManager.addChatMessage(dataAIMessage)
                
                finishStreaming()
            } else {
                print("❌ 备用API响应为空")
                errorMessage = "AI response is empty"
                showingError = true
                finishStreaming()
            }
            
        } catch {
            print("❌ 备用API调用也失败: \(error)")
            errorMessage = "Cannot get AI response: \(error.localizedDescription)"
            showingError = true
            finishStreaming()
        }
    }
    
    private func stopStreaming() {
        streamingTimer?.invalidate()
        streamingTimer = nil
        finishStreaming()
        
        // 如果正在loading，也停止loading状态
        if isLoading {
            isLoading = false
        }
    }
    
    private func finishStreaming() {
        isStreaming = false
        
        // 确保显示完整文本
        if !fullResponseText.isEmpty,
           let messageId = currentStreamingMessageId,
           let index = messages.firstIndex(where: { $0.id == messageId }) {
            messages[index] = ChatMessage(text: fullResponseText, isUser: false, id: messageId)
        }
        
        // 清理状态
        streamingText = ""
        fullResponseText = ""
        currentStreamingMessageId = nil
    }
    
    private func toggleRecording() {
        if isRecording {
            speechService.stopRecording()
            if !speechService.recognizedText.isEmpty {
                newMessage = speechService.recognizedText
            }
            isRecording = false
        } else {
            do {
                // 使用用户选择的语音识别语言，如果智能检测失败则fallback
                let preferredLanguage = speechRecognitionLanguage
                try speechService.startRecording(language: preferredLanguage)
                isRecording = true
            } catch {
                errorMessage = "Speech recognition failed: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
    
    // 获取首选的语音识别语言
    private func getPreferredSpeechLanguage() -> SpeechLanguage {
        // 检查系统语言设置
        let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        
        // 如果系统语言是中文，默认使用中文语音识别
        if systemLanguage.hasPrefix("zh") {
            return .chinese
        }
        
        // 检查用户之前的聊天记录，如果主要是中文，使用中文识别
        let recentMessages = messages.suffix(5) // 检查最近5条消息
        var chineseCount = 0
        var totalCount = 0
        
        for message in recentMessages {
            if !message.text.isEmpty {
                totalCount += 1
                let chineseCharacterSet = CharacterSet(charactersIn: "\u{4e00}-\u{9fff}")
                let hasChineseCharacters = message.text.unicodeScalars.contains { chineseCharacterSet.contains($0) }
                if hasChineseCharacters {
                    chineseCount += 1
                }
            }
        }
        
        // 如果最近的消息中有超过50%是中文，使用中文识别
        if totalCount > 0 && Double(chineseCount) / Double(totalCount) > 0.5 {
            return .chinese
        }
        
        // 默认使用中文，因为这是中国旅行助手
        return .chinese
    }
    
    private func speakText(_ text: String, isUser: Bool) {
        let language: SpeechLanguage = detectLanguage(text)
        speechService.speak(text: text, language: language)
    }
    
    private func detectLanguage(_ text: String) -> SpeechLanguage {
        // 简单的语言检测逻辑
        let chineseCharacterSet = CharacterSet(charactersIn: "\u{4e00}-\u{9fff}")
        let hasChineseCharacters = text.unicodeScalars.contains { chineseCharacterSet.contains($0) }
        return hasChineseCharacters ? .chinese : .english
    }
    
    // 直接添加AI消息（来自精确导航功能）
    private func addAIMessage(_ text: String) {
        let newAIMessage = ChatMessage(text: text, isUser: false)
        messages.append(newAIMessage)
        
        // 保存到持久存储
        let dataAIMessage = DataChatMessage(content: text, isUser: false)
        dataManager.addChatMessage(dataAIMessage)
    }
    
    private func clearChat() {
        messages.removeAll()
        dataManager.clearChatHistory()
    }
    
    private func showChatHistory() {
        // TODO: 实现历史记录视图
    }
    
    private func requestSpeechPermission() {
        speechService.requestPermission()
    }
    
    // MARK: - Demo Conversation
    private func loadDemoConversation() {
        // Only load demo if no existing messages
        guard messages.isEmpty else { return }
        
        let demoMessages: [ChatMessage] = [
            ChatMessage(text: "Hello! I'm your Chinese travel assistant. How can I help you?", isUser: false),
            ChatMessage(text: "How to use China's mobile payment?", isUser: true),
            ChatMessage(text: """
In China, there are two main mobile payment methods: WeChat Pay and Alipay. As a foreign visitor, you can:

**1. WeChat Pay:** Download the WeChat App, register an account, and bind an international credit card.

**2. Alipay:** Download the Alipay App, use the "Tourist Version" feature, and directly bind Visa, Mastercard, etc.

Do you need a detailed registration guide?
""", isUser: false)
        ]
        
        messages = demoMessages
    }
    
    private func setupNotificationObservers() {
        // 监听从精确导航传来的用户消息
        NotificationCenter.default.addObserver(
            forName: Notification.Name("AddMessageToChatAssistant"),
            object: nil,
            queue: .main
        ) { notification in
            if let message = notification.object as? String {
                // 自动发送这条消息（作为用户消息）
                sendMessage(message)
            }
        }
        
        // 监听从精确导航传来的AI消息
        NotificationCenter.default.addObserver(
            forName: Notification.Name("AddAIMessageToChatAssistant"),
            object: nil,
            queue: .main
        ) { notification in
            if let message = notification.object as? String {
                // 直接添加AI消息，不调用API
                addAIMessage(message)
            }
        }
    }
    
    // MARK: - API Testing
    @MainActor
    private func testAPIDirectly() async {
        print("🧪 开始直接测试API...")
        
        let testMessage = APIConfig.DeepSeekRequest.Message(role: "user", content: "Hello")
        
        do {
            let response = try await networkService.sendChatMessage(messages: [testMessage])
            print("✅ API测试成功: \(response)")
            
            // 显示测试结果
            if let content = response.choices.first?.message.content {
                let testResult = "API Test Success: \(content)"
                let aiMessage = ChatMessage(text: testResult, isUser: false)
                messages.append(aiMessage)
            }
        } catch {
            print("❌ API测试失败: \(error)")
            errorMessage = "API Test Failed: \(error.localizedDescription)"
            showingError = true
        }
    }
}

// MARK: - Supporting Views

struct ChatBubble: View {
    let message: ChatMessage
    let onSpeak: (String) -> Void
    let isStreaming: Bool
    
    init(message: ChatMessage, onSpeak: @escaping (String) -> Void, isStreaming: Bool = false) {
        self.message = message
        self.onSpeak = onSpeak
        self.isStreaming = isStreaming
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser {
                Spacer(minLength: 30)  // 减少左侧间距，与AI气泡保持平衡
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    HStack(spacing: 8) {
                        Button(action: {
                            UIPasteboard.general.string = message.text
                        }) {
                            Image(systemName: "doc.on.doc")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            onSpeak(message.text)
                        }) {
                            Image(systemName: "speaker.wave.1")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(DateFormatter.timeOnly.string(from: message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
            } else {
                VStack(alignment: .leading, spacing: 2) {
                    // AI回复使用气泡样式
                    VStack(alignment: .leading, spacing: 0) {
                        if isStreaming && !message.text.isEmpty {
                            // 流式生成时的渐变效果
                            StreamingTextView(text: message.text)
                                .padding(.horizontal, 20)  // 增加水平边距
                                .padding(.vertical, 16)    // 增加垂直边距
                        } else {
                            // 完成的回复使用格式化文本渲染
                    FormattedTextView(text: message.text)
                                .padding(.horizontal, 20)  // 增加水平边距
                                .padding(.vertical, 16)    // 增加垂直边距
                        }
                    }
                        .background(Color(.systemGray6))
                        .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                    .padding(.trailing, 30)  // 减少右侧间距，让AI气泡更宽
                    
                    HStack(spacing: 8) {
                        Text(DateFormatter.timeOnly.string(from: message.timestamp))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            onSpeak(message.text)
                        }) {
                            Image(systemName: "speaker.wave.2")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            UIPasteboard.general.string = message.text
                        }) {
                            Image(systemName: "doc.on.doc")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer(minLength: 30)  // 与用户消息保持平衡的右侧空白
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

// MARK: - Streaming Text View with Gradient
struct StreamingTextView: View {
    let text: String
    private let fadeCharacterCount = 5 // 最后5个字符渐变
    
    var body: some View {
        Text(createStreamingText())
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // 流式显示时只显示纯文本和渐变效果，不应用复杂格式化
    private func createStreamingText() -> AttributedString {
        var attributedString = AttributedString(text)
        
        // 确保文本不为空
        guard !text.isEmpty else { return attributedString }
        
        // 应用渐变效果到最后几个字符
        let textLength = text.count
        
        if textLength <= fadeCharacterCount {
            // 文本太短，对整个文本应用轻微渐变
            if let range = attributedString.range(of: text) {
                attributedString[range].foregroundColor = .primary.opacity(0.7)
            }
        } else {
            // 对最后几个字符应用渐变
            let fadeText = String(text.suffix(fadeCharacterCount))
            
            if let lastRange = text.range(of: fadeText, options: .backwards) {
                let startIndex = text.distance(from: text.startIndex, to: lastRange.lowerBound)
                let endIndex = text.distance(from: text.startIndex, to: lastRange.upperBound)
                
                let attributedText = String(attributedString.characters)
                if let attrStartIndex = attributedText.index(attributedText.startIndex, offsetBy: startIndex, limitedBy: attributedText.endIndex),
                   let attrEndIndex = attributedText.index(attributedText.startIndex, offsetBy: endIndex, limitedBy: attributedText.endIndex) {
                    
                    let attrRange = attrStartIndex..<attrEndIndex
                    if Range(attrRange, in: attributedString) != nil {
                        // 应用渐变效果到最后几个字符
                        for (index, _) in fadeText.enumerated() {
                            let charStartIndex = attributedText.index(attrStartIndex, offsetBy: index)
                            let charEndIndex = attributedText.index(charStartIndex, offsetBy: 1)
                            let charRange = charStartIndex..<charEndIndex
                            
                            if let charAttributedRange = Range(charRange, in: attributedString) {
                                let progress = Double(index) / Double(fadeCharacterCount - 1)
                                let opacity = 1.0 - (progress * 0.6) // 从1.0渐变到0.4
                                attributedString[charAttributedRange].foregroundColor = .primary.opacity(opacity)
            }
        }
                    }
                }
            }
        }
        
        return attributedString
    }
}

// MARK: - Formatted Text View
struct FormattedTextView: View {
    let text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(parseTextBlocks(text), id: \.id) { block in
                renderTextBlock(block)
            }
        }
    }
    
    @ViewBuilder
    private func renderTextBlock(_ block: TextBlock) -> some View {
        switch block.type {
        case .header1:
            Text(renderInlineFormatting(block.content))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.vertical, 6)
        
        case .header2:
            Text(renderInlineFormatting(block.content))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .padding(.vertical, 4)
        
        case .header3:
            Text(renderInlineFormatting(block.content))
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .padding(.vertical, 2)
        
        case .codeBlock:
            VStack(alignment: .leading, spacing: 0) {
                Text(block.content)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
            .padding(.vertical, 2)
        
        case .listItem:
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(.body)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                
                Text(renderInlineFormatting(block.content))
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.leading, 8)
        
        case .numberedListItem:
            HStack(alignment: .top, spacing: 8) {
                Text("\(block.listNumber ?? 1).")
                    .font(.body)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
                    .frame(minWidth: 20, alignment: .leading)
                
                Text(renderInlineFormatting(block.content))
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.leading, 8)
        
        case .bold:
            Text(renderInlineFormatting(block.content))
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        
        case .emphasis:
            Text(renderInlineFormatting(block.content))
                .font(.body)
                .italic()
                .foregroundColor(.primary)
        
        case .inlineCode:
            Text(block.content)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.blue)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color(.systemGray5))
                .cornerRadius(4)
        
        case .paragraph:
            Text(renderInlineFormatting(block.content))
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 2)
        
        case .quote:
            HStack(alignment: .top, spacing: 12) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 3)
                
                Text(renderInlineFormatting(block.content))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .italic()
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    private func renderInlineFormatting(_ text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        
        // 处理粗体 **text**
        let boldPattern = #"\*\*(.*?)\*\*"#
        if let boldRegex = try? NSRegularExpression(pattern: boldPattern) {
            let matches = boldRegex.matches(in: text, range: NSRange(text.startIndex..., in: text))
            
            // 从后往前处理，避免位置偏移问题
            for match in matches.reversed() {
                guard let swiftRange = Range(match.range, in: text) else { continue }
                let matchedText = String(text[swiftRange])
                let contentText = String(matchedText.dropFirst(2).dropLast(2))
                
                // 在AttributedString中找到对应的位置
                let attributedText = String(attributedString.characters)
                guard let attrRange = attributedText.range(of: matchedText) else { continue }
                guard let attrStringRange = Range(attrRange, in: attributedString) else { continue }
                
                // 替换文本并设置粗体
                var newContent = AttributedString(contentText)
                newContent.font = .body.weight(.bold)
                attributedString.replaceSubrange(attrStringRange, with: newContent)
            }
        }
        
        // 处理斜体 *text* (避免与粗体冲突)
        let italicPattern = #"(?<!\*)\*([^*]+)\*(?!\*)"#
        if let italicRegex = try? NSRegularExpression(pattern: italicPattern) {
            let currentText = String(attributedString.characters)
            let matches = italicRegex.matches(in: currentText, range: NSRange(currentText.startIndex..., in: currentText))
            
            for match in matches.reversed() {
                guard let swiftRange = Range(match.range, in: currentText) else { continue }
                let matchedText = String(currentText[swiftRange])
                let contentText = String(matchedText.dropFirst().dropLast())
                
                guard let attrRange = currentText.range(of: matchedText) else { continue }
                guard let attrStringRange = Range(attrRange, in: attributedString) else { continue }
                
                var newContent = AttributedString(contentText)
                newContent.font = .body.italic()
                attributedString.replaceSubrange(attrStringRange, with: newContent)
            }
        }
        
        // 处理行内代码 `code`
        let codePattern = #"`([^`]+)`"#
        if let codeRegex = try? NSRegularExpression(pattern: codePattern) {
            let currentText = String(attributedString.characters)
            let matches = codeRegex.matches(in: currentText, range: NSRange(currentText.startIndex..., in: currentText))
            
            for match in matches.reversed() {
                guard let swiftRange = Range(match.range, in: currentText) else { continue }
                let matchedText = String(currentText[swiftRange])
                let contentText = String(matchedText.dropFirst().dropLast())
                
                guard let attrRange = currentText.range(of: matchedText) else { continue }
                guard let attrStringRange = Range(attrRange, in: attributedString) else { continue }
                
                var newContent = AttributedString(contentText)
                newContent.font = .system(.body, design: .monospaced)
                newContent.foregroundColor = .blue
                newContent.backgroundColor = Color(.systemGray5)
                attributedString.replaceSubrange(attrStringRange, with: newContent)
            }
        }
        
        return attributedString
    }
    
    private func parseTextBlocks(_ text: String) -> [TextBlock] {
        let lines = text.components(separatedBy: .newlines)
        var blocks: [TextBlock] = []
        var currentCodeBlock: [String] = []
        var inCodeBlock = false
        var listNumber = 1
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespaces)
            
            // 处理代码块
            if trimmedLine.hasPrefix("```") {
                if inCodeBlock {
                    // 结束代码块
                    if !currentCodeBlock.isEmpty {
                        blocks.append(TextBlock(
                            type: .codeBlock,
                            content: currentCodeBlock.joined(separator: "\n")
                        ))
                        currentCodeBlock.removeAll()
                    }
                    inCodeBlock = false
                } else {
                    // 开始代码块
                    inCodeBlock = true
                }
                continue
            }
            
            if inCodeBlock {
                currentCodeBlock.append(line)
                continue
            }
            
            // 空行处理
            if trimmedLine.isEmpty {
                continue
            }
            
            // 标题处理
            if trimmedLine.hasPrefix("###") {
                blocks.append(TextBlock(
                    type: .header3,
                    content: String(trimmedLine.dropFirst(3)).trimmingCharacters(in: .whitespaces)
                ))
                listNumber = 1
            } else if trimmedLine.hasPrefix("##") {
                blocks.append(TextBlock(
                    type: .header2,
                    content: String(trimmedLine.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                ))
                listNumber = 1
            } else if trimmedLine.hasPrefix("#") {
                blocks.append(TextBlock(
                    type: .header1,
                    content: String(trimmedLine.dropFirst(1)).trimmingCharacters(in: .whitespaces)
                ))
                listNumber = 1
            }
            // 引用处理
            else if trimmedLine.hasPrefix(">") {
                blocks.append(TextBlock(
                    type: .quote,
                    content: String(trimmedLine.dropFirst(1)).trimmingCharacters(in: .whitespaces)
                ))
            }
            // 无序列表处理 - 更精确的匹配
            else if (trimmedLine.hasPrefix("- ") || 
                     trimmedLine.hasPrefix("* ") || 
                     trimmedLine.hasPrefix("• ")) &&
                     trimmedLine.count > 2 {
                blocks.append(TextBlock(
                    type: .listItem,
                    content: String(trimmedLine.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                ))
                listNumber = 1
            }
            // 有序列表处理
            else if let range = trimmedLine.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                let content = String(trimmedLine[range.upperBound...])
                blocks.append(TextBlock(
                    type: .numberedListItem,
                    content: content,
                    listNumber: listNumber
                ))
                listNumber += 1
            }
            // 普通段落
            else {
                blocks.append(TextBlock(
                    type: .paragraph,
                    content: trimmedLine
                ))
                listNumber = 1
            }
        }
        
        // 处理未完成的代码块
        if inCodeBlock && !currentCodeBlock.isEmpty {
            blocks.append(TextBlock(
                type: .codeBlock,
                content: currentCodeBlock.joined(separator: "\n")
            ))
        }
        
        return blocks
    }
}

// MARK: - Text Block Data Models
struct TextBlock: Identifiable {
    let id = UUID()
    let type: TextBlockType
    let content: String
    let listNumber: Int?
    
    init(type: TextBlockType, content: String, listNumber: Int? = nil) {
        self.type = type
        self.content = content
        self.listNumber = listNumber
    }
}

enum TextBlockType {
    case header1, header2, header3
    case paragraph
    case listItem, numberedListItem
    case codeBlock, inlineCode
    case bold, emphasis
    case quote
}

struct PresetQuestionCard: View {
    let question: PresetQuestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 8) {
                Image(systemName: question.icon)
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                    .frame(width: 20)
                
                Text(question.question)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChatSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section("Voice Settings") {
                    Text("Voice Recognition Language")
                    Text("Voice Synthesis Settings")
                }
                
                Section("Chat Settings") {
                    Text("AI Response Style")
                    Text("Auto Save Chat")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Extensions

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension DateFormatter {
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}

// 聊天消息数据模型
struct ChatMessage: Identifiable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
    
    init(text: String, isUser: Bool, id: UUID = UUID(), timestamp: Date = Date()) {
        self.id = id
        self.text = text
        self.isUser = isUser
        self.timestamp = timestamp
    }
}

#Preview {
        ChatAssistantView()
}