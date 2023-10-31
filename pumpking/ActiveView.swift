import SwiftUI
import AVFoundation
import Combine

struct ActiveView: View {
    @State private var statusMessage: String = "Playing Intro..."
    @ObservedObject private var playbackManager = PlaybackManager()
    @ObservedObject private var audioRecorder = AudioRecorder()
    private var cancellables = Set<AnyCancellable>()
    @ObservedObject private var openAI = OpenAI()
    @ObservedObject private var voiceSynthesizer = VoiceSynthesizer()
    @State private var shouldReturnToIdle = false
    @State private var hasRecorded = false
    var returnToIdle: () -> Void
    public init(returnToIdle: @escaping () -> Void) {
            self.returnToIdle = returnToIdle
        }
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea(.all)
            VStack(spacing: 20) {
                Image("PumpkingLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()

                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.orange)
                
                Text(statusMessage)
                    .font(.headline)
                    .padding()
            }
            .onAppear(perform: setup)
            .onReceive(playbackManager.playbackFinished) {
                if shouldReturnToIdle {
                    shouldReturnToIdle = false
                    // Switch to idle after a delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.returnToIdle()
                    }
                }
                else{
                    if(!hasRecorded){
                        hasRecorded = true
                        self.statusMessage = "Listening..."
                        self.audioRecorder.startRecording()
                    }
                }
            }
            .onReceive(audioRecorder.recordingStopped) { audioFileURL in
                self.statusMessage = "Uploading..."
                self.handleRecordedAudio(fileURL: audioFileURL)
                playRandomWaitSound()
                
            }
            .onReceive(voiceSynthesizer.$audioData) { data in
                self.statusMessage = "The Pumpkin King is responding..."
                playbackManager.play(data: data)
                
            }
            .onDisappear {
                self.audioRecorder.stopRecording()
                self.playbackManager.player?.stop()
            }
        }
    }
    
    
    
    func setup() {
        playRandomIntro()
    }
    
    func playRandomIntro() {
        let randomIntroNumber = Int.random(in: 1...3)
        let introFilename = "intro_\(String(format: "%02d", randomIntroNumber))"
        if let url = Bundle.main.url(forResource: introFilename, withExtension: "mp3") {
            playbackManager.play(url: url)
            statusMessage = "Playing intro..."
        }
    }
    func handleRecordedAudio(fileURL: URL) {
        self.statusMessage = "Uploading for transcription..."
        openAI.uploadAudioToWhisper(audioURL: fileURL) { result in
            switch result {
            case .success(let transcriptionResponse):
                if let data = transcriptionResponse.data(using: .utf8), let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], let text = jsonObject["text"] as? String {
                    self.statusMessage = "Transcription received. Processing..."
                    self.openAI.requestChatCompletion(transcription: text) { chatCompletionResult in
                        switch chatCompletionResult {
                        case .success(let chatResponse):
                            self.statusMessage = "Generating Audio (could take a few seconds)..."
                            self.voiceSynthesizer.synthesize(text: chatResponse)
                            
                        case .failure(let error):
                            self.statusMessage = "Error in chat completion: \(error.localizedDescription)"
                        }
                        shouldReturnToIdle = true
                    }
                } else {
                    self.statusMessage = "Failed to get transcription."
                }
            case .failure(let error):
                self.statusMessage = "Error uploading audio: \(error.localizedDescription)"
            }
        }
    }
    func playRandomWaitSound() {
            let randomWaitNumber = Int.random(in: 1...5) // Assuming you have 3 wait sounds
            let waitFilename = "wait_\(String(format: "%02d", randomWaitNumber))"
            if let url = Bundle.main.url(forResource: waitFilename, withExtension: "mp3") {
                playbackManager.play(url: url)
                statusMessage = "Playing wait sound..."
            }
        }
}
