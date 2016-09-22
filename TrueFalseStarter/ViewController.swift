//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
  
  fileprivate let questionsPerRound = 3

  fileprivate var questionPool: QuestionPool?
  fileprivate var questionsAsked = 0
  fileprivate var correctQuestions = 0
  fileprivate var gameSound: SystemSoundID = 0
  
  @IBOutlet weak var questionField: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  @IBOutlet weak var gameModeSelectButtonContainer: UIStackView!
  @IBOutlet weak var playAgainButton: UIButton!

  override func viewDidLoad() {
      super.viewDidLoad()
      loadGameStartSound()
    
      // Start game
      playGameStartSound()
      displayGameStartView()
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
  
  
  /**
   * Display game start view.
   */
  fileprivate func displayGameStartView() {
    // Hide answer choice buttons
    for answerButton in answerButtons {
      answerButton.isHidden = true
    }
    
    // Hide play again buttons.
    playAgainButton.isHidden = true
    
    // Show game mode select buttons.
    gameModeSelectButtonContainer.isHidden = false

    questionField.text = "Select question types to start the game."
  }


  /**
   * Display next question or score stats if users have finished a round.
   */
  fileprivate func displayNextQuestionOrScore() {
    if questionsAsked == questionsPerRound {
      // Game is over
      displayScore()
    } else {
      // Continue game
      displayQuestion()
    }
  }


  /**
   * Display a question.
   */
  fileprivate func displayQuestion() {
    // If cannot get a question from pool, means all questions are asked.
    if let selectedQuestion = questionPool!.getRandomQuestion() {
      questionField.text = selectedQuestion.getQuestionDescription()
      
      // Display the answer choice buttons for the question.
      var idx = 0
      for choice in selectedQuestion.getQuestionChoices() {
        answerButtons[idx].setTitle(choice, for: UIControlState.normal)
        answerButtons[idx].setTitle(choice, for: UIControlState.disabled)
        answerButtons[idx].setTitleColor(
            UIColor.white, for: UIControlState.normal)
        answerButtons[idx].setTitleColor(
            UIColor.white, for: UIControlState.disabled)
        answerButtons[idx].isEnabled = true
        answerButtons[idx].isHidden = false
        
        idx += 1
      }
      
      while idx < 4 {
        answerButtons[idx].isHidden = true
        idx += 1
      }
      
      // Hide the play Again button.
      playAgainButton.isHidden = true
      
      // Hide the game mode select buttons.
      gameModeSelectButtonContainer.isHidden = true
    } else {
      displayScore()
    }
  }


  /**
   * Display score stats.
   */
  fileprivate func displayScore() {
    // Hide the answer choice buttons.
    for answerButton in answerButtons {
      answerButton.isHidden = true
    }
    
    // Hide the game mode select buttons.
    gameModeSelectButtonContainer.isHidden = true
    
    // Show the play again button
    playAgainButton.isHidden = false
    
    questionField.text =
        "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
  }
  
  
  /**
   * Select knowledge questions game mode.
   */
  @IBAction func selectKnowledgeTestMode(_ sender: UIButton) {
    questionPool = TextQuestionsPool()
    displayNextQuestionOrScore()
  }


  /**
   * Select arithmetic questions game mode.
   */
  @IBAction func selectMathTestMode(_ sender: UIButton) {
    questionPool = ArithmeticQuestionsPool()
    displayNextQuestionOrScore()
  }
  
  
  /**
   * Check whether user's answer is correct.
   */
  @IBAction func checkAnswer(_ sender: UIButton) {
    // Increment the questions asked counter
    questionsAsked += 1
    let isCorrectAnswer = questionPool!.checkAnswer(sender.currentTitle!)
    for answerButton in answerButtons {
      if let answer = answerButton.currentTitle  {
        if questionPool!.checkAnswer(answer) {
          answerButton.setTitle(
            "✔︎   \(answerButton.currentTitle!)", for: UIControlState.disabled)
          answerButton.setTitleColor(
              UIColor.green, for: UIControlState.disabled)
        } else if answerButton === sender {
          answerButton.setTitle(
            "✘   \(answerButton.currentTitle!)", for: UIControlState.disabled)
          answerButton.setTitleColor(UIColor.red, for: UIControlState.disabled)
        }
        answerButton.isEnabled = false
      }
    }
    
    if isCorrectAnswer {
      correctQuestions += 1
      questionField.text = "Correct!"
    } else {
      questionField.text = "Sorry, wrong answer!"
    }
    
    loadNextQuestionWithDelay(seconds: 2)
  }


  /**
   * Start a new round after users pressed "Play Again" button.
   */
  @IBAction func playAgain() {
    resetGameStats()
    displayGameStartView()
  }


  /**
   * Reset the game stats.
   */
  fileprivate func resetGameStats() {
    questionsAsked = 0
    correctQuestions = 0
  }


  /**
   * Load next question after a certain delay.
   */
  fileprivate func loadNextQuestionWithDelay(seconds: Int) {
      // Converts a delay in seconds to nanoseconds as signed 64 bit integer
      let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
      // Calculates a time value to execute the method given current time and
      // delay
      let dispatchTime =
          DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
      
      // Executes the nextRound method at the dispatch time on the main queue
      DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
          self.displayNextQuestionOrScore()
      }
  }


  /**
   * Load game start sound.
   */
  fileprivate func loadGameStartSound() {
      let pathToSoundFile =
          Bundle.main.path(forResource: "GameSound", ofType: "wav")
      let soundURL = URL(fileURLWithPath: pathToSoundFile!)
      AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
  }


  /**
   * Play game start sound.
   */
  fileprivate func playGameStartSound() {
      AudioServicesPlaySystemSound(gameSound)
  }
}

