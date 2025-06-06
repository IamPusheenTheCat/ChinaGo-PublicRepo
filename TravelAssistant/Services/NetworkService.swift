//
//  NetworkService.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import UIKit
import MapKit

// MARK: - Network Service Manager
class NetworkService: ObservableObject {
    static let shared = NetworkService()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60  // 增加到60秒
        config.timeoutIntervalForResource = 120 // 增加到120秒
        config.waitsForConnectivity = true // 等待网络连接
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.allowsConstrainedNetworkAccess = true
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - DeepSeek Chat API 智能路由
    
    /// Send chat message - 智能路由: Supabase优先，DirectAPI备用
    func sendChatMessage(
        messages: [APIConfig.DeepSeekRequest.Message],
        model: String = "deepseek-chat",
        temperature: Double = 0.7,
        maxTokens: Int = 2000
    ) async throws -> APIConfig.DeepSeekResponse {
        
        // 首先尝试Supabase Edge Function
        do {
            return try await sendChatMessageViaSupabase(
                messages: messages,
                model: model,
                temperature: temperature,
                maxTokens: maxTokens
            )
        } catch {
            print("⚠️ Supabase call failed, switching to direct API call: \(error.localizedDescription)")
            
            // Supabase失败时，使用直接API调用
            return try await sendChatMessageDirectly(
                messages: messages,
                model: model,
                temperature: temperature,
                maxTokens: maxTokens
            )
        }
    }
    
    /// 通过Supabase Edge Function调用DeepSeek
    private func sendChatMessageViaSupabase(
        messages: [APIConfig.DeepSeekRequest.Message],
        model: String,
        temperature: Double,
        maxTokens: Int
    ) async throws -> APIConfig.DeepSeekResponse {
        
        let requestData = APIConfig.DeepSeekRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            maxTokens: maxTokens,
            stream: false  // 保持非流式，因为这个方法是为了返回完整响应
        )
        
        let urlString = APIConfig.Supabase.functionsURL(endpoint: APIConfig.Supabase.chatFunction)
        print("📡 Call Supabase endpoint: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60.0  // 增加超时时间
        
        // 设置完整的请求头
        var headers = APIConfig.Supabase.headers()
        headers["User-Agent"] = "TravelAssistant-iOS/1.0"
        headers["X-Client-Info"] = "ios-travelassistant/1.0"
        headers["X-Bundle-Identifier"] = "com.rantao.ChinaGo"  // 与APIConfig保持一致
        
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(requestData)
        
        // 打印请求信息用于调试
        print("📋 Request headers: \(headers)")
        if let bodyData = request.httpBody,
           let bodyString = String(data: bodyData, encoding: .utf8) {
            print("📋 Request body: \(bodyString)")
        }
        
        // 重试机制
        var lastError: Error?
        for attempt in 1...3 {
            do {
                print("🔄 Try Supabase call (attempt \(attempt)): \(urlString)")
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                print("📊 HTTP status code: \(httpResponse.statusCode)")
                
                // 打印响应数据用于调试
                if let responseString = String(data: data, encoding: .utf8) {
                    print("📋 Response data: \(responseString)")
                }
                
                if httpResponse.statusCode != 200 {
                    let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ Supabase Edge Function error (\(httpResponse.statusCode)): \(errorString)")
                    
                    // 404表示Edge Function不存在
                    if httpResponse.statusCode == 404 {
                        throw NetworkError.missingAPIKey("Backend Edge Function does not exist. Please check if 'deepseek-proxy' function is deployed in Supabase.")
                    }
                    
                    throw NetworkError.invalidResponse
                }
                
                // 尝试直接解析为DeepSeek响应（如果Edge Function直接返回DeepSeek格式）
                do {
                    let directResponse = try JSONDecoder().decode(APIConfig.DeepSeekResponse.self, from: data)
                    print("✅ Supabase call successful (direct format)")
                    return directResponse
                } catch {
                    // 如果失败，尝试解析为Supabase包装格式
                    do {
                        let supabaseResponse = try JSONDecoder().decode(APIConfig.SupabaseResponse<APIConfig.DeepSeekResponse>.self, from: data)
                        
                        if let responseData = supabaseResponse.data {
                            print("✅ Supabase call successful (wrapped format)")
                            return responseData
                        } else if let error = supabaseResponse.error {
                            print("❌ Supabase function internal error: \(error)")
                            throw NetworkError.missingAPIKey("Backend error: \(error)")
                        } else {
                            throw NetworkError.invalidResponse
                        }
                    } catch {
                        print("❌ Response parsing failed: \(error)")
                        throw NetworkError.invalidResponse
                    }
                }
            } catch {
                lastError = error
                print("❌ Try \(attempt) failed: \(error.localizedDescription)")
                
                if attempt < 3 {
                    // 等待后重试
                    try await Task.sleep(nanoseconds: UInt64(attempt * 1_000_000_000)) // 1, 2 秒
                }
            }
        }
        
        throw lastError ?? NetworkError.invalidResponse
    }
    
    /// 直接调用DeepSeek API（使用硬编码密钥）
    private func sendChatMessageDirectly(
        messages: [APIConfig.DeepSeekRequest.Message],
        model: String,
        temperature: Double,
        maxTokens: Int
    ) async throws -> APIConfig.DeepSeekResponse {
        
        let requestData = APIConfig.DeepSeekRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            maxTokens: maxTokens,
            stream: false  // 保持非流式，因为这个方法是为了返回完整响应
        )
        
        let urlString = "\(APIConfig.DirectAPI.DeepSeek.baseURL)\(APIConfig.DirectAPI.DeepSeek.chatCompletionEndpoint)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 60.0
        
        // 使用DirectAPI的headers（包含硬编码密钥）
        guard let headers = APIConfig.DirectAPI.DeepSeek.headers() else {
            throw NetworkError.authenticationFailed
        }
        
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(requestData)
        
        print("🔑 Use direct DeepSeek API call")
        print("📡 URL: \(urlString)")
        
        // 执行请求
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        if httpResponse.statusCode != 200 {
            let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
            print("❌ DeepSeek API Error (\(httpResponse.statusCode)): \(errorString)")
            throw NetworkError.invalidResponse
        }
        
        let deepSeekResponse = try JSONDecoder().decode(APIConfig.DeepSeekResponse.self, from: data)
        print("✅ Direct DeepSeek API call successful")
        
        return deepSeekResponse
    }
    
    /// Test DeepSeek API connectivity
    func testDeepSeekAPI() async throws -> (isWorking: Bool, message: String) {
        do {
            let testMessage = APIConfig.DeepSeekRequest.Message(role: "user", content: "Hello")
            let response = try await sendChatMessage(messages: [testMessage], maxTokens: 50)
            
            if let content = response.choices.first?.message.content {
                return (true, "API working normally: \(content.prefix(50))...")
            } else {
                return (false, "API returned empty response")
            }
        } catch {
            return (false, "API connection failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 百度OCR API - 仅通过Supabase后端
    
    /// Perform OCR - 仅通过Supabase Edge Function
    func performOCR(
        on imageData: Data,
        useAccurateWithLocation: Bool = false
    ) async throws -> APIConfig.BaiduOCRResponse {
        
        // 仅使用Supabase Edge Function
        return try await performOCRViaSupabase(
            imageData: imageData,
            useAccurateWithLocation: useAccurateWithLocation
        )
    }
    
    /// 通过Supabase Edge Function调用百度OCR
    private func performOCRViaSupabase(
        imageData: Data,
        useAccurateWithLocation: Bool
    ) async throws -> APIConfig.BaiduOCRResponse {
        
        let base64Image = imageData.base64EncodedString()
        
        // 构建符合Edge Function期望的请求格式
        let requestPayload: [String: Any] = [
            "imageData": base64Image,
            "useAccurate": useAccurateWithLocation,
            "needTranslation": false,
            "targetLanguage": "ENG"
        ]
        
        let urlString = APIConfig.Supabase.functionsURL(endpoint: APIConfig.Supabase.ocrFunction)
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = APIConfig.Supabase.headers()
        request.httpBody = try JSONSerialization.data(withJSONObject: requestPayload)
        
        // 重试机制
        var lastError: Error?
        for attempt in 1...3 {
            do {
                print("🚀 Try Supabase OCR call (attempt \(attempt))")
                let (data, response) = try await session.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                if httpResponse.statusCode != 200 {
                    let errorString = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("❌ Supabase OCR Function Error (\(httpResponse.statusCode)): \(errorString)")
                    throw NetworkError.invalidResponse
                }
                
                // 直接解析百度OCR响应（Edge Function直接返回）
                let ocrResponse = try JSONDecoder().decode(APIConfig.BaiduOCRResponse.self, from: data)
                print("✅ Supabase OCR call successful")
                return ocrResponse
                
            } catch {
                lastError = error
                print("⚠️ Try OCR \(attempt) failed: \(error.localizedDescription)")
                
                if attempt < 3 {
                    // 等待后重试
                    try await Task.sleep(nanoseconds: UInt64(attempt * 1_500_000_000)) // 1.5, 3 秒
                }
            }
        }
        
        throw lastError ?? NetworkError.invalidResponse
    }
    
    /// Translate OCR results using DeepSeek
    func translateOCRResults(_ ocrResponse: APIConfig.BaiduOCRResponse) async throws -> [TranslatedText] {
        var translatedTexts: [TranslatedText] = []
        
        for wordResult in ocrResponse.wordsResult {
            let originalText = wordResult.words
            
            let systemMessage = APIConfig.DeepSeekRequest.Message(
                role: "system",
                content: "You are a Chinese to English translator. Translate the Chinese text to English. Only return the translation without explanation."
            )
            
            let userMessage = APIConfig.DeepSeekRequest.Message(
                role: "user",
                content: "Translate: \(originalText)"
            )
            
            do {
                let response = try await sendChatMessage(
                    messages: [systemMessage, userMessage],
                    temperature: 0.3,
                    maxTokens: 200
                )
                
                if let translatedText = response.choices.first?.message.content {
                    translatedTexts.append(TranslatedText(
                        originalText: originalText,
                        translatedText: translatedText.trimmingCharacters(in: .whitespacesAndNewlines),
                        location: wordResult.location
                    ))
                }
            } catch {
                print("Translation failed for text: \(originalText)")
                translatedTexts.append(TranslatedText(
                    originalText: originalText,
                    translatedText: "Translation failed",
                    location: wordResult.location
                ))
            }
        }
        
        return translatedTexts
    }
    
    // MARK: - Map Search API 智能路由
    
    /// Search places - 使用Apple MapKit作为主要方案
    func searchPlaces(query: String, region: MKCoordinateRegion? = nil) async throws -> [MKMapItem] {
        
        // 使用Apple MapKit进行搜索（最可靠的方案）
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        if let region = region {
            request.region = region
        }
        
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems
    }
    
    /// Test MapKit search functionality
    func testMapKitSearch() async throws -> (isWorking: Bool, message: String) {
        do {
            let results = try await searchPlaces(query: "餐厅")
            return (true, "MapKit搜索工作正常，找到 \(results.count) 个结果")
        } catch {
            return (false, "MapKit搜索失败: \(error.localizedDescription)")
        }
    }
    
    /// Get coordinates for an address using MapKit
    func geocodeAddress(_ address: String) async throws -> [CLPlacemark] {
        let geocoder = CLGeocoder()
        return try await geocoder.geocodeAddressString(address)
    }
    
    /// Convert coordinates to address using MapKit
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        let geocoder = CLGeocoder()
        return try await geocoder.reverseGeocodeLocation(location)
    }
    
    /// Convert English place name to Chinese using DeepSeek via Supabase
    func convertPlaceNameToChinese(englishName: String) async throws -> PlaceNameConversion {
        let systemMessage = APIConfig.DeepSeekRequest.Message(
            role: "system",
            content: "You are a location expert for China. Convert the English place name to accurate Chinese name. Return a JSON with 'chineseName' and 'alternativeNames' (array of possible alternative Chinese names). Only return valid JSON."
        )
        
        let userMessage = APIConfig.DeepSeekRequest.Message(
            role: "user",
            content: "Convert this English place name to Chinese: \(englishName)"
        )
        
        let response = try await sendChatMessage(
            messages: [systemMessage, userMessage],
            temperature: 0.1,
            maxTokens: 200
        )
        
        guard let content = response.choices.first?.message.content,
              let data = content.data(using: .utf8) else {
            throw NetworkError.invalidResponse
        }
        
        return try JSONDecoder().decode(PlaceNameConversion.self, from: data)
    }
    
    /// Open location in Maps app (Apple Maps)
    func openInMapsApp(latitude: Double, longitude: Double, name: String? = nil) {
        guard let shared = UIApplication.shared as UIApplication? else { return }
        
        // Use Apple Maps directly since AutoNavi is removed
        let appleMapsURLString = "http://maps.apple.com/?q=\(name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Location")&ll=\(latitude),\(longitude)"
        
        if let appleMapsURL = URL(string: appleMapsURLString) {
            shared.open(appleMapsURL)
        }
    }
    
    // MARK: - 组合功能
    
    /// OCR和翻译组合功能
    func ocrAndTranslate(
        imageData: Data,
        targetLanguage: String = "English"
    ) async throws -> [TranslatedTextItem] {
        
        // 首先进行OCR
        let ocrResponse = try await performOCR(on: imageData, useAccurateWithLocation: true)
        
        var translatedTexts: [TranslatedTextItem] = []
        
        // 翻译每个识别的文本
        for wordResult in ocrResponse.wordsResult {
            let systemMessage = APIConfig.DeepSeekRequest.Message(
                role: "system",
                content: "You are a professional translator. Translate the given Chinese text to \(targetLanguage). Only return the translated text without any additional explanation."
            )
            
            let userMessage = APIConfig.DeepSeekRequest.Message(
                role: "user",
                content: wordResult.words
            )
            
            do {
                let response = try await sendChatMessage(
                    messages: [systemMessage, userMessage],
                    temperature: 0.3,
                    maxTokens: 200
                )
                
                let translatedText = response.choices.first?.message.content ?? wordResult.words
                
                let translatedItem = TranslatedTextItem(
                    originalText: wordResult.words,
                    translatedText: translatedText,
                    location: wordResult.location
                )
                
                translatedTexts.append(translatedItem)
            } catch {
                print("Translation failed: \(wordResult.words) - \(error)")
                
                // 如果翻译失败，保留原文
                let translatedItem = TranslatedTextItem(
                    originalText: wordResult.words,
                    translatedText: "Translation failed",
                    location: wordResult.location
                )
                
                translatedTexts.append(translatedItem)
            }
        }
        
        return translatedTexts
    }
    
    // MARK: - 工具方法
    
    /// Test API connectivity
    func testAllAPIs() async -> (deepSeek: Bool, baiduOCR: Bool, maps: Bool) {
        var results = (deepSeek: false, baiduOCR: false, maps: false)
        
        // 测试DeepSeek
        do {
            let testMessage = APIConfig.DeepSeekRequest.Message(role: "user", content: "Hello")
            let _ = try await sendChatMessage(messages: [testMessage], maxTokens: 50)
            results.deepSeek = true
        } catch {
            print("DeepSeek API test failed: \(error)")
        }
        
        // 测试百度OCR（使用测试图片）
        do {
            let testImage = UIImage(systemName: "doc.text")?.jpegData(compressionQuality: 0.8) ?? Data()
            let _ = try await performOCR(on: testImage)
            results.baiduOCR = true
        } catch {
            print("Baidu OCR API test failed: \(error)")
        }
        
        // 测试地图搜索
        do {
            let _ = try await searchPlaces(query: "餐厅")
            results.maps = true
        } catch {
            print("Map search test failed: \(error)")
        }
        
        return results
    }
    
    /// Send chat message with streaming - 真正的流式响应
    func sendChatMessageStreaming(
        messages: [APIConfig.DeepSeekRequest.Message],
        model: String = "deepseek-chat",
        temperature: Double = 0.7,
        maxTokens: Int = 2000,
        onChunk: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) async {
        
        let requestData = APIConfig.DeepSeekRequest(
            model: model,
            messages: messages,
            temperature: temperature,
            maxTokens: maxTokens,
            stream: true
        )
        
        // 首先尝试通过Supabase Edge Function
        do {
            try await sendChatMessageStreamingViaSupabase(
                requestData: requestData,
                onChunk: onChunk,
                onComplete: onComplete,
                onError: onError
            )
        } catch {
            print("⚠️ Supabase streaming failed, switching to direct API: \(error.localizedDescription)")
            
            // Supabase失败时，使用直接API调用
            do {
                try await sendChatMessageStreamingDirectly(
                    requestData: requestData,
                    onChunk: onChunk,
                    onComplete: onComplete,
                    onError: onError
                )
            } catch {
                print("⚠️ Direct streaming also failed: \(error.localizedDescription)")
                onError(error)
            }
        }
    }
    
    /// 通过Supabase Edge Function进行流式调用
    private func sendChatMessageStreamingViaSupabase(
        requestData: APIConfig.DeepSeekRequest,
        onChunk: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) async throws {
        
        let urlString = APIConfig.Supabase.functionsURL(endpoint: APIConfig.Supabase.chatFunction)
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 120.0
        
        // 设置Supabase headers，包括bundle ID验证
        var headers = APIConfig.Supabase.headers()
        headers["User-Agent"] = "TravelAssistant-iOS/1.0"
        headers["X-Client-Info"] = "ios-travelassistant/1.0"
        headers["X-Bundle-Identifier"] = "com.rantao.ChinaGo"
        
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(requestData)
        
        print("🌊 开始Supabase流式请求: \(urlString)")
        
        // 使用URLSession的bytes方法来处理流式响应
        let (asyncBytes, response) = try await session.bytes(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📊 Supabase流式响应状态码: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode != 200 {
            let errorString = "HTTP \(httpResponse.statusCode)"
            print("❌ Supabase流式响应错误: \(errorString)")
            throw NetworkError.invalidResponse
        }
        
        // 逐行读取流式响应
        for try await line in asyncBytes.lines {
            // 跳过空行
            guard !line.isEmpty else { continue }
            
            // 处理 SSE 格式的数据行
            if line.hasPrefix("data: ") {
                let dataContent = String(line.dropFirst(6)) // 移除 "data: " 前缀
                
                // 检查是否是结束标记
                if dataContent == "[DONE]" {
                    print("✅ Supabase流式响应完成")
                    await MainActor.run {
                        onComplete()
                    }
                    return
                }
                
                // 尝试解析JSON
                guard let data = dataContent.data(using: .utf8) else { continue }
                
                do {
                    let streamResponse = try JSONDecoder().decode(APIConfig.DeepSeekStreamResponse.self, from: data)
                    
                    // 提取内容并发送给UI
                    if let choice = streamResponse.choices.first,
                       let content = choice.delta.content {
                        print("📝 收到Supabase流式内容: \(content)")
                        await MainActor.run {
                            onChunk(content)
                        }
                    }
                    
                    // 检查是否结束
                    if let choice = streamResponse.choices.first,
                       choice.finishReason != nil {
                        print("✅ Supabase流式响应完成 (finish_reason: \(choice.finishReason ?? "unknown"))")
                        await MainActor.run {
                            onComplete()
                        }
                        return
                    }
                    
                } catch {
                    print("⚠️ 解析Supabase流式响应失败: \(error.localizedDescription)")
                    print("⚠️ 原始数据: \(dataContent)")
                    // 继续处理下一行，不中断流
                }
            }
        }
        
        // 如果循环结束但没有收到 [DONE]，也认为完成
        await MainActor.run {
            onComplete()
        }
    }
    
    /// 直接调用DeepSeek API进行流式调用
    private func sendChatMessageStreamingDirectly(
        requestData: APIConfig.DeepSeekRequest,
        onChunk: @escaping (String) -> Void,
        onComplete: @escaping () -> Void,
        onError: @escaping (Error) -> Void
    ) async throws {
        
        let urlString = "\(APIConfig.DirectAPI.DeepSeek.baseURL)\(APIConfig.DirectAPI.DeepSeek.chatCompletionEndpoint)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 120.0
        
        // 设置DeepSeek API headers
        guard let headers = APIConfig.DirectAPI.DeepSeek.headers() else {
            throw NetworkError.missingAPIKey("DeepSeek API key not configured")
        }
        
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(requestData)
        
        print("🌊 开始DeepSeek直接流式请求: \(urlString)")
        
        // 使用URLSession的bytes方法来处理流式响应
        let (asyncBytes, response) = try await session.bytes(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        print("📊 DeepSeek直接流式响应状态码: \(httpResponse.statusCode)")
        
        if httpResponse.statusCode != 200 {
            let errorString = "HTTP \(httpResponse.statusCode)"
            print("❌ DeepSeek直接流式响应错误: \(errorString)")
            throw NetworkError.invalidResponse
        }
        
        // 逐行读取流式响应
        for try await line in asyncBytes.lines {
            // 跳过空行
            guard !line.isEmpty else { continue }
            
            // 处理 SSE 格式的数据行
            if line.hasPrefix("data: ") {
                let dataContent = String(line.dropFirst(6)) // 移除 "data: " 前缀
                
                // 检查是否是结束标记
                if dataContent == "[DONE]" {
                    print("✅ DeepSeek直接流式响应完成")
                    await MainActor.run {
                        onComplete()
                    }
                    return
                }
                
                // 尝试解析JSON
                guard let data = dataContent.data(using: .utf8) else { continue }
                
                do {
                    let streamResponse = try JSONDecoder().decode(APIConfig.DeepSeekStreamResponse.self, from: data)
                    
                    // 提取内容并发送给UI
                    if let choice = streamResponse.choices.first,
                       let content = choice.delta.content {
                        print("📝 收到DeepSeek直接流式内容: \(content)")
                        await MainActor.run {
                            onChunk(content)
                        }
                    }
                    
                    // 检查是否结束
                    if let choice = streamResponse.choices.first,
                       choice.finishReason != nil {
                        print("✅ DeepSeek直接流式响应完成 (finish_reason: \(choice.finishReason ?? "unknown"))")
                        await MainActor.run {
                            onComplete()
                        }
                        return
                    }
                    
                } catch {
                    print("⚠️ 解析DeepSeek直接流式响应失败: \(error.localizedDescription)")
                    print("⚠️ 原始数据: \(dataContent)")
                    // 继续处理下一行，不中断流
                }
            }
        }
        
        // 如果循环结束但没有收到 [DONE]，也认为完成
        await MainActor.run {
            onComplete()
        }
    }
}

// MARK: - Supporting Models

struct TranslatedText {
    let originalText: String
    let translatedText: String
    let location: APIConfig.BaiduOCRResponse.WordResult.Location?
}

struct PlaceNameConversion: Codable {
    let chineseName: String
    let alternativeNames: [String]
}

// MARK: - Network Errors

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    case missingAPIKey(String)
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .missingAPIKey(let message):
            return "Missing API Key: \(message)"
        case .authenticationFailed:
            return "Authentication failed"
        }
    }
}

// MARK: - UIApplication Extension
extension UIApplication {
    static func openInMapsApp(latitude: Double, longitude: Double, name: String? = nil) {
        guard let shared = UIApplication.shared as UIApplication? else { return }
        
        // Use Apple Maps directly since AutoNavi is removed
        let appleMapsURLString = "http://maps.apple.com/?q=\(name?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "Location")&ll=\(latitude),\(longitude)"
        
        if let appleMapsURL = URL(string: appleMapsURLString) {
            shared.open(appleMapsURL)
        }
    }
} 