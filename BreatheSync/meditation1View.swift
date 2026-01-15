//
//  meditation1View.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import SwiftUI

let backgroundColor = Color(hex: "E0F7FA")
let buttonColor = Color(hex: "00BBD3")

// NOTE: This file assumes the global constants (backgroundColor, buttonColor)
// and the allMeditationConfigs array are available from other files.

struct meditation1View: View {
    
    // 1. Configuration: Get the data for Box Breathing 4-4-4-4
    private let config = allMeditationConfigs[0]
    
    // 2. StateObject: Initialize and manage the MeditationPlayer lifecycle
    // This creates the single instance of the logic class for this view
    @StateObject private var player: MeditationPlayer
    
    // Custom initializer to set up the StateObject with the correct configuration
    init() {
        let config = allMeditationConfigs[0]
        // Initialize the player with the config data, ensuring setup runs once.
        self._player = StateObject(wrappedValue: MeditationPlayer(config: config))
    }
    
    var body: some View {
        
        VStack {
            
            Spacer().frame(height: 50)
            
            // MARK: - Breathing Pattern Display
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Breathing Pattern")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(buttonColor)
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity)
                
                // Display the pattern using data from the config
                Grid(alignment: .leading, horizontalSpacing: 20) {
                    GridRow {
                        Text("Inhale").foregroundStyle(buttonColor)
                        Text("-")
                        Text("\(config.inhaleDuration)")
                    }
                    .foregroundStyle(buttonColor)
                    if config.hold1Duration > 0 {
                        GridRow {
                            Text("Hold").foregroundStyle(buttonColor)
                            Text("-")
                            Text("\(config.hold1Duration)")
                        }
                        .foregroundStyle(buttonColor)
                    }
                    GridRow {
                        Text("Exhale").foregroundStyle(buttonColor)
                        Text("-")
                        Text("\(config.exhaleDuration)")
                    }
                    .foregroundStyle(buttonColor)
                    if config.hold2Duration > 0 {
                        GridRow {
                            Text("Hold").foregroundStyle(buttonColor)
                            Text("-")
                            Text("\(config.hold2Duration)")
                        }
                        .foregroundStyle(buttonColor)
                    }
                }
                .font(.title)
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 40)
            
            // MARK: - Control Buttons
            VStack(spacing: 40) {
                HStack(spacing: 30) {
                    
                    // 1. Rewind 15 Seconds Button
                    Button {
                        player.skip(seconds: -15) // Calls skip method on the player
                    } label: {
                        ControlCircle(symbol: "gobackward.15", color: buttonColor)
                    }

                    // 2. Play/Pause Button
                    Button {
                        player.togglePlayPause() // Toggles playback state
                    } label: {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill") // Dynamic icon
                            .font(.system(size: 40))
                            .frame(width: 80, height: 80)
                            .background(buttonColor)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }

                    // 3. Fast Forward 15 Seconds Button
                    Button {
                        player.skip(seconds: 15) // Calls skip method on the player
                    } label: {
                        ControlCircle(symbol: "goforward.15", color: buttonColor)
                    }
                }
                
                // MARK: - Progress Bar and Timer
                VStack(spacing: 10) {
                    
                    // The Progress Bar (Dynamic)
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            Rectangle()
                                .frame(width: geometry.size.width, height: 4)
                                .foregroundStyle(buttonColor.opacity(0.3))
                            
                            // Foreground progress
                            Rectangle()
                                .frame(width: geometry.size.width * player.progress, height: 4) // Bound to player.progress
                                .foregroundStyle(buttonColor)
                                .animation(.linear(duration: 0.1), value: player.progress)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 30)
                    
                    // Timer text (Dynamic)
                    Text("\(player.formattedTime(player.currentTime)) / \(player.formattedTotalDuration)")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 40)
            }
            
        }
        .background(backgroundColor.ignoresSafeArea(.all))
        .navigationTitle("\(config.name) \(config.patternString)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Reusable struct for the small control buttons
struct ControlCircle: View {
    let symbol: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 2)
                .frame(width: 60, height: 60)
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(color)
        }
    }
}

#Preview {
    meditation1View()
}
