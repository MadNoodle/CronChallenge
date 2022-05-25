//
//  Scheduler.swift
//  CronParserChallenge
//
//  Created by Mathieu Janneau on 24/05/2022.
//
import Foundation

//  MARK: - ERROR MANAGEMENT
enum SchedulerError: Error {
    case invalidArgument
}

/// The scheduler is in charge of parsing and evaluating time components from an entry
struct Scheduler {
    
    let spanMinutes: String
    let hour: String
    
    /// input date formated HH:mm
    let simulatedTimeString: String
    
    /// Compute String to Date for simulatedTime
    var simulatedTime: Date {
      get throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let date = dateFormatter.date(from: simulatedTimeString) else {
          throw SchedulerError.invalidArgument
        }
        return date
      }
    }
    
    /// extract the next execution hour
    func getNextExecutionTime() throws -> (hour:Int, minutes:Int, day: String) {
        // parse components
        let simulatedTimeComponents = try getSimulatedTimeComponents()
        // Parse minutes from components
        let nextExecutionMinutes = try evaluateSpanMinutes(simulatedMinutes: simulatedTimeComponents.minutes)
        
        // As crons runs periodically if next execution is less than minutes components then it will be execued next hour
        let shouldMoveToNextHour = nextExecutionMinutes < simulatedTimeComponents.minutes
        
        var nextExecutionHour = try evaluateHour(simulatedHour: simulatedTimeComponents.hour, shouldMoveToNextHour: shouldMoveToNextHour)
        
        // Handle midnight case
        if nextExecutionHour == 24 {
            nextExecutionHour = 0
        }
        
        // As crons runs periodically, we have to handle the case where it should be done the day after
        let shoulMoveToNextDay = nextExecutionHour < simulatedTimeComponents.hour ||
        (shouldMoveToNextHour && nextExecutionHour == simulatedTimeComponents.hour)
        
        let day = shoulMoveToNextDay ? "tomorrow" : "today"
        
        return (nextExecutionHour, nextExecutionMinutes, day)
    }
}

// MARK: - PARSING METHODS
private extension Scheduler {
    
    /// transform cron elements to date components
    func getSimulatedTimeComponents() throws -> (hour: Int, minutes: Int) {
        let calendar = Calendar.current
        let simulatedMinutes = try calendar.component(.minute, from: simulatedTime)
        let simulatedHour = try calendar.component(.hour, from: simulatedTime)
        return (simulatedHour, simulatedMinutes)
    }
    
    /// Parse the minutes scheduler
    func evaluateSpanMinutes(simulatedMinutes: Int) throws -> Int {
        // handle case where the cron runs under the hour span
        if spanMinutes == "*" {
            return simulatedMinutes
        }
        
        // handle invalid minutes formatting
        guard let spanMinutesInt = Int(spanMinutes),
              spanMinutesInt >= 0, spanMinutesInt < 60 else {
            throw SchedulerError.invalidArgument
        }
        
        return spanMinutesInt
    }
    
    /// Parse the hour scheduler
    func evaluateHour(simulatedHour: Int, shouldMoveToNextHour: Bool) throws -> Int {
        if hour == "*" {
            return simulatedHour + (shouldMoveToNextHour ? 1 : 0)
        }
        
        // Handle the case no hour or over one day
        guard let hourInt = Int(hour),
              hourInt >= 0, hourInt < 24 else {
            throw SchedulerError.invalidArgument
        }
        
        return hourInt
    }
}


