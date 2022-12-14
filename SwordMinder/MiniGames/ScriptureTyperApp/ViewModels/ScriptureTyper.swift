//
//  ScriptureTyper.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/8/22.
//

import Foundation


class ScriptureTyper: ObservableObject {
    @Published var mode: ScriptureTyperMode = .stopped
    var secondsElapsed = 120.0
    var timer = Timer()
    
    func start(){
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed - 0.1
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
}
