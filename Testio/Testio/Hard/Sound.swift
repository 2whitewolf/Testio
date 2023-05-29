//
//  Sound.swift
//  Testio
//
//  Created by Bogdan Sevcenco on 28.05.2023.
//
import Foundation
import AVFoundation
import Speech
enum TestsType: CaseIterable {
    case earphones // Earphone
    case speaker // Earpiece speaker
    case speakers // Bottom speaker
    case microphone // Microphone
}
class Sound: NSObject, AVSpeechSynthesizerDelegate {
    typealias TestFinale = (Bool?, [Int]?) -> Void
    static let `default` = Sound()
    var testWord = "Hello"
    let session = AVAudioSession.sharedInstance()
    var volume: Float = 1.0
    var mute = false
    var voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages[0])
    var voices = AVSpeechSynthesisVoice.speechVoices()
    var delegate: SpeakerDelegate?
    var rate: Float = AVSpeechUtteranceDefaultSpeechRate
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: Locale.preferredLanguages[0]))
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private var currentSpeechIndex: Int = 0
    private(set) var currentCode: String!
    private var numbers: [Int] {
        var temp: [Int] = []
        (0..<4)
            .compactMap({ _ in return ()})
            .forEach { temp.append(.random(in: 0..<10)) }
        return temp
    }
    var isHeadphonesConnected: Bool {
        var temp = false
        let currentRoute = session.currentRoute
        if currentRoute.outputs.count != 0 {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSession.Port.headphones {
                    temp = true
                    break
                }
            }
        }
        return temp
    }
    let synthesizer = AVSpeechSynthesizer()
    override init() {
        super.init()
        synthesizer.delegate = self
        do {
            try session.setCategory(.playAndRecord)
            try session.setMode(.spokenAudio)
            try session.setActive(true)
        } catch {
            print(error)
        }
        print(voices.compactMap({$0.language}))
        setNotificationObservers()
    }
    deinit {
        removeObservers()
    }
    private func setNotificationObservers() {
        NotificationCenter.default.addObserver(forName: AVAudioSession.routeChangeNotification, object: session, queue: nil) { [weak self] not in
            guard let userInfo = not.userInfo,
                  let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                  let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
            }
            switch reason {
            case .newDeviceAvailable:
                let session = AVAudioSession.sharedInstance()
                for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.headphones {
                    self?.delegate?.headphones(connected: true)
                    break
                }
            case .oldDeviceUnavailable:
                if let previousRoute =
                    userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                    for output in previousRoute.outputs where output.portType == AVAudioSession.Port.headphones {
                        self?.delegate?.headphones(connected: false)
                        break
                    }
                }
            default: ()
            }
        }
    }
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: session)
    }
    func stop() {
        synthesizer.stopSpeaking(at: .word)
    }
    func pause() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    func `continue`() {
        synthesizer.continueSpeaking()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.speaker(speaker: self, didFinishSpeechString: utterance.speechString)
    }
    func speak(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.volume = mute ? 0.0 : volume
        utterance.voice = voice
        utterance.rate = rate
        synthesizer.speak(utterance)
    }
    func change(language: String) {
        self.voice = AVSpeechSynthesisVoice(language: language)
    }
    func test(type: TestsType, completion: TestFinale?) {
        switch type {
        case .earphones:
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try? session.setActive(true)
        case .speaker:
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
            try? session.setActive(true)
        case .speakers:
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try? session.setActive(true)
        case .microphone:
            ()
        }
        _test(type: type, completion: completion)
    }
    private func _test(type: TestsType = .speaker, completion: TestFinale?) {
        if type == .microphone {
            testMic(completion: completion)
            return
        }
        let numbers = self.numbers
        currentCode = numbers.reduce("", {$0 + "\($1)"})
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            if type == .earphones, !(self?.isHeadphonesConnected ?? false) {
                print(NSError(domain: "Headphones not connected", code: -1, userInfo: nil))
                timer.invalidate()
                self?.speak(text: "Headphones not connected")
                completion?(false, nil)
                return
            }
            if type != .earphones, (self?.isHeadphonesConnected ?? false) {
                print(NSError(domain: "Headphones still connected", code: -1, userInfo: nil))
                timer.invalidate()
                self?.speak(text: "Headphones still connected")
                completion?(false, nil)
                return
            }
            if let index = self?.currentSpeechIndex, index < 4 {
                self?.speak(text: "\(numbers[index])")
            }
            self?.currentSpeechIndex += 1
            if self?.currentSpeechIndex == 5 {
                self?.currentSpeechIndex = 0
                timer.invalidate()
                completion?(nil, numbers)
                self?.currentCode = nil
            }
        }
    }
    private func testMic(completion: TestFinale?) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            switch status {
            case .authorized:
                let node = self.audioEngine.inputNode
                let format = node.outputFormat(forBus: 0)
                node.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
                    self?.request.append(buffer)
                }
                self.audioEngine.prepare()
                do {
                    try self.audioEngine.start()
                } catch {
                    completion?(false, nil)
                    print(error)
                }
                guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: Locale.preferredLanguages[0])) else {
                    print("Error")
                    return }
                if !recognizer.isAvailable { return }
                self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.request) { [weak self] result, error in
                    guard let result = result, let self = self else {
                        print("Error")
                        return
                    }
                    let lastString = result.bestTranscription.formattedString.lowercased()
                    if lastString.contains(self.testWord.lowercased()) {
                        self.recognitionTask?.cancel()
                        completion?(true, nil)
                        print("Test work checked")
                    }
                }
                ()
            default:
                print("Shiet")
            }
        }
    }
}
protocol SpeakerDelegate {
    func speaker(speaker: Sound, didFinishSpeechString: String)
    func headphones(connected: Bool)
}
extension SpeakerDelegate {
    func speaker(speaker: Sound, didFinishSpeechString: String) {}
    func headphones(connected: Bool) {}
}

