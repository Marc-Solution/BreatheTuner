//
//  MeditationConfig.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import Foundation

// A model to hold the unique data for each meditation session
struct MeditationConfig: Identifiable {
    let id = UUID()
    let name: String
    let inhaleDuration: Int
    let hold1Duration: Int // Hold after Inhale
    let exhaleDuration: Int
    let hold2Duration: Int // Hold after Exhale (can be 0 if not used)
    let totalDurationSeconds: Double
    let audioFileName: String
    
    // Computed property for the breathing pattern display (e.g., "4-4-4-4")
    var patternString: String {
        // Only show holds if they are greater than 0
        var pattern = "\(inhaleDuration)"
        if hold1Duration > 0 {
            pattern += "-\(hold1Duration)"
        }
        pattern += "-\(exhaleDuration)"
        if hold2Duration > 0 {
            pattern += "-\(hold2Duration)"
        }
        // Correcting the pattern string to match the desired 4-4-4-4 format exactly, even if holds are 0
        return "\(inhaleDuration)-\(hold1Duration)-\(exhaleDuration)-\(hold2Duration)"
    }
}

// Global array containing the configuration for all four views
let allMeditationConfigs: [MeditationConfig] = [
    MeditationConfig(
        name: "Box Breathing",
        inhaleDuration: 4,
        hold1Duration: 4,
        exhaleDuration: 4,
        hold2Duration: 4,
        totalDurationSeconds: 232, // 3 minutes 52 seconds (3*60 + 52)
        audioFileName: "BreathingBox-4-4-4-4"
    ),
    MeditationConfig(
        name: "Box Breathing",
        inhaleDuration: 6,
        hold1Duration: 2,
        exhaleDuration: 8,
        hold2Duration: 0, // No second hold
        totalDurationSeconds: 248, // 04:08 minutes
        audioFileName: "BreathingBox-6-2-8"
    ),
    MeditationConfig(
        name: "Flow Breathing",
        inhaleDuration: 5,
        hold1Duration: 0,
        exhaleDuration: 6,
        hold2Duration: 0,
        totalDurationSeconds: 248, // 04:08 minutes
        audioFileName: "BoxBreathing-5-6"
    ),
    MeditationConfig(
        name: "Flow Breathing",
        inhaleDuration: 6,
        hold1Duration: 0,
        exhaleDuration: 8,
        hold2Duration: 0,
        totalDurationSeconds: 248, // 04:08 minutes
        audioFileName: "BoxBreathing-6-8"
    )
]

