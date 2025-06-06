//
//  SpeechService.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import Speech
import AVFoundation

// MARK: - Speech Service Manager
class SpeechService: NSObject, ObservableObject {
    static let shared = SpeechService()
    
    // Speech Recognition
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // Speech Synthesis
    private let speechSynthesizer = AVSpeechSynthesizer()
    
    // Published properties
    @Published var isRecording = false
    @Published var recognizedText = ""
    @Published var isSpeaking = false
    @Published var authorizationStatus: SFSpeechRecognizerAuthorizationStatus = .notDetermined
    
    override init() {
        // 优先检查系统语言设置，如果是中文则默认使用中文识别
        let locale = Locale.current
        let systemLanguage = locale.language.languageCode?.identifier ?? "en"
        
        // 如果系统语言是中文，默认使用中文语音识别器
        if systemLanguage.hasPrefix("zh") {
            self.speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
        } else {
            // 否则使用系统当前locale，如果不支持则fallback到英语
            self.speechRecognizer = SFSpeechRecognizer(locale: locale) ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        }
        
        super.init()
        
        speechRecognizer?.delegate = self
        speechSynthesizer.delegate = self
        
        // Request authorization
        requestSpeechAuthorization()
    }
    
    // MARK: - Authorization
    
    private func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                self?.authorizationStatus = status
            }
        }
    }
    
    /// Public method to request permission
    func requestPermission() {
        requestSpeechAuthorization()
    }
    
    // MARK: - Speech Recognition
    
    /// Start recording with automatic language detection
    /// 开始录音并自动检测语言（中英文智能切换）
    func startRecordingWithAutoDetection() throws {
        try startRecording(language: .chinese) // 默认从中文开始
    }
    
    /// Start recording and speech recognition
    func startRecording(language: SpeechLanguage = .chinese) throws {
        // Cancel previous task
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure audio session
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        // Create recognition request
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechError.recognitionUnavailable
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        // Get appropriate speech recognizer for language
        let recognizer = getSpeechRecognizer(for: language)
        
        // Start recognition task
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            DispatchQueue.main.async {
                if let result = result {
                    self?.recognizedText = result.bestTranscription.formattedString
                }
                
                if error != nil || result?.isFinal == true {
                    self?.stopRecording()
                }
            }
        }
        
        // Configure audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        // Start audio engine
        audioEngine.prepare()
        try audioEngine.start()
        
        DispatchQueue.main.async {
            self.isRecording = true
        }
    }
    
    /// Stop recording and speech recognition
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        
        DispatchQueue.main.async {
            self.isRecording = false
        }
    }
    
    private func getSpeechRecognizer(for language: SpeechLanguage) -> SFSpeechRecognizer {
        let locale = Locale(identifier: language.localeIdentifier)
        let recognizer = SFSpeechRecognizer(locale: locale)
        
        // 如果指定语言的识别器不可用，提供fallback
        if recognizer == nil {
            print("⚠️ Speech recognizer does not support language \(language.displayName), using default recognizer")
            return speechRecognizer ?? SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))!
        }
        
        return recognizer!
    }
    
    /// 检查特定语言的语音识别是否可用
    func isSpeechRecognitionAvailable(for language: SpeechLanguage) -> Bool {
        let locale = Locale(identifier: language.localeIdentifier)
        let recognizer = SFSpeechRecognizer(locale: locale)
        return recognizer?.isAvailable ?? false
    }
    
    /// 获取设备支持的语音识别语言列表
    func getSupportedLanguages() -> [SpeechLanguage] {
        return SpeechLanguage.allCases.filter { language in
            isSpeechRecognitionAvailable(for: language)
        }
    }
    
    // MARK: - Speech Synthesis
    
    /// Speak text with specified language
    func speak(text: String, language: SpeechLanguage = .english, rate: Float = 0.5) {
        guard !text.isEmpty else { return }
        
        // Stop current speech
        stopSpeaking()
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language.localeIdentifier)
        utterance.rate = rate
        utterance.pitchMultiplier = 1.0
        utterance.volume = 1.0
        
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
        
        speechSynthesizer.speak(utterance)
    }
    
    /// Stop current speech
    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    /// Pause current speech
    func pauseSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.pauseSpeaking(at: .immediate)
        }
    }
    
    /// Continue paused speech
    func continueSpeaking() {
        if speechSynthesizer.isPaused {
            speechSynthesizer.continueSpeaking()
        }
    }
}

// MARK: - SFSpeechRecognizerDelegate

extension SpeechService: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // Handle availability changes
        if !available {
            DispatchQueue.main.async {
                self.stopRecording()
            }
        }
    }
}

// MARK: - AVSpeechSynthesizerDelegate

extension SpeechService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            self.isSpeaking = false
        }
    }
}

// MARK: - Supporting Types

enum SpeechLanguage: String, CaseIterable {
    case english = "en-US"
    case chinese = "zh-CN"
    case chineseTraditional = "zh-TW"
    case japanese = "ja-JP"
    case korean = "ko-KR"
    case french = "fr-FR"
    case german = "de-DE"
    case spanish = "es-ES"
    
    var localeIdentifier: String {
        return self.rawValue
    }
    
    var displayName: String {
        switch self {
        case .english:
            return "English (US)"
        case .chinese:
            return "Chinese (Simplified)"
        case .chineseTraditional:
            return "Chinese (Traditional)"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .french:
            return "Français"
        case .german:
            return "Deutsch"
        case .spanish:
            return "Español"
        }
    }
    
    var shortName: String {
        switch self {
        case .english:
            return "EN"
        case .chinese:
            return "Chinese"
        case .chineseTraditional:
            return "Chinese (Traditional)"
        case .japanese:
            return "日本語"
        case .korean:
            return "한국어"
        case .french:
            return "FR"
        case .german:
            return "DE"
        case .spanish:
            return "ES"
        }
    }
}

enum SpeechError: Error, LocalizedError {
    case recognitionUnavailable
    case authorizationDenied
    case audioEngineError
    
    var errorDescription: String? {
        switch self {
        case .recognitionUnavailable:
            return "Speech recognition is not available"
        case .authorizationDenied:
            return "Speech recognition authorization denied"
        case .audioEngineError:
            return "Audio engine error"
        }
    }
} 