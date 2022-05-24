//
//  main.swift
//  CronParserChallenge
//
//  Created by Mathieu Janneau on 15/05/2022.
//

import Foundation


while let input = readLine() {
    let taskComponents = input.components(separatedBy: .whitespaces)
    let scheduler = Scheduler(spanMinutes: taskComponents[0], hour: taskComponents[1])
    let nextExcecutionTime = try scheduler.getNextExecutionTime()
    let cronParser = CronParser(nextExecutionTime: nextExcecutionTime, task: taskComponents[2])
    print("INPUT: \n", cronParser.parse())
    print("Next Execution wil be in :", nextExcecutionTime)
}

