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
  
    fileprivate let questionPool = QuestionPool()
    fileprivate let questionsPerRound = 4
  
    fileprivate var questionsAsked = 0
    fileprivate var correctQuestions = 0
    fileprivate var gameSound: SystemSoundID = 0
  
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
      
        // Start game
        playGameStartSound()
        displayNextQuestionOrScore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        questionField.text = questionPool.getRandomQuestion()
        playAgainButton.isHidden = true
    }
  
  
    /**
     * Display score stats.
     */
    fileprivate func displayScore() {
        // Hide the answer buttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text =
            "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
  
  
    /**
     * Check whether user's answer is correct.
     */
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
      
        if questionPool.checkAnswer(getUserAnswer(sender)) {
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
      // Show the answer buttons
      trueButton.isHidden = false
      falseButton.isHidden = false
      
      resetGameStats()
      displayNextQuestionOrScore()
    }

  
    /**
     * Return a String version of user answer based on the button user
     * pressed.
     */
    fileprivate func getUserAnswer(_ sender: UIButton) -> String {
      if (sender == trueButton) {
        return "True"
      } else if (sender == falseButton) {
        return "False"
      } else {
        return "Unrecognized answer"
      }
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

