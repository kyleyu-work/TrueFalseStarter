//
//  ArithmeticQuestionsPool.swift
//  TrueFalseStarter
//
//  Created by Yi YU on 9/20/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import GameplayKit


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
  func getRandomQuestion() -> Question? {
    let maxOperend = 100
    let gkRandomSource = GKRandomSource.sharedRandom()
    var questionDesc: String
    
    repeat {
      let operend1 = gkRandomSource.nextInt(upperBound: maxOperend)
      let operend2 = gkRandomSource.nextInt(upperBound: maxOperend)
      let opIndex = gkRandomSource.nextInt(upperBound: 3)
      let op: String
      let solution: Int
      switch opIndex {
      case 0:
        // Do addition
        solution = operend1 + operend2
        op = "+"
        break
      case 1:
        // Do subtraction
        solution = operend1 - operend2
        op = "-"
        break
      case 2:
        // Do multiplication
        solution = operend1 * operend2
        op = "*"
        break
      default:
        solution = 0
        op = ""
        break
      }
      
      questionDesc = "\(operend1) \(op) \(operend2) ="
      
      // Either 3 choice or 4 choice problem
      let choiceNum = gkRandomSource.nextInt(upperBound: 2) + 3
      var choices: [String] = ["\(solution)"]
      
      // Only generate wrong choice options within [solution - 10, soluton + 10]
      let wrongAnswerRange = 10
      let gkRandomDistribution = GKRandomDistribution(
        lowestValue: solution - wrongAnswerRange,
        highestValue: solution + wrongAnswerRange)
      
      for _ in 0..<choiceNum - 1 {
        var possibleChoice: String
        repeat {
          possibleChoice = "\(gkRandomDistribution.nextInt())"
        } while choices.contains(possibleChoice)
        choices.append(possibleChoice)
      }
      
      // Schuffle the choice options
      choices = gkRandomSource.arrayByShufflingObjects(in: choices) as! [String]
      var solutionIndex = 0
      for k in 0..<choiceNum {
        if choices[k] == "\(solution)" {
          solutionIndex = k
        }
      }
      
      selectedQuestion = Question(questionDesc, choices, solutionIndex)
    } while askedQuestionsSet.contains(questionDesc)
    
    askedQuestionsSet.insert(questionDesc)
    return selectedQuestion
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
