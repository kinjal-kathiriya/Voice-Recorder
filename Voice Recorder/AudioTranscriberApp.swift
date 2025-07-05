//
//  AudioTranscriberApp.swift
//  Voice Recorder
//
//  Created by kinjal kathiriya  on 7/5/25.
//  Copyright © 2025 Pinlun. All rights reserved.
//


import SwiftUI
import SwiftData

@main
struct AudioTranscriberApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [RecordingSessionModel.self, TranscriptionSegmentModel.self])
    }
}