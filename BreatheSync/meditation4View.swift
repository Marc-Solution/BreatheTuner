//
//  meditation4View.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import SwiftUI



struct meditation4View: View {
    
   
    private let config = allMeditationConfigs[3]
    
   
    @StateObject private var player: MeditationPlayer
    
    init() {
        let config = allMeditationConfigs[3]
        
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
                        player.skip(seconds: -15)
                    } label: {
                        ControlCircle(symbol: "gobackward.15", color: buttonColor)
                    }

                    // 2. Play/Pause Button
                    Button {
                        player.togglePlayPause()
                    } label: {
                        Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 40))
                            .frame(width: 80, height: 80)
                            .background(buttonColor)
                            .foregroundStyle(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }

                    // 3. Fast Forward 15 Seconds Button
                    Button {
                        player.skip(seconds: 15)
                    } label: {
                        ControlCircle(symbol: "goforward.15", color: buttonColor)
                    }
                }
                
                //  Progress Bar and Timer
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
                                .frame(width: geometry.size.width * player.progress, height: 4)
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

#Preview {
    meditation4View()
}
