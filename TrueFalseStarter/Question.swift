//
//  Question.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

struct Question {
  fileprivate let description: String
  fileprivate let choices: [String]
  fileprivate let solutionIndex: Int

  
  init(_ description: String, _ choices: [String], _ solutionIndex: Int) {
    self.description = description
    self.choices = choices
    self.solutionIndex = solutionIndex
  }
  
  
  func getQuestionDescription() -> String {
    return description
  }
  
  
  func getQuestionChoices() -> [String] {
    return choices
  }
  
  
  func checkAnswer(_ answer: String) -> Bool {
    return answer == choices[solutionIndex]
  }
}
