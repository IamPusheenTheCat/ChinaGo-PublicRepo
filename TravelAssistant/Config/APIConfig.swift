//
//  APIConfig.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation

// MARK: - API Configuration Manager
struct APIConfig {
    
    // MARK: - Supabase Configuration
    struct Supabase {
        // Updated to new Supabase project
        static let url = "https://rrmsfaysvbcsgnjlymyp.supabase.co"
        // New project's anon public key
        static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJybXNmYXlzdmJjc2duamx5bXlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTc0NDYsImV4cCI6MjA2NDYzMzQ0Nn0.FV3aLpJzsSzwB-_XOcJoR4kiKXTi7g_bIjJBqzPi9wc"
        
        // Edge Functions endpoints - primary usage method
        static let chatFunction = "/functions/v1/deepseek-proxy"
        static let ocrFunction = "/functions/v1/baidu-ocr-proxy"
        static let translateFunction = "/functions/v1/deepseek-proxy"
        static let mapFunction = "/functions/v1/map"
        
        static func headers() -> [String: String] {
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(anonKey)",
                "apikey": anonKey,
                "x-bundle-id": "com.rantao.ChinaGo"  // Add application identifier
            ]
        }
        
        static func functionsURL(endpoint: String) -> String {
            return "\(url)\(endpoint)"
        }
    }
    
    // MARK: - Secure API Key Management
    struct SecureKeys {
        // API key storage key names in Keychain
        static let deepSeekKeyName = "DEEPSEEK_API_KEY"
        static let baiduAPIKeyName = "BAIDU_API_KEY"
        static let baiduSecretKeyName = "BAIDU_SECRET_KEY"
        
        // Get DeepSeek API key from Keychain
        static func getDeepSeekAPIKey() -> String? {
            return KeychainService.shared.retrieve(key: deepSeekKeyName)
        }
        
        // Get Baidu API key from Keychain
        static func getBaiduAPIKey() -> String? {
            return KeychainService.shared.retrieve(key: baiduAPIKeyName)
        }
        
        // Get Baidu Secret key from Keychain
        static func getBaiduSecretKey() -> String? {
            return KeychainService.shared.retrieve(key: baiduSecretKeyName)
        }
        
        // Set API key to Keychain (only for initial configuration)
        static func setDeepSeekAPIKey(_ key: String) -> Bool {
            return KeychainService.shared.store(key: deepSeekKeyName, value: key)
        }
        
        static func setBaiduAPIKey(_ key: String) -> Bool {
            return KeychainService.shared.store(key: baiduAPIKeyName, value: key)
        }
        
        static func setBaiduSecretKey(_ key: String) -> Bool {
            return KeychainService.shared.store(key: baiduSecretKeyName, value: key)
        }
        
        // Check if all required API keys are configured
        static func areAllKeysConfigured() -> Bool {
            return getDeepSeekAPIKey() != nil &&
                   getBaiduAPIKey() != nil &&
                   getBaiduSecretKey() != nil
        }
    }
    
    // MARK: - Direct API Configuration (only used when Edge Functions are unavailable)
    struct DirectAPI {
        // DeepSeek API
        struct DeepSeek {
            static let baseURL = "https://api.deepseek.com"
            static let chatCompletionEndpoint = "/chat/completions"
            
            static func headers() -> [String: String]? {
                // 优先使用Keychain中的API key
                if let keychainAPIKey = SecureKeys.getDeepSeekAPIKey() {
                    return [
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(keychainAPIKey)"
                    ]
                }
                
                // 如果Keychain中没有，使用硬编码的API key作为备用（开发阶段）
                let fallbackAPIKey = "sk-52d9cd4a53ff4aa8a9a95e87dff8af37"
                print("⚠️ Using fallback DeepSeek API key for development")
                return [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(fallbackAPIKey)"
                ]
            }
        }
        
        // Baidu OCR API
        struct BaiduOCR {
            static let tokenURL = "https://aip.baidubce.com/oauth/2.0/token"
            static let accurateURL = "https://aip.baidubce.com/rest/2.0/ocr/v1/accurate_basic"
            static let accurateBasicURL = "https://aip.baidubce.com/rest/2.0/ocr/v1/general_basic"
            
            static func tokenParams() -> [String: String]? {
                // Only use configuration from Keychain, no longer use hardcoded keys
                if let keychainAPIKey = SecureKeys.getBaiduAPIKey(),
                   let keychainSecretKey = SecureKeys.getBaiduSecretKey() {
                    return [
                        "grant_type": "client_credentials",
                        "client_id": keychainAPIKey,
                        "client_secret": keychainSecretKey
                    ]
                }
                
                print("⚠️ Baidu OCR API key not found, please configure through settings interface")
                return nil
            }
        }
    }
    
    // MARK: - DeepSeek API Configuration (via Supabase)
    struct DeepSeek {
        static let keyName = "deepseek-chatbox"
        static let documentationURL = "https://api-docs.deepseek.com/zh-cn/"
    }
    
    // MARK: - Baidu OCR API Configuration (via Supabase)
    struct BaiduOCR {
        static let keyName = "baidu-OCR-HignAccuracy"
        static let documentationURL = "https://cloud.baidu.com/doc/OCR/s/1k3h7y3db"
    }
}

// MARK: - API Response Models
extension APIConfig {
    
    // MARK: - DeepSeek Models
    struct DeepSeekRequest: Codable {
        let model: String
        let messages: [Message]
        let temperature: Double?
        let maxTokens: Int?
        let stream: Bool?
        
        enum CodingKeys: String, CodingKey {
            case model, messages, temperature, stream
            case maxTokens = "max_tokens"
        }
        
        struct Message: Codable {
            let role: String
            let content: String
        }
    }
    
    struct DeepSeekResponse: Codable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [Choice]
        let usage: Usage
        
        struct Choice: Codable {
            let index: Int
            let message: Message
            let finishReason: String?
            
            enum CodingKeys: String, CodingKey {
                case index, message
                case finishReason = "finish_reason"
            }
            
            struct Message: Codable {
                let role: String
                let content: String
            }
        }
        
        struct Usage: Codable {
            let promptTokens: Int
            let completionTokens: Int
            let totalTokens: Int
            
            enum CodingKeys: String, CodingKey {
                case promptTokens = "prompt_tokens"
                case completionTokens = "completion_tokens"
                case totalTokens = "total_tokens"
            }
        }
    }
    
    // MARK: - DeepSeek Streaming Response Model
    struct DeepSeekStreamResponse: Codable {
        let id: String
        let object: String
        let created: Int
        let model: String
        let choices: [StreamChoice]
        
        struct StreamChoice: Codable {
            let index: Int
            let delta: Delta
            let finishReason: String?
            
            enum CodingKeys: String, CodingKey {
                case index, delta
                case finishReason = "finish_reason"
            }
            
            struct Delta: Codable {
                let role: String?
                let content: String?
            }
        }
    }
    
    // MARK: - Baidu OCR Models
    struct BaiduTokenResponse: Codable {
        let accessToken: String
        let expiresIn: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case expiresIn = "expires_in"
        }
    }
    
    struct BaiduOCRRequest: Codable {
        let imageData: String // Base64 encoded image
        let useAccurate: Bool
    }
    
    struct BaiduOCRResponse: Codable {
        let wordsResultNum: Int
        let wordsResult: [WordResult]
        
        enum CodingKeys: String, CodingKey {
            case wordsResultNum = "words_result_num"
            case wordsResult = "words_result"
        }
        
        struct WordResult: Codable {
            let words: String
            let location: Location?
            
            struct Location: Codable {
                let left: Int
                let top: Int
                let width: Int
                let height: Int
            }
        }
    }
    
    // MARK: - Map Search Models
    struct MapSearchRequest: Codable {
        let query: String
        let region: MapRegion?
    }
    
    struct MapRegion: Codable {
        let latitude: Double
        let longitude: Double
        let latitudeDelta: Double
        let longitudeDelta: Double
    }
    
    struct MapSearchResponse: Codable {
        let results: [MapSearchResult]
        let success: Bool
        let error: String?
    }
    
    struct MapSearchResult: Codable {
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
        let category: String?
        let phone: String?
        let website: String?
    }
    
    // MARK: - Supabase API Response Wrapper
    struct SupabaseResponse<T: Codable>: Codable {
        let success: Bool
        let data: T?
        let error: String?
    }
    
    // MARK: - API Key Configuration Response
    struct APIKeySetupResponse {
        let success: Bool
        let message: String
        let missingKeys: [String]
    }
}

// MARK: - API Client Helper
extension APIConfig {
    
    /// Generate common headers for HTTP requests
    static func commonHeaders() -> [String: String] {
        return [
            "Content-Type": "application/json",
            "User-Agent": "TravelAssistant-iOS/1.0"
        ]
    }
    
    /// Check API key configuration status
    static func checkAPIKeySetup() -> APIKeySetupResponse {
        var missingKeys: [String] = []
        
        if SecureKeys.getDeepSeekAPIKey() == nil {
            missingKeys.append("DeepSeek API Key")
        }
        
        if SecureKeys.getBaiduAPIKey() == nil {
            missingKeys.append("Baidu API Key")
        }
        
        if SecureKeys.getBaiduSecretKey() == nil {
            missingKeys.append("Baidu Secret Key")
        }
        
        let success = missingKeys.isEmpty
        let message = success ? "All API keys are configured" : "Missing the following API keys: \(missingKeys.joined(separator: ", "))"
        
        return APIKeySetupResponse(
            success: success,
            message: message,
            missingKeys: missingKeys
        )
    }
} 