//
//  MeditationPlayer.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

/**
 * MeditationPlayer is an ObservableObject that manages the state, timing,
 * and playback progress for a single meditation session using AVAudioPlayer.
 */
class MeditationPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    // MARK: - Published State Properties
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0.0
    @Published var progress: Double = 0.0 // Value from 0.0 (start) to 1.0 (end)
    
    // MARK: - Internal Properties
    
    private var progressTimer: AnyCancellable?
    private var audioPlayer: AVAudioPlayer?
    
    private let config: MeditationConfig
    private var totalDuration: Double = 0.0 // This will hold the duration from config/audio file
    
    // MARK: - Initialization
    
    init(config: MeditationConfig) {
        self.config = config
        super.init()
        // We initially set the duration from the config
        self.totalDuration = config.totalDurationSeconds
        
        // Load and set up the audio file
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        // Look for the mp3 file in the main app bundle
        guard let url = Bundle.main.url(forResource: config.audioFileName, withExtension: "mp3") else {
            print("Error: Audio file not found for \(config.audioFileName).mp3")
            // If audio isn't found, we fall back to the duration specified in the config
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self // Set the delegate to handle completion
            audioPlayer?.prepareToPlay()
            
            // Set the final total duration based on what the audio player reports
            self.totalDuration = audioPlayer?.duration ?? config.totalDurationSeconds
            
        } catch {
            print("Error loading or initializing audio player: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Control Methods
    
    /** Toggles between play and pause states. */
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    /** Starts or resumes the meditation session. */
    func play() {
        guard !isPlaying else { return }
        
        if audioPlayer?.play() == true {
            isPlaying = true
            startProgressTimer()
        } else {
            print("AVAudioPlayer failed to play.")
        }
    }
    
    /** Pauses the meditation session. */
    func pause() {
        isPlaying = false
        audioPlayer?.pause()
        progressTimer?.cancel() // Stop updating the UI
    }
    
    /** Stops the session and resets the time to zero. */
    func stop() {
        // Ensure pause is called first to cancel the timer
        pause()
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0 // Reset audio position
        
        // Reset published state properties
        currentTime = 0.0
        progress = 0.0
    }
    
    /** Skips forward or backward in the session. */
    func skip(seconds: Double) {
        guard let player = audioPlayer else { return }
        
        // Calculate new time, ensuring it stays within bounds [0, totalDuration]
        let newTime = player.currentTime + seconds
        let boundedTime = max(0, min(totalDuration, newTime))
        
        player.currentTime = TimeInterval(boundedTime)
        currentTime = boundedTime
        progress = currentTime / totalDuration
    }
    
    // MARK: - Progress Timer Logic (Checks the real audio time)
    
    private func startProgressTimer() {
        // Use a Combine timer to update currentTime and progress 10 times per second
        progressTimer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let player = self.audioPlayer else { return }
                
                // Update published properties from the real audio player
                self.currentTime = player.currentTime
                
                // Only update progress if duration is valid
                if self.totalDuration > 0 {
                    self.progress = min(1.0, self.currentTime / self.totalDuration)
                }
            }
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    // Called automatically when the audio file reaches the end
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.stop() // Reset the session after successful completion
        }
    }
    
    // MARK: - Helper Methods
    
    /** Formats a time in seconds into MM:SS string format. */
    func formattedTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // Allows the view to easily access the total duration string
    var formattedTotalDuration: String {
        formattedTime(totalDuration)
    }
}
