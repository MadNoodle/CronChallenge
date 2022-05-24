//
//  CronParser.swift
//  CronParserChallenge
//
//  Created by Mathieu Janneau on 24/05/2022.
//

import Foundation

/// Simple struct to parse a cron format
struct CronParser {
    
    let nextExecutionTime:(hour: Int, minutes: Int, day: String)
    let task: String
    
    func parse() -> String {
        return "\(nextExecutionTime.hour):\(nextExecutionTime.minutes) \(nextExecutionTime.day) - \(task)"
    }
    
}
