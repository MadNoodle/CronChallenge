//
//  main.swift
//  CronParserChallenge
//
//  Created by Mathieu Janneau on 15/05/2022.
//

import Foundation

let simulatedTime = CommandLine.arguments[1]

while let input = readLine() {
  let taskComponents = input.components(separatedBy: .whitespaces)
  let scheduler = Scheduler(spanMinutes: taskComponents[0], hour: taskComponents[1], simulatedTimeString: simulatedTime)
  let nextExcecutionTime = try scheduler.getNextExecutionTime()
  let cronParser = CronParser(nextExecutionTime: nextExcecutionTime, task: taskComponents[2])
  print(cronParser.parse())
  
}

