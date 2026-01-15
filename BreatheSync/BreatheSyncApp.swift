//
//  BreatheSyncApp.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import AVFoundation
import SwiftUI

@main
struct BreatheSync_iOSApp: App {
    
    init() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to set audio session category: \(error.localizedDescription)")
            }
        }
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
