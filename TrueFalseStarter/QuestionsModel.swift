//
//  QuestionsModel.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
import GameKit


class QuestionPool {
  fileprivate let questionPool: [[String : String]]
  
  fileprivate var indexOfSelectedQuestion: Int
  
  
  init() {
    questionPool = [
      ["Question": "Only female koalas can whistle", "Answer": "False"],
      ["Question": "Blue whales are technically whales", "Answer": "True"],
      ["Question": "Camels are cannibalistic", "Answer": "False"],
      ["Question": "All ducks are birds", "Answer": "True"]
    ]
    
    indexOfSelectedQuestion = 0
  }
  
  
  /**
   * Returns a random question from the question pool.
   */
  func getRandomQuestion() -> String {
    indexOfSelectedQuestion =
        GKRandomSource.sharedRandom().nextInt(upperBound: questionPool.count)
    return questionPool[indexOfSelectedQuestion]["Question"]!
  }
  
  
  /**
   * Checks whether the user's answer for the currently selected is correct.
   */
  func checkAnswer(_ userAnswer: String) -> Bool {
    return userAnswer == questionPool[indexOfSelectedQuestion]["Answer"]!
  }
}
