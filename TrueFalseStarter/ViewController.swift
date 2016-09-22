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
  fileprivate let timeAllowedPerQuestion = 15

  fileprivate var questionPool: QuestionPool?
  fileprivate var questionsAsked = 0
  fileprivate var correctQuestions = 0
  fileprivate var gameSound: SystemSoundID = 0
  fileprivate var correctAnswerSound: SystemSoundID = 0
  fileprivate var wrongAnswerSound: SystemSoundID = 0
  fileprivate var questionTimer: Timer?
  fileprivate var timeLeft = 0
  
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var questionField: UILabel!
  @IBOutlet var answerButtons: [UIButton]!
  @IBOutlet weak var gameModeSelectButtonContainer: UIStackView!
  @IBOutlet weak var playAgainButton: UIButton!

  override func viewDidLoad() {
      super.viewDidLoad()
      loadGameStartSound()
      loadCorrectAnswerSound()
      loadWrongAnswerSound()
    
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
    // Hide the timer label
    timerLabel.isHidden = true
    
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
      // Show and reset timer
      timerLabel.isHidden = false
      timeLeft = timeAllowedPerQuestion
      timerLabel.text = "Time left: \(timeLeft)"
      timerLabel.textColor = UIColor.yellow
      questionTimer = Timer.scheduledTimer(
        timeInterval: 1,
        target: self,
        selector: #selector(updateCounter),
        userInfo: nil,
        repeats: true)
      
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
    
    // Hide timer
    timerLabel.isHidden = true
    
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
    // Stop timer
    questionTimer!.invalidate()
    
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
      AudioServicesPlaySystemSound(correctAnswerSound)
    } else {
      questionField.text = "Sorry, wrong answer!"
      AudioServicesPlaySystemSound(wrongAnswerSound)
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
   * Update the time counter.
   */
  func updateCounter() {
    timeLeft -= 1
    timerLabel.text = "Time left: \(timeLeft)"
    if timeLeft == 0 {
      quitAnsweringQuestion()
    } else if timeLeft < timeAllowedPerQuestion / 3 {
      timerLabel.textColor = UIColor.red
    }
  }
  
  
  /**
   * Quit answering question within time limit.
   */
  fileprivate func quitAnsweringQuestion() {
    for answerButton in answerButtons {
      if let answer = answerButton.currentTitle  {
        if questionPool!.checkAnswer(answer) {
          answerButton.setTitle(
            "✔︎   \(answerButton.currentTitle!)", for: UIControlState.disabled)
          answerButton.setTitleColor(
            UIColor.green, for: UIControlState.disabled)
        }
        answerButton.isEnabled = false
      }
    }
    questionsAsked += 1
    questionField.text = "Sorry, failed to answer within time limit"
    questionTimer?.invalidate()
    loadNextQuestionWithDelay(seconds: 2)
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
   * Load correct answer sound.
   */
  fileprivate func loadCorrectAnswerSound() {
    let pathToSoundFile =
      Bundle.main.path(forResource: "correct", ofType: "wav")
    let soundURL = URL(fileURLWithPath: pathToSoundFile!)
    AudioServicesCreateSystemSoundID(soundURL as CFURL, &correctAnswerSound)
  }
  
  
  /**
   * Load wrong answer sound.
   */
  fileprivate func loadWrongAnswerSound() {
    let pathToSoundFile =
      Bundle.main.path(forResource: "wrong", ofType: "wav")
    let soundURL = URL(fileURLWithPath: pathToSoundFile!)
    AudioServicesCreateSystemSoundID(soundURL as CFURL, &wrongAnswerSound)
  }


  /**
   * Play game start sound.
   */
  fileprivate func playGameStartSound() {
      AudioServicesPlaySystemSound(gameSound)
  }
}

