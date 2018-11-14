//
//  SoundManager.swift
//  TVTank
//
//  Created by Oliver Klemenz on 24.04.16.
//  Copyright © 2016 Klemenz, Oliver. All rights reserved.
//

import Foundation
import AVFoundation

func createMenuMusic() -> SoundManager {
    return SoundManager(soundFile: "dark_desert_2", fileExtension: "mp3", usePitch: false, loop: true)
}

func createLevelMusic() -> SoundManager {
    return SoundManager(soundFile: "dark_desert", fileExtension: "mp3", usePitch: false, loop: true)
}

func createTankMoveSound() -> SoundManager {
    return SoundManager(soundFile: "tank_move", fileExtension: "caf", volume : 3, usePitch: true, loop: true)
}

func createTankGunMoveSound() -> SoundManager {
    return SoundManager(soundFile: "gun_move", fileExtension: "caf", volume : 5, usePitch: true, loop: true)
}

class SoundManager : NSObject, AVAudioPlayerDelegate {

    var engine : AVAudioEngine!
    var playerNode : AVAudioPlayerNode!
    var mixer : AVAudioMixerNode!
    var buffer : AVAudioPCMBuffer!
    var pitch : AVAudioUnitTimePitch?
    
    init(soundFile : String, fileExtension : String, volume : Float = 1.0, usePitch : Bool = false, loop : Bool = true) {
        super.init()
        
        guard let fileURL = Bundle.main.url(forResource: soundFile, withExtension: fileExtension) else {
            print("Could not read sound file")
            return
        }
        
        do {
            let file = try AVAudioFile(forReading: fileURL)
            buffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat, frameCapacity: AVAudioFrameCount(file.length))
            try file.read(into: buffer)
        } catch {
            print("Could not create AVAudioPCMBuffer \(error)")
            return
        }
        
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        playerNode.volume = volume
        engine.attach(playerNode)
        mixer = engine.mainMixerNode
        
        if usePitch {
            pitch = AVAudioUnitTimePitch()
            engine.attach(pitch!)
            engine.connect(playerNode, to: pitch!, format: buffer.format)
            engine.connect(pitch!, to: mixer, format: buffer.format)
        } else {
            engine.connect(playerNode, to: mixer, format: buffer.format)
        }
        
        if loop {
            playerNode.scheduleBuffer(buffer, at: nil,
                                      options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: finishedPlaying)
        } else {
            playerNode.scheduleBuffer(buffer, completionHandler: finishedPlaying)
        }
        
        do {
            try engine.start()
        } catch {
            print("Could not start audio engine")
        }
    }
    
    func startEngine() {
        if engine.isRunning {
            print("audio engine already started")
            return
        }
        
        do {
            try engine.start()
            print("audio engine started")
        } catch {
            print("oops \(error)")
            print("could not start audio engine")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    func finishedPlaying() {
        playerNode.stop()
    }
    
    func play() {
        if !playerNode.isPlaying {
            playerNode.play()
        }
    }
    
    func pause() {
        if playerNode.isPlaying {
            playerNode.pause()
        }
    }
    
    func stop() {
        if playerNode.isPlaying {
            playerNode.stop()
        }
    }
    
    func adjustPitch(_ pitchValue : Float) {
        if let pitch = pitch {
            pitch.pitch = pitchValue
        }
    }
    
    func adjustPitchRate(_ pitchRateValue : Float) {
        if let pitch = pitch {
            pitch.rate = pitchRateValue
        }
    }
    
    func adjustVolume(_ volumeValue : Float) {
        playerNode.volume = volumeValue
    }
}
