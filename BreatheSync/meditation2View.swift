//
//  meditation2View.swift
//  BreatheSync
//
//  Created by Marco Deb on 2025-12-06.
//

import SwiftUI



struct meditation2View: View {
    
    // 1. Configuration: Get the data for Box Breathing 6-2-8-0
    private let config = allMeditationConfigs[1]
    
   
    @StateObject private var player: MeditationPlayer
    
    init() {
        let config = allMeditationConfigs[1]
        
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
            
         
            VStack(spacing: 40) {
                HStack(spacing: 30) {
                    
                    
                    Button {
                        player.skip(seconds: -15)
                    } label: {
                        ControlCircle(symbol: "gobackward.15", color: buttonColor)
                    }

                    
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

                    
                    Button {
                        player.skip(seconds: 15)
                    } label: {
                        ControlCircle(symbol: "goforward.15", color: buttonColor)
                    }
                }
                
                
                VStack(spacing: 10) {
                    
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            
                            Rectangle()
                                .frame(width: geometry.size.width, height: 4)
                                .foregroundStyle(buttonColor.opacity(0.3))
                            
                            
                            Rectangle()
                                .frame(width: geometry.size.width * player.progress, height: 4)
                                .foregroundStyle(buttonColor)
                                .animation(.linear(duration: 0.1), value: player.progress)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 30)
                    
                    
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
    meditation2View()
}
