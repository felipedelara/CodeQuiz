//
//  Other.swift
//  Code Quiz
//
//  Created by Felipe Ramon de Lara on 11/08/19.
//  Copyright © 2019 Felipe de Lara. All rights reserved.
//

import Foundation

class TimeFormat {
    static func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
