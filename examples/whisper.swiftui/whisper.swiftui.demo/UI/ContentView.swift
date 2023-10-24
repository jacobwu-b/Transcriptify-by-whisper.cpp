import SwiftUI
import AVFoundation

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
        Text(whisperState.transcript)
            .textSelection(.enabled)
            .padding()
            .navigationTitle("Transcript")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
