//
//  MotionManager.swift
//  TravelAssistant
//
//  Created by taoranmr on 5/15/25.
//

import Foundation
import CoreMotion
import CoreLocation
import SwiftUI

class MotionManager: NSObject, ObservableObject {
    static let shared = MotionManager()
    
    private let motionManager = CMMotionManager()
    private let locationManager = CLLocationManager()
    
    @Published var deviceHeading: Double = 0.0
    @Published var trueHeading: Double = 0.0
    @Published var magneticHeading: Double = 0.0
    @Published var isMotionActive = false
    @Published var isHeadingAvailable = false
    @Published var motionData: CMDeviceMotion?
    @Published var magneticDeclination: Double = 0.0
    
    // 加速度计数据
    @Published var acceleration: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    @Published var gravity: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    @Published var userAcceleration: CMAcceleration = CMAcceleration(x: 0, y: 0, z: 0)
    
    // 陀螺仪数据
    @Published var rotationRate: CMRotationRate = CMRotationRate(x: 0, y: 0, z: 0)
    
    // 磁力计数据
    @Published var magneticField: CMMagneticField = CMMagneticField(x: 0, y: 0, z: 0)
    
    private override init() {
        super.init()
        locationManager.delegate = self
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        // 设置更新频率
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0 // 30Hz
        motionManager.accelerometerUpdateInterval = 1.0 / 30.0
        motionManager.gyroUpdateInterval = 1.0 / 30.0
        motionManager.magnetometerUpdateInterval = 1.0 / 30.0
        
        // 检查各种传感器的可用性
        isHeadingAvailable = motionManager.isDeviceMotionAvailable
    }
    
    func startMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("❌ Device motion not available")
            return
        }
        
        print("🎯 Starting motion updates...")
        isMotionActive = true
        
        motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: .main) { [weak self] motion, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ Motion update error: \(error.localizedDescription)")
                return
            }
            
            guard let motion = motion else { return }
            
            DispatchQueue.main.async {
                self.motionData = motion
                self.acceleration = motion.gravity
                self.gravity = motion.gravity
                self.userAcceleration = motion.userAcceleration
                self.rotationRate = motion.rotationRate
                self.magneticField = motion.magneticField.field
                
                // 计算设备方向（以北为0度，顺时针为正）
                let heading = motion.attitude.yaw * 180.0 / .pi
                let normalizedHeading = heading < 0 ? heading + 360 : heading
                self.deviceHeading = normalizedHeading
            }
        }
    }
    
    func startHeadingUpdates() {
        // 启动 Core Location 的方向更新以获取磁偏角
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
        }
    }
    
    func stopMotionUpdates() {
        print("🛑 Stopping motion updates...")
        motionManager.stopDeviceMotionUpdates()
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopMagnetometerUpdates()
        locationManager.stopUpdatingHeading()
        
        isMotionActive = false
    }
    
    // MARK: - 便捷方法
    
    /// 获取当前设备朝向（真北方向，0-360度）
    func getCurrentHeading() -> Double {
        return deviceHeading
    }
    
    /// 检查设备是否在移动
    func isDeviceMoving(threshold: Double = 0.1) -> Bool {
        let totalAcceleration = sqrt(
            pow(userAcceleration.x, 2) +
            pow(userAcceleration.y, 2) +
            pow(userAcceleration.z, 2)
        )
        return totalAcceleration > threshold
    }
    
    /// 获取设备倾斜角度
    func getDeviceTilt() -> (pitch: Double, roll: Double, yaw: Double) {
        guard let motion = motionData else {
            return (0, 0, 0)
        }
        
        return (
            pitch: motion.attitude.pitch * 180.0 / .pi,
            roll: motion.attitude.roll * 180.0 / .pi,
            yaw: motion.attitude.yaw * 180.0 / .pi
        )
    }
    
    deinit {
        stopMotionUpdates()
    }
}

// MARK: - CLLocationManagerDelegate
extension MotionManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            // 使用正确的属性名：magneticHeading 和 trueHeading 的差值就是磁偏角
            if newHeading.headingAccuracy > 0 {
                self.trueHeading = newHeading.trueHeading
                self.magneticHeading = newHeading.magneticHeading
                self.magneticDeclination = newHeading.trueHeading - newHeading.magneticHeading
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Heading update failed: \(error.localizedDescription)")
    }
} 