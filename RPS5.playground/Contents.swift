//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit

var str = "Hello, playground"

/*
 The program should take as input one of the five choices (rock, paper, scissors, lizard, or spock), pick one at random for the computer to play, and pick a winner. Example output:

Spock smashes scissors and vaporizes rock;
 he is poisoned by lizard and disproven by paper.
 Lizard poisons Spock and eats paper;
 it is crushed by rock and decapitated by scissors.
 
your move: paper
I played: spock
paper disproves spock, you win!
 */

let viewController = RPS5ViewController()
PlaygroundPage.current.liveView = viewController.view

