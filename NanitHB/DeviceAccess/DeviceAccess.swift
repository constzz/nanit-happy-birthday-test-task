//
//  DeviceAccess.swift
//  NanitHB
//
//  Created by Konstantin Bezzemelnyi on 20.09.2025.
//

import AVFoundation
import CoreLocation
import Foundation
import UserNotifications
import PhotosUI

enum DeviceAccess {}

extension DeviceAccess {
    enum Microphone {
        @discardableResult
        static func isGranted(shouldAskIfNotDetermined: Bool) -> Bool {
            switch AVAudioApplication.shared.recordPermission {
            case .granted:
                return true
            case .denied:
                return false
            case .undetermined:
                guard shouldAskIfNotDetermined else { return false }
                let group = DispatchGroup()
                var granted: Bool = false
                group.enter()
                AVAudioApplication.requestRecordPermission {
                    granted = $0
                    group.leave()
                }
                group.wait()
                return granted
            @unknown default:
                Logger.error("Unknown case")
                return false
            }
        }
    }
}

extension DeviceAccess {
    enum VideoRecording {
        @discardableResult
        static func isGranted(shouldAskIfNotDetermined: Bool) -> Bool {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                return true
            case .notDetermined:
                guard shouldAskIfNotDetermined else { return false }
                let group = DispatchGroup()
                var granted: Bool = false
                group.enter()
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {
                    granted = $0
                    group.leave()
                })
                group.wait()
                return granted
            case .restricted, .denied:
                return false
            @unknown default:
                Logger.error("Unknown case")
                return false
            }
        }
    }
}

extension DeviceAccess {
    enum Notifications {
        @discardableResult
        static func isGranted(shouldAskIfNotDetermined: Bool) -> Bool {
            let center = UNUserNotificationCenter.current()
            
            let group = DispatchGroup()
            var granted = false
            group.enter()
            
            center.getNotificationSettings { settings in
                
                switch settings.authorizationStatus {
                case .authorized:
                    granted = true
                    group.leave()
                case .denied:
                    granted = false
                    group.leave()
                default:
                    guard shouldAskIfNotDetermined else {
                        granted = false
                        return group.leave()
                    }
                    center.requestAuthorization(options: [.sound, .alert, .badge]) { isGranted, _ in
                        granted = isGranted
                        group.leave()
                    }
                }
            }
            
            group.wait()
            
            return granted
        }
    }
}

extension DeviceAccess {
    enum Location {
        
        static func requestWhenInUseAuthorization() {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        
        @discardableResult
        static func isGranted() -> Bool {
            switch CLLocationManager().authorizationStatus {
                
            case .authorizedAlways, .authorizedWhenInUse:
                return true
                
            case .denied, .restricted:
                return false
                
            case .notDetermined:
                return false
                
            @unknown default:
                Logger.error("Unknown case")
                return false
            }
        }
    }
}

extension DeviceAccess {
    enum PhotoLibrary {
        @discardableResult
        static func isGranted(shouldAskIfNotDetermined: Bool) -> Bool {
            let accessLevel = PHAccessLevel.readWrite
            switch PHPhotoLibrary.authorizationStatus(for: accessLevel) {
            case .authorized:
                return true
            case .notDetermined:
                guard shouldAskIfNotDetermined else { return false }
                PHPhotoLibrary.requestAuthorization(for: accessLevel, handler: { _ in })
                return true
            case .limited:
                return true
            case .denied, .restricted:
                return false
            @unknown default:
                Logger.error("Unknown case")
                return false
            }
        }
    }
}
