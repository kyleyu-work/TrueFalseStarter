//
//  QuestionsModel.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

protocol QuestionPool {
  var askedQuestionsSet: Set<String> { get set }
  
  
  /**
   * Returns a random question.
   */
  func getRandomQuestion() -> String?
  
  
  /**
   * Checks whether the user's answer for the currently selected is correct.
   */
  func checkAnswer(_ userAnswer: String) -> Bool
  
  
  /**
   * Checks whether a question has been asked.
   * We consider problems with different description as different questions for
   * convenience.
   */
  func isQuestionAsked(_ question: Question) -> Bool
  
  
  /**
   * Reset all asked questions.
   */
  func resetAskedQuestions()
}
