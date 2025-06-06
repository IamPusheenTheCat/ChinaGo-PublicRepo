//
//  DestinationSelectionGuideView.swift
//  TravelAssistant
//
//  Created by taoranmr on 6/2/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct DestinationSelectionGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var networkService = NetworkService.shared
    @StateObject private var locationManager = LocationManager()
    
    @State private var startPoint = ""
    @State private var endPoint = ""
    @State private var isLoading = false
    @State private var analysisResult: NavigationAnalysis?
    @State private var showAnalysis = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showCopySuccess = false
    @State private var userLocationInfo = ""
    @State private var showRecommendationPicker = false
    
    @FocusState private var isStartPointFocused: Bool
    @FocusState private var isEndPointFocused: Bool
    
    // 添加缓存相关状态
    @State private var analysisCache: [String: NavigationAnalysis] = [:]
    
    // 持久化存储的键
    private static let analysisResultsKey = "DestinationAnalysisResults"
    
    private var cacheKey: String {
        return "\(startPoint.isEmpty ? "current" : startPoint)-\(endPoint)"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 顶部标题卡片
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "location.magnifyingglass")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    Text("Precise Navigation")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                                Text("AI Smart Address Verification & Route Planning")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        
                        // 功能说明卡片
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(.blue)
                                Text("Feature Description")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                PreciseNavFeatureRow(icon: "checkmark.circle", text: "AI Smart Address Verification for China")
                                PreciseNavFeatureRow(icon: "arrow.triangle.branch", text: "Identify Multiple Campuses/Entrances")
                                PreciseNavFeatureRow(icon: "info.bubble", text: "Detailed Destination Purpose Description")
                                PreciseNavFeatureRow(icon: "car.2", text: "China Transportation Method Recommendations")
                                PreciseNavFeatureRow(icon: "globe.asia.australia", text: "English to Chinese Address Conversion")
                                PreciseNavFeatureRow(icon: "location.circle", text: "Support Current Location Auto-Detection")
                            }
                        }
                        .padding()
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
                    
                    // 输入卡片
                    VStack(spacing: 20) {
                        // 起点输入
                        InputCard(
                            title: "Starting Point",
                            icon: "location.circle.fill",
                            iconColor: .green,
                            placeholder: "Enter starting point in China (leave empty to use current location)",
                            text: $startPoint,
                            focused: $isStartPointFocused
                        )
                        
                        // 终点输入
                        InputCard(
                            title: "Destination",
                            icon: "mappin.and.ellipse",
                            iconColor: .red,
                            placeholder: "Enter destination in China (attractions/restaurants/malls etc.)",
                            text: $endPoint,
                            focused: $isEndPointFocused
                        )
                        
                        // 查询按钮
                        Button(action: analyzeNavigation) {
                            HStack(spacing: 12) {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.9)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "brain.head.profile")
                                        .font(.title3)
                                }
                                
                                VStack(spacing: 2) {
                                    Text(isLoading ? "AI Analysis in Progress..." : "Start AI Analysis")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    if !isLoading {
                                        Text("Verify Address·Recommend Routes·Transport Advice")
                                            .font(.caption)
                                            .opacity(0.9)
                                    }
                                }
                                
                                if !isLoading {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.title3)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: endPoint.isEmpty ? 
                                        [.gray.opacity(0.6), .gray] : 
                                        [.blue, .purple, .pink]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: endPoint.isEmpty ? .clear : .blue.opacity(0.3), 
                                   radius: 8, x: 0, y: 4)
                        }
                        .disabled(endPoint.isEmpty || isLoading)
                        .animation(.easeInOut(duration: 0.2), value: endPoint.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    // AI分析结果
                    if showAnalysis, let analysis = analysisResult {
                        analysisResultView(analysis)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Precise Navigation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isStartPointFocused = false
                        isEndPointFocused = false
                    }
                }
            }
            .alert("Analysis Failed", isPresented: $showError) {
                Button("Retry") { 
                    if !endPoint.isEmpty {
                        analyzeNavigation()
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .overlay(
                // 复制成功提示
                Group {
                    if showCopySuccess {
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Copied to clipboard")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                            .padding(.bottom, 100)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
            .onAppear {
                requestLocationPermission()
                
                // 尝试恢复最近的分析结果
                restoreLastAnalysisResult()
            }
        }
        .actionSheet(isPresented: $showRecommendationPicker) {
            guard let analysis = analysisResult,
                  !analysis.alternativeSuggestions.isEmpty else {
                return ActionSheet(title: Text("No Recommendations"))
            }
            
            var buttons: [ActionSheet.Button] = analysis.alternativeSuggestions.enumerated().map { index, suggestion in
                .default(Text("\(index + 1). \(suggestion)")) {
                    useRecommendation(suggestion)
                }
            }
            buttons.append(.cancel())
            
            return ActionSheet(
                title: Text("Select Recommended Location"),
                message: Text("Please select a recommended location to re-analyze"),
                buttons: buttons
            )
        }
    }
    
    // MARK: - AI分析结果视图
    @ViewBuilder
    private func analysisResultView(_ analysis: NavigationAnalysis) -> some View {
        VStack(spacing: 16) {
            // 结果标题
            HStack {
                Image(systemName: "brain.filled.head.profile")
                    .foregroundColor(.blue)
                Text("AI Analysis Result")
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(analysis.isValid ? .green : .orange)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            
            // 地点信息卡片
            ResultCard(
                title: "📍 Location Confirmation",
                icon: "location.fill",
                iconColor: .blue
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    LocationRow(label: "Start", original: startPoint.isEmpty ? "Current Location" : startPoint, formatted: analysis.formattedStart)
                    LocationRow(label: "End", original: endPoint, formatted: analysis.formattedEnd)
                    
                    if !analysis.destinationPurpose.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🎯 Destination Purpose")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.purple)
                            Text(analysis.destinationPurpose)
                                .font(.body)
                                .padding(.top, 2)
                        }
                        .padding(.top, 8)
                    }
                }
            }
            
            // 验证状态
            if !analysis.isValid {
                ResultCard(
                    title: "Address Reminder",
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .orange
                ) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(analysis.validityReason)
                            .font(.body)
                        
                        if !analysis.alternativeSuggestions.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recommendations")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.purple)
                                
                                ForEach(Array(analysis.alternativeSuggestions.enumerated()), id: \.offset) { index, suggestion in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\(index + 1).")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.purple)
                                            .frame(width: 20, alignment: .leading)
                                        Text(suggestion)
                                            .font(.body)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // 多选项提醒
            if !analysis.multipleOptions.isEmpty {
                ResultCard(
                    title: "Multiple Options",
                    icon: "arrow.triangle.branch",
                    iconColor: .indigo
                ) {
                    Text(analysis.multipleOptions)
                        .font(.body)
                }
            }
            
            // 交通建议
            if !analysis.transportAdvice.isEmpty {
                ResultCard(
                    title: "🚗 Transport Advice",
                    icon: "car.2.fill",
                    iconColor: .green
                ) {
                    Text(analysis.transportAdvice)
                        .font(.body)
                }
            }
            
            // 特别注意事项
            if !analysis.specialNotes.isEmpty {
                ResultCard(
                    title: "⚡ Special Notes",
                    icon: "exclamationmark.triangle.fill",
                    iconColor: .red
                ) {
                    Text(analysis.specialNotes)
                        .font(.body)
                }
            }
            
            // 功能按钮组
            VStack(spacing: 16) {
                // 第一行按钮
                HStack(spacing: 12) {
                    EnhancedActionButton(
                        title: "Copy Location Info",
                        icon: "doc.on.doc.fill",
                        gradient: [.orange, .red],
                        action: copyLocationInfo
                    )
                    
                    EnhancedActionButton(
                        title: "Use Recommendation",
                        icon: "arrow.triangle.2.circlepath",
                        gradient: analysis.alternativeSuggestions.isEmpty ? [.gray, .gray] : [.purple, .pink],
                        action: { showRecommendationPicker = true },
                        disabled: analysis.alternativeSuggestions.isEmpty
                    )
                }
                
                // 第二行按钮
                HStack(spacing: 12) {
                    EnhancedActionButton(
                        title: "Start Navigation",
                        icon: "location.fill",
                        gradient: analysis.isValid ? [.red, .pink] : [.gray, .gray],
                        action: startNavigation,
                        disabled: !analysis.isValid
                    )
                    
                    EnhancedActionButton(
                        title: "Send to Chat",
                        icon: "message.circle.fill",
                        gradient: [.green, .teal],
                        action: copyToChatAssistant
                    )
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
    }
    
    // MARK: - 功能函数
    
    private func requestLocationPermission() {
        locationManager.requestLocationPermission()
    }
    
    private func getCurrentLocationInfo() async -> String {
        guard let location = locationManager.location else {
            return "中国"
        }
        
        // 使用反向地理编码获取地址信息
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                let city = placemark.locality ?? placemark.administrativeArea ?? "未知城市"
                let district = placemark.subLocality ?? placemark.subAdministrativeArea ?? ""
                let street = placemark.thoroughfare ?? ""
                let landmark = placemark.name ?? ""
                
                var locationInfo = city
                if !district.isEmpty {
                    locationInfo += district
                }
                if !street.isEmpty && street != landmark {
                    locationInfo += street
                }
                if !landmark.isEmpty {
                    locationInfo += "Near"
                }
                
                return locationInfo
            }
        } catch {
            print("Reverse geocoding failed: \(error)")
        }
        
        return "Current Location"
    }
    
    private func analyzeNavigation() {
        guard !endPoint.isEmpty else { return }
        
        // 检查持久化缓存
        let currentCacheKey = cacheKey
        if let cachedResult = loadAnalysisFromStorage(key: currentCacheKey) {
            print("Using cached analysis result")
            self.analysisResult = cachedResult
            self.showAnalysis = true
            return
        }
        
        isLoading = true
        showAnalysis = false
        
        Task {
            // 如果没有输入起点，获取当前位置信息
            let currentLocationInfo = startPoint.isEmpty ? await getCurrentLocationInfo() : startPoint
            
            // 更清晰的prompt，强调只返回JSON
            let prompt = """
            You are a professional China navigation analysis AI for American travelers. I need you to analyze the following navigation request. Please respond strictly according to requirements:
            
            Starting Point: \(currentLocationInfo)
            Destination: \(endPoint)
            
            **IMPORTANT REQUIREMENTS:**
            1. Your response must contain only one complete JSON object, no additional explanatory text
            2. Do not add any text outside the JSON, including phrases like "Based on your request", "Analysis as follows", etc.
            3. All analysis content should be written in JSON field values, you can use line breaks and detailed descriptions
            4. Ensure JSON format is completely correct, all strings must be surrounded by double quotes
            5. Generate content in ENGLISH for American travelers, but provide Chinese characters for place names when needed for navigation apps
            
            **Recommendation Rules (VERY IMPORTANT):**
            - If user inputs a university name (like "Nanjing University"), recommendations must be different campuses of that same university (like "Nanjing University Xianlin Campus", "Nanjing University Gulou Campus")
            - If user inputs a mall/store, recommendations must be different branches of that same brand (like "Starbucks XX Store", "Starbucks YY Store")
            - If user inputs a tourist attraction, recommendations must be different entrances or related areas of that same attraction
            - NEVER recommend completely different locations!!!
            - If there really are no multiple options, the alternative_suggestions array can be empty
            
            Please analyze the following content and put it in JSON:
            
            Address Verification: Verify if the address is valid. If invalid, provide different options for the same location in alternative_suggestions
            
            Destination Purpose: Explain in detail what this destination is, what functions it has, to help users confirm if they're going to the right place. For example, explain if "紫峰大厦" is for sightseeing/shopping or for "某某 store", etc.
            
            Multiple Location Options: Check if there are same-name different locations, such as different campuses of universities, different branches of malls, etc. Important: Must be different locations of the same institution/brand!
            
            Address Format Conversion: Provide "English name -> 中文名称" format conversion. This is CRUCIAL - provide Chinese characters for place names so American travelers can copy them into Chinese navigation apps like Baidu Maps or Amap.
            
            Transportation Advice: Recommend the best transportation method based on distance and traffic conditions, including estimated time and cost
            
            Special Notes: Important information such as business hours, parking info, restricted zones, ticket prices, etc.
            
            JSON Format (Please follow strictly, do not modify structure):
            {
                "validity_check": {
                    "is_valid": true,
                    "reason": "Address verification result explanation in English",
                    "formatted_start": "中文名称",
                    "formatted_end": "中文名称"
                },
                "destination_purpose": "Detailed explanation of the destination's function and purpose in English to help users confirm the location",
                "multiple_options": "If there are multiple same-name locations, detailed explanation of differences and selection advice in English",
                "address_format_conversion": "IMPORTANT: Provide 'English Name -> 中文名称' format conversion with Chinese characters for navigation apps. If no conversion needed, leave empty string",
                "alternative_suggestions": ["Same location different campus/branch1 with Chinese: English Name -> 中文名称", "Same location different campus/branch2 with Chinese: English Name -> 中文名称", "Same location different campus/branch3 with Chinese: English Name -> 中文名称"],
                "transport_advice": "Detailed transportation advice in English including methods, time, cost information",
                "special_notes": "Important notes in English including business hours, parking, restricted zones and other specific information"
            }
            """
            
            do {
                let messages: [APIConfig.DeepSeekRequest.Message] = [
                    APIConfig.DeepSeekRequest.Message(
                        role: "system",
                        content: "You are a professional China navigation analysis AI for American travelers. Please respond strictly according to user requirements, returning only standard JSON format without any explanatory text. Ensure JSON format is completely correct. Recommendation options must be different campuses/branches of the same location, never recommend completely different places. Generate content in English but provide Chinese characters for place names to help with navigation apps."
                    ),
                    APIConfig.DeepSeekRequest.Message(
                        role: "user",
                        content: prompt
                    )
                ]
                
                let response = try await networkService.sendChatMessage(messages: messages)
                
                await MainActor.run {
                    if let aiResponse = response.choices.first?.message.content {
                        print("AI original response: \(aiResponse)")
                        self.parseAnalysisResult(aiResponse, currentLocationInfo: currentLocationInfo, cacheKey: currentCacheKey)
                    }
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Analysis failed: \(error.localizedDescription)"
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    private func parseAnalysisResult(_ jsonString: String, currentLocationInfo: String, cacheKey: String) {
        print("Start parsing AI response, original length: \(jsonString.count)")
        
        // 检查响应是否为空
        guard !jsonString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("AI response is empty")
            createFallbackAnalysis("AI response is empty", currentLocationInfo: currentLocationInfo)
            return
        }
        
        // 简单清理：只保留第一个{到最后一个}之间的内容
        let cleanedJson = cleanJSONString(jsonString)
        print("Cleaned JSON: \(cleanedJson)")
        
        // 尝试解析JSON
        guard let jsonData = cleanedJson.data(using: .utf8) else {
            print("Cannot convert to Data")
            createFallbackAnalysis(jsonString, currentLocationInfo: currentLocationInfo)
            return
        }
        
        do {
            // 尝试直接解析JSON
            if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                print("Successfully parsed JSON object")
                parseJSONObject(jsonObject, currentLocationInfo: currentLocationInfo, cacheKey: cacheKey)
            } else {
                print("JSON format is incorrect")
                createFallbackAnalysis(jsonString, currentLocationInfo: currentLocationInfo)
            }
        } catch {
            print("JSON parsing error: \(error)")
            // 如果JSON解析失败，尝试从原始文本中提取有用信息
            createFallbackAnalysis(jsonString, currentLocationInfo: currentLocationInfo)
        }
    }
    
    private func cleanJSONString(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 查找第一个{的位置
        guard let firstBrace = trimmed.firstIndex(of: "{") else {
            return trimmed
        }
        
        // 查找最后一个}的位置
        guard let lastBrace = trimmed.lastIndex(of: "}") else {
            return trimmed
        }
        
        // 确保位置有效
        guard firstBrace <= lastBrace else {
            return trimmed
        }
        
        // 安全地提取JSON部分
        let jsonPart = String(trimmed[firstBrace...lastBrace])
        return jsonPart
    }
    
    private func parseJSONObject(_ jsonObject: [String: Any], currentLocationInfo: String, cacheKey: String) {
        // 安全地提取每个字段，提供默认值
        let validityCheck = jsonObject["validity_check"] as? [String: Any] ?? [:]
        let isValid = validityCheck["is_valid"] as? Bool ?? true
        let reason = validityCheck["reason"] as? String ?? ""
        let formattedStart = validityCheck["formatted_start"] as? String ?? currentLocationInfo
        let formattedEnd = validityCheck["formatted_end"] as? String ?? endPoint
        
        let destinationPurpose = jsonObject["destination_purpose"] as? String ?? "待分析的目的地"
        let multipleOptions = jsonObject["multiple_options"] as? String ?? ""
        let addressFormatConversion = jsonObject["address_format_conversion"] as? String ?? ""
        let alternativeSuggestions = jsonObject["alternative_suggestions"] as? [String] ?? []
        let transportAdvice = jsonObject["transport_advice"] as? String ?? "请选择合适的交通方式"
        let specialNotes = jsonObject["special_notes"] as? String ?? "请注意安全出行"
        
        // 创建分析结果
        let analysis = NavigationAnalysis(
            isValid: isValid,
            validityReason: reason,
            formattedStart: formattedStart,
            formattedEnd: formattedEnd,
            destinationPurpose: destinationPurpose,
            multipleOptions: multipleOptions,
            addressFormatConversion: addressFormatConversion,
            alternativeSuggestions: alternativeSuggestions,
            transportAdvice: transportAdvice,
            specialNotes: specialNotes
        )
        self.analysisResult = analysis
        self.showAnalysis = true
        print("Successfully parsed and created analysis result")
        
        // 保存分析结果到持久化存储
        saveAnalysisToStorage(analysis: analysis, key: cacheKey)
    }
    
    private func createFallbackAnalysis(_ text: String, currentLocationInfo: String) {
        print("Using fallback analysis")
        self.analysisResult = NavigationAnalysis(
            isValid: !text.lowercased().contains("invalid") && !text.lowercased().contains("unreasonable"),
            validityReason: text.contains("invalid") ? "Address verification failed, please check the input" : "",
            formattedStart: startPoint.isEmpty ? currentLocationInfo : startPoint,
            formattedEnd: endPoint,
            destinationPurpose: "Analysis result: \(endPoint) is a destination to be verified. Please re-query for more information.",
            multipleOptions: "",
            addressFormatConversion: "",
            alternativeSuggestions: [],
            transportAdvice: "We recommend using public transportation or ride-hailing services to reach the destination",
            specialNotes: "Please pay attention to traffic conditions and business hours, and confirm destination information before travel"
        )
        self.showAnalysis = true
    }
    
    private func copyLocationInfo() {
        guard let analysis = analysisResult else { return }
        let locationInfo = """
        📍 Starting Point: \(startPoint.isEmpty ? "Current Location" : startPoint) → \(analysis.formattedStart)
        🏁 Destination: \(endPoint) → \(analysis.formattedEnd)
        🎯 Purpose: \(analysis.destinationPurpose)
        """
        UIPasteboard.general.string = locationInfo
        
        // 显示复制成功提示
        withAnimation(.spring()) {
            showCopySuccess = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring()) {
                showCopySuccess = false
            }
        }
    }
    
    private func useRecommendation(_ suggestion: String) {
        endPoint = suggestion
        analyzeNavigation()
    }
    
    private func startNavigation() {
        guard let analysis = analysisResult, analysis.isValid else { return }
        
        let startLocation = startPoint.isEmpty ? "Current Location" : analysis.formattedStart
        let endLocation = analysis.formattedEnd
        
        print("🚗 Start navigation - starting point: \(startLocation), destination: \(endLocation)")
        
        // 先关闭当前页面
        dismiss()
        
        // 等待页面关闭完成后再发送导航通知
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("🚗 Sending navigation notification")
            // 搜索地址并开始导航
            self.searchAddressAndStartNavigation(
                startLocation: startLocation,
                endLocation: endLocation,
                useCurrentLocation: startPoint.isEmpty
            )
        }
    }
    
    // 搜索地址并开始导航的新方法
    private func searchAddressAndStartNavigation(startLocation: String, endLocation: String, useCurrentLocation: Bool) {
        print("🚗 开始搜索地址并导航 - 起点: \(startLocation), 终点: \(endLocation)")
        
        // 先搜索终点地址
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = endLocation
        
        // 如果有当前位置，以当前位置为中心搜索
        if let currentLocation = locationManager.location {
            request.region = MKCoordinateRegion(
                center: currentLocation.coordinate,
                latitudinalMeters: 50000,
                longitudinalMeters: 50000
            )
            print("🚗 Using current location as search center: \(currentLocation.coordinate)")
        } else {
            print("⚠️ No current location information")
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response, let destination = response.mapItems.first {
                    print("✅ Found destination address: \(destination.name ?? endLocation)")
                    print("📍 Destination coordinates: \(destination.placemark.coordinate)")
                    
                    // 发送导航请求通知
                    print("📡 Sending StartNavigationWithDetails notification")
                    NotificationCenter.default.post(
                        name: Notification.Name("StartNavigationWithDetails"),
                        object: [
                            "destination": destination,
                            "destinationName": endLocation,
                            "startLocationName": startLocation,
                            "useCurrentLocation": useCurrentLocation
                        ]
                    )
                    print("📡 StartNavigationWithDetails notification sent")
                } else {
                    print("❌ Search destination address failed: \(error?.localizedDescription ?? "Unknown error")")
                    // 如果搜索失败，仍然尝试发送原始地址
                    print("📡 Sending StartNavigationWithAddresses notification as backup")
                    NotificationCenter.default.post(
                        name: Notification.Name("StartNavigationWithAddresses"),
                        object: [
                            "start": startLocation,
                            "end": endLocation,
                            "useCurrentLocation": useCurrentLocation
                        ]
                    )
                    print("📡 StartNavigationWithAddresses 通知已发送")
                }
            }
        }
    }
    
    private func copyToChatAssistant() {
        guard let analysis = analysisResult else { return }
        
        let fullMessage = """
        🚗 Precise navigation analysis result
        
        📍 Location information:
        Starting point: \(startPoint.isEmpty ? "Current Location" : startPoint) → \(analysis.formattedStart)
        Destination: \(endPoint) → \(analysis.formattedEnd)
        
        🎯 Destination purpose:
        \(analysis.destinationPurpose)
        
        \(!analysis.multipleOptions.isEmpty ? "🔀 Multiple options: \n\(analysis.multipleOptions)\n" : "")
        ✅ Verification status: \(analysis.isValid ? "Passed" : "Need adjustment")
        \(!analysis.isValid ? "Reason: \(analysis.validityReason)\n" : "")
        Transportation advice:
        \(analysis.transportAdvice)
        
        Special notes:
        \(analysis.specialNotes)
        
        \(!analysis.alternativeSuggestions.isEmpty ? "💡 Alternative suggestions: \n\(analysis.alternativeSuggestions.joined(separator: "\n"))\n" : "")
        
        This is the precise navigation analysis provided for you, which can help you better plan your travel route. If you have any other questions or need further help, please feel free to tell me!
        """
        
        // 先关闭当前页面
        dismiss()
        
        // 延迟发送消息，确保页面切换完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // 发送切换到聊天页面的通知
            NotificationCenter.default.post(
                name: Notification.Name("SwitchToChat"),
                object: nil
            )
            
            // 再延迟一点发送消息，标注为AI消息
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                NotificationCenter.default.post(
                    name: Notification.Name("AddAIMessageToChatAssistant"),
                    object: fullMessage
                )
            }
        }
    }
    
    // MARK: - 持久化存储功能
    
    // 保存分析结果到持久化存储
    private func saveAnalysisToStorage(analysis: NavigationAnalysis, key: String) {
        do {
            // 将分析结果转换为可存储的格式
            let analysisData = [
                "isValid": analysis.isValid,
                "validityReason": analysis.validityReason,
                "formattedStart": analysis.formattedStart,
                "formattedEnd": analysis.formattedEnd,
                "destinationPurpose": analysis.destinationPurpose,
                "multipleOptions": analysis.multipleOptions,
                "addressFormatConversion": analysis.addressFormatConversion,
                "alternativeSuggestions": analysis.alternativeSuggestions,
                "transportAdvice": analysis.transportAdvice,
                "specialNotes": analysis.specialNotes,
                "timestamp": Date().timeIntervalSince1970 // 添加时间戳
            ] as [String: Any]
            
            let data = try JSONSerialization.data(withJSONObject: analysisData)
            
            // 获取当前存储的所有结果
            var allResults = loadAllAnalysisResults()
            allResults[key] = data
            
            // 限制存储数量，只保留最近的20个结果
            if allResults.count > 20 {
                let sortedKeys = allResults.keys.sorted { key1, key2 in
                    let timestamp1 = getTimestamp(from: allResults[key1])
                    let timestamp2 = getTimestamp(from: allResults[key2])
                    return timestamp1 > timestamp2
                }
                
                let keysToKeep = Array(sortedKeys.prefix(20))
                allResults = allResults.filter { keysToKeep.contains($0.key) }
            }
            
            // 保存到UserDefaults
            let allData = try JSONSerialization.data(withJSONObject: allResults.mapValues { $0.base64EncodedString() })
            UserDefaults.standard.set(allData, forKey: Self.analysisResultsKey)
            
            print("✅ Analysis result saved to persistent storage: \(key)")
        } catch {
            print("❌ Failed to save analysis result: \(error)")
        }
    }
    
    // 从持久化存储加载分析结果
    private func loadAnalysisFromStorage(key: String) -> NavigationAnalysis? {
        let allResults = loadAllAnalysisResults()
        
        guard let data = allResults[key] else {
            return nil
        }
        
        do {
            let analysisData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            guard let data = analysisData else { return nil }
            
            // 检查时间戳，如果超过7天则认为过期
            if let timestamp = data["timestamp"] as? TimeInterval {
                let age = Date().timeIntervalSince1970 - timestamp
                if age > 7 * 24 * 60 * 60 { // 7天
                    print("⏰ Cache result expired, will re-analyze")
                    return nil
                }
            }
            
            return NavigationAnalysis(
                isValid: data["isValid"] as? Bool ?? true,
                validityReason: data["validityReason"] as? String ?? "",
                formattedStart: data["formattedStart"] as? String ?? "",
                formattedEnd: data["formattedEnd"] as? String ?? "",
                destinationPurpose: data["destinationPurpose"] as? String ?? "",
                multipleOptions: data["multipleOptions"] as? String ?? "",
                addressFormatConversion: data["addressFormatConversion"] as? String ?? "",
                alternativeSuggestions: data["alternativeSuggestions"] as? [String] ?? [],
                transportAdvice: data["transportAdvice"] as? String ?? "",
                specialNotes: data["specialNotes"] as? String ?? ""
            )
        } catch {
            print("❌ Failed to load analysis result: \(error)")
            return nil
        }
    }
    
    // 加载所有存储的分析结果
    private func loadAllAnalysisResults() -> [String: Data] {
        guard let data = UserDefaults.standard.data(forKey: Self.analysisResultsKey) else {
            return [:]
        }
        
        do {
            let stringDict = try JSONSerialization.jsonObject(with: data) as? [String: String] ?? [:]
            var results: [String: Data] = [:]
            
            for (key, base64String) in stringDict {
                if let data = Data(base64Encoded: base64String) {
                    results[key] = data
                }
            }
            
            return results
        } catch {
            print("❌ Failed to load all analysis results: \(error)")
            return [:]
        }
    }
    
    // 获取数据的时间戳
    private func getTimestamp(from data: Data?) -> TimeInterval {
        guard let data = data,
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let timestamp = dict["timestamp"] as? TimeInterval else {
            return 0
        }
        return timestamp
    }
    
    private func restoreLastAnalysisResult() {
        let allResults = loadAllAnalysisResults()
        
        // 如果没有缓存结果，直接返回
        guard !allResults.isEmpty else {
            print("📱 No historical analysis results found")
            return
        }
        
        // 找到最新的分析结果
        var latestResult: (key: String, data: Data, timestamp: TimeInterval)?
        
        for (key, data) in allResults {
            let timestamp = getTimestamp(from: data)
            
            if latestResult == nil || timestamp > latestResult!.timestamp {
                latestResult = (key: key, data: data, timestamp: timestamp)
            }
        }
        
        guard let latest = latestResult else {
            print("📱 No valid latest result found")
            return
        }
        
        // 检查是否过期（7天）
        let age = Date().timeIntervalSince1970 - latest.timestamp
        if age > 7 * 24 * 60 * 60 {
            print("⏰ Latest result expired, not restored")
            return
        }
        
        // 解析缓存键以恢复起点和终点
        let components = latest.key.components(separatedBy: "-")
        if components.count == 2 {
            let cachedStartPoint = components[0] == "current" ? "" : components[0]
            let cachedEndPoint = components[1]
            
            // 恢复输入框内容
            startPoint = cachedStartPoint
            endPoint = cachedEndPoint
            
            // 恢复分析结果
            if let analysis = loadAnalysisFromStorage(key: latest.key) {
                print("📱✅ Successfully restored the most recent analysis result: \(cachedEndPoint)")
                analysisResult = analysis
                showAnalysis = true
            }
        }
    }
}

// MARK: - 辅助视图组件

struct PreciseNavFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.blue)
                .frame(width: 16)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct InputCard: View {
    let title: String
    let icon: String
    let iconColor: Color
    let placeholder: String
    @Binding var text: String
    var focused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            TextField(placeholder, text: $text)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
                .focused(focused)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ResultCard<Content: View>: View {
    let title: String
    let icon: String
    let iconColor: Color
    let content: Content
    
    init(title: String, icon: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            content
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct LocationRow: View {
    let label: String
    let original: String
    let formatted: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(label)：")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            HStack {
                Text(original)
                    .font(.body)
                    .foregroundColor(.primary)
                Image(systemName: "arrow.right")
                    .font(.caption)
                    .foregroundColor(.blue)
                Text(formatted)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
            }
        }
    }
}

struct EnhancedActionButton: View {
    let title: String
    let icon: String
    let gradient: [Color]
    let action: () -> Void
    var disabled: Bool = false
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            if !disabled {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
                action()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                disabled ? 
                AnyView(Color.gray.opacity(0.6)) :
                AnyView(LinearGradient(
                    gradient: Gradient(colors: gradient),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
            )
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .shadow(
                color: disabled ? .clear : gradient.first?.opacity(0.3) ?? .clear,
                radius: isPressed ? 2 : 6,
                x: 0,
                y: isPressed ? 1 : 3
            )
        }
        .disabled(disabled)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
    }
}

// MARK: - 数据模型
struct NavigationAnalysis {
    let isValid: Bool
    let validityReason: String
    let formattedStart: String
    let formattedEnd: String
    let destinationPurpose: String
    let multipleOptions: String
    let addressFormatConversion: String
    let alternativeSuggestions: [String]
    let transportAdvice: String
    let specialNotes: String
}

struct NavigationAPIResponse: Codable {
    let validity_check: ValidityCheck
    let destination_purpose: String
    let multiple_options: String
    let alternative_suggestions: [String]
    let transport_advice: String
    let special_notes: String
    
    struct ValidityCheck: Codable {
        let is_valid: Bool
        let reason: String
        let formatted_start: String
        let formatted_end: String
    }
}

struct DestinationSelectionGuideView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationSelectionGuideView()
    }
} 