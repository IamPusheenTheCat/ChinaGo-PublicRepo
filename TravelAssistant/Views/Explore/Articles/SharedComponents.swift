//
//  SharedComponents.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI

// Article Section Component
struct ArticleSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(formatContentLines(content), id: \.self) { line in
                    if line.hasPrefix("**") && line.hasSuffix("**") && line.count > 4 {
                        // Handle bold titles
                        Text(String(line.dropFirst(2).dropLast(2)))
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    } else if line.hasPrefix("• ") {
                        // Handle bullet points, including bold text within
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.body)
                                .foregroundColor(.primary)
                            formattedText(String(line.dropFirst(2)))
                            Spacer()
                        }
                    } else if !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        // Handle regular text lines
                        formattedText(line)
                    }
                }
            }
        }
    }
    
    private func formatContentLines(_ content: String) -> [String] {
        return content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
    
    private func formattedText(_ text: String) -> some View {
        let parts = parseBoldText(text)
        var result = Text("")
        
        for part in parts {
            if part.isBold {
                result = result + Text(part.text)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            } else {
                result = result + Text(part.text)
                    .foregroundColor(.primary)
            }
        }
        
        return result
            .font(.body)
            .multilineTextAlignment(.leading)
    }
    
    private struct TextPart {
        let text: String
        let isBold: Bool
    }
    
    private func parseBoldText(_ input: String) -> [TextPart] {
        var result: [TextPart] = []
        var currentText = ""
        var isBold = false
        var i = input.startIndex
        
        while i < input.endIndex {
            if i < input.index(input.endIndex, offsetBy: -1) && 
               input[i] == "*" && input[input.index(after: i)] == "*" {
                
                // Found "**", add current text if any
                if !currentText.isEmpty {
                    result.append(TextPart(text: currentText, isBold: isBold))
                    currentText = ""
                }
                
                // Toggle bold state
                isBold.toggle()
                
                // Skip both asterisks
                i = input.index(i, offsetBy: 2)
            } else {
                // Regular character
                currentText.append(input[i])
                i = input.index(after: i)
            }
        }
        
        // Add remaining text
        if !currentText.isEmpty {
            result.append(TextPart(text: currentText, isBold: isBold))
        }
        
        return result
    }
}

// Image Placeholder Component
struct ImagePlaceholder: View {
    let title: String
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(height: 200)
                .cornerRadius(10)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text(title)
                            .foregroundColor(.gray)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                    }
                )
        }
    }
} 