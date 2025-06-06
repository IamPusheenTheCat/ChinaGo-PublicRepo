#!/usr/bin/env python3
import requests
import json
import base64

# iOS应用将使用的配置
SUPABASE_URL = "https://rrmsfaysvbcsgnjlymyp.supabase.co"
SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJybXNmYXlzdmJjc2duamx5bXlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNTc0NDYsImV4cCI6MjA2NDYzMzQ0Nn0.FV3aLpJzsSzwB-_XOcJoR4kiKXTi7g_bIjJBqzPi9wc"

def test_ios_style_ocr():
    print("📱 测试iOS风格的百度OCR调用")
    
    # 模拟iOS应用的请求头
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {SUPABASE_ANON_KEY}',
        'apikey': SUPABASE_ANON_KEY,
        'x-bundle-id': 'com.rantao.ChinaGo',
        'User-Agent': 'TravelAssistant-iOS/1.0',
        'X-Client-Info': 'ios-travelassistant/1.0',
        'X-Bundle-Identifier': 'a.TravelAssistant'
    }
    
    # 使用简单的测试图片
    test_image = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg=="
    
    # 构建与iOS应用相同的请求格式
    payload = {
        "imageData": test_image,
        "useAccurate": False,
        "needTranslation": False,
        "targetLanguage": "ENG"
    }
    
    url = f"{SUPABASE_URL}/functions/v1/baidu-ocr-proxy"
    
    try:
        print(f"📡 发送请求到: {url}")
        response = requests.post(url, headers=headers, json=payload, timeout=30)
        print(f"📊 响应状态码: {response.status_code}")
        
        if response.status_code == 200:
            result = response.json()
            print("✅ iOS风格OCR测试成功")
            print(f"📋 响应格式: {json.dumps(result, ensure_ascii=False, indent=2)}")
            
            # 检查响应是否符合百度OCR格式
            if 'words_result' in result or 'error_code' in result:
                print("✅ 响应格式正确，符合百度OCR格式")
                return True
            else:
                print("⚠️ 响应格式可能不正确")
                return False
        else:
            print(f"❌ 请求失败: {response.status_code}")
            print(f"错误内容: {response.text}")
            return False
            
    except Exception as e:
        print(f"❌ 请求异常: {str(e)}")
        return False

if __name__ == "__main__":
    print("🚀 测试修复后的iOS OCR配置")
    print("=" * 50)
    
    success = test_ios_style_ocr()
    
    print("\n" + "=" * 50)
    if success:
        print("🎉 iOS OCR配置修复成功！")
        print("📱 应用应该不再显示'missing api key'错误")
    else:
        print("💥 仍有问题需要解决") 