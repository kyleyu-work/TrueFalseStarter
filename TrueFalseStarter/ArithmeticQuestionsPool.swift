//
//  ArithmeticQuestionsPool.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/20/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameKit


class ArithmeticQuestionsPool: QuestionPool {
  var selectedQuestion: Question?
  var askedQuestionsSet: Set<String>
  
  
  init() {
    selectedQuestion = nil
    askedQuestionsSet = Set<String>()
  }
  
  
  /**
   * Returns a random arithmetic question.
   */
  func getRandomQuestion() -> String? {
    return nil
  }
  
  
  /**
   * Checks whether the user's answer for the currently selected is correct.
   */
  func checkAnswer(_ userAnswer: String) -> Bool {
    return selectedQuestion!.checkAnswer(userAnswer)
  }
  
  
  /**
   * Checks whether a question has been asked.
   * We consider problems with different description as different questions for
   * convenience.
   */
  func isQuestionAsked(_ question: Question) -> Bool {
    return askedQuestionsSet.contains(question.getQuestionDescription())
  }
  
  
  /**
   * Reset all asked questions.
   */
  func resetAskedQuestions() {
    askedQuestionsSet.removeAll()
  }
}
