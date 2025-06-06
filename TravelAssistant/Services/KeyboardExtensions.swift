//
//  KeyboardExtensions.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import SwiftUI
import UIKit

// MARK: - 键盘管理扩展
extension View {
    /// 点击时隐藏键盘
    func dismissKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    /// 拖拽时隐藏键盘
    func dismissKeyboardOnDrag() -> some View {
        self.gesture(
            DragGesture()
                .onChanged { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        )
    }
    
    /// 隐藏键盘
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
} 