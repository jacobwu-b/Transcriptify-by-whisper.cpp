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
//                HStack {
//                    Button("Transcribe Sample Audio File", action: {
//                        Task {
//                            await whisperState.transcribeSample()
//                        }
//                    })
//                    .buttonStyle(.bordered)
//                    .disabled(!whisperState.canTranscribe)
                    
                    Button(whisperState.isRecording ? "Stop recording" : "Start recording", action: {
                        Task {
                            await whisperState.toggleRecord()
                        }
                    })
                    .buttonStyle(.bordered)
                    .disabled(!whisperState.canTranscribe)
//                }
                
//                ScrollView {
//                    Text(verbatim: whisperState.transcript)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
                
                NavigationLink(destination: TranscriptView(whisperState: whisperState),
                                               isActive: Binding(get: { self.cannotTranscribe }, set: { _ in })) {
                                    EmptyView()
                                }
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
            .padding()
            .navigationTitle("Transcript")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
