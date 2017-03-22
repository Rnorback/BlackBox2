//
//  GreenBattery.swift
//  BB2
//
//  Created by Rob Norback on 2/20/17.
//  Copyright © 2017 Norback Solutions, LLC. All rights reserved.
//

import UIKit

class GreenBattery: Puzzle {
    var puzzleId: PuzzleId = .greenBattery
    var isSolved: Bool {
        return UserDefaults.standard.bool(forKey: puzzleId.rawValue)
    }
    var isGreen: Bool {
        return UIDevice.current.batteryState == .charging &&
            ProcessInfo.processInfo.isLowPowerModeEnabled == false
    }
    
    func checkForSuccess(value:Any? = nil) {
        if isGreen {
            NotificationCenter.default.post(
                name: Notification.Name(puzzleId.rawValue),
                object: nil
            )
            UserDefaults.standard.set(true, forKey: puzzleId.rawValue)
        }
    }
}
