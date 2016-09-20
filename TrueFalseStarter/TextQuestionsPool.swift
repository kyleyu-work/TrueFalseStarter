//
//  TextQuestionsPool.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
import GameKit


class TextQuestionsPool: QuestionPool {
  fileprivate let questionsPool: [Question]
  
  fileprivate var selectedQuestionIndex: Int
  
  var askedQuestionsSet: Set<String>
  
  
  init() {
    // Questions for test
    let q1 = Question("Only female koalas can whistle", ["True", "False"], 1)
    let q2 = Question("Blue whales are technically whales", ["True", "False"], 0)
    let q3 = Question("Camels are cannibalistic", ["True", "False"], 1)
    let q4 = Question("All ducks are birds", ["True", "False"], 0)
    self.questionsPool = [q1, q2, q3, q4]
    
    self.selectedQuestionIndex = 0
    askedQuestionsSet = Set<String>()
  }
  
  
  /**
   * Returns a random text question.
   */
  func getRandomQuestion() -> String? {
    // If all questions are asked, return nil
    if askedQuestionsSet.count == questionsPool.count {
      return nil
    }
    
    // Keep select random question until that question is not asked.
    repeat {
      selectedQuestionIndex =
          GKRandomSource.sharedRandom().nextInt(upperBound: questionsPool.count)
    } while isQuestionAsked(questionsPool[selectedQuestionIndex])
    
    let selectedQuestionDesc =
      questionsPool[selectedQuestionIndex].getQuestionDescription()
    
    askedQuestionsSet.insert(selectedQuestionDesc)
    
    return selectedQuestionDesc
  }
  
  
  /**
   * Checks the whether user's answer is correct.
   */
  func checkAnswer(_ userAnswer: String) -> Bool {
    return questionsPool[selectedQuestionIndex].checkAnswer(userAnswer)
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
