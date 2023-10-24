import SwiftUI
import AVFoundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct ContentView: View {
    @StateObject var whisperState = WhisperState()
    
    // Computed property to negate isRecording
    private var cannotTranscribe: Bool {
        return !whisperState.canTranscribe
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Model Size", selection: $whisperState.selectedModelSize) {
                                    ForEach(ModelSize.allCases, id: \.self) { modelSize in
                                        Text(modelSize.displayName).tag(modelSize)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Button("Transcribe Sample Audio File", action: {
                        Task {
                            await whisperState.transcribeSample()
                        }
                    })
                    .buttonStyle(.bordered)
                    .padding()
                    .font(.largeTitle)
                    .disabled(!whisperState.canTranscribe)
                    
                    Spacer()
                    
                    Button("Get Sample Transcript", action: {
                            Task {
                                await whisperState.fillSampleTranscript()
                            }
                        })
                        .buttonStyle(.bordered)
                        .padding()
                        .font(.largeTitle)
                        .disabled(!whisperState.canTranscribe)
                
                    Spacer()
                
                    Button(whisperState.isRecording ? "Stop recording" : "Start recording", action: {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    })
                    .buttonStyle(.bordered)
                    .padding()
                    .font(.largeTitle)
                    .disabled(!whisperState.canTranscribe)
                }
                
                Spacer()
                
                NavigationLink(destination: TranscriptView(whisperState: whisperState),
                               isActive: $whisperState.isTranscriptViewActive) {
                    Text("View Transcript")
                                }
                               .disabled(!whisperState.canTranscribe)
            }
            .navigationTitle("Transcriptify")
            .padding()
        }
    }
}

struct TranscriptView: View {
    @ObservedObject var whisperState: WhisperState
    
    var body: some View {
//        Text(whisperState.transcript)
//            .textSelection(.enabled)
//            .padding()
//            .navigationTitle("Transcript")
        
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 5), spacing: 20) {
                ForEach(0..<whisperState.chunks.count, id: \.self) { index in
                    Button(action: {
                        // Copy the selected chunk to the clipboard
                        self.copyToClipboard(text: whisperState.chunks[index])
                    }) {
                        Text("Part \(index + 1)")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom, 10)
                }
//                Text(whisperState.transcript)
//                    .textSelection(.enabled)
//                    .padding()
//                    .navigationTitle("Transcript")
            }
        }.navigationTitle("Transcript Chunks")
    }
    func copyToClipboard(text: String) {
        #if os(macOS)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        #else
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
