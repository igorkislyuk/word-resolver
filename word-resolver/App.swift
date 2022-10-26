//
//  App.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

enum Localization {
    static let welcome = "Welcome to Word Resolver!"
    static let programStart = "Start of program. Will be pick random word. Input your mask, please"
    static let end = "End of program"
    static let brokenProgram = "Program is broken. You won"

    static func current(word: String) -> String {
        "Word is \"\(currentWord)\""
    }

    static let invalid(input: String) -> String {
        "Your input is \(input). It's invalid"
    }

    static let won(word: String, iteration: Int) -> String {
        "Your word in \(word). Number of steps \(iteration)"
    }
}

private enum Constants {
    static let missed = "-"
    static let misplaced = "+"
    static let placed = "@"
    static let defaultWord = ""
    static let defaultCount = 5
}

struct App {
    let path: String
    let initialWords: [String]
    
    // todo
    // let initialUniqueWords: [String]

    // MARK: - Functions

    func run() throws {
        print(Localization.welcome)
        programLoop()
        print(Localization.end)
    }

    // MARK: - Private

    private var iteration = 0
    private var currentWords = [String]()
    private var currentWord = ""
    
    private var missedLetters = [Character]()
    private var placedLetters: [Int: Character] = [:]
    private var misplacedLetters = [Character]()

    private func programLoop() {    
        startGame()

        while let input = readLine() {
            let filteredInput = input.filter { 
                $0 == Constants.missed || $0 == Constants.misplaced || $0 == Constants.placed
            }
            
            if filteredInput.count == Constants.defaultCount {
                
                filteredInput.enumerated().forEach { index, character in
                    let wordLetter = Array(currentWord)[index]
                    
                    if character == Constants.missed {
                        missedLetters.append(wordLetter)
                    } else if character == Constants.misplaced {
                        misplacedLetters.append(wordLetter)
                    } else if character == Constants.placed {
                        placedLetters[index] = wordLetter
                    } else {
                        print(Localization.invalid(input: input))
                        exit(0)
                    }
                }

                filterWords()
                iteration += 1
                
                if currentWords.count == 1, let word = currentWords.first {
                    print(Localization.won(word: word, iteration: iteration))
                    startGame()
                } else {
                    suggestNew()
                }
            } else if input == "/start" {
                startGame()
            } else {
                print(Localization.invalid(input: input))
                exit(0)
            }
        }
    }
    
    private func startGame() {
        print(Localization.programStart)
        reset()
    }

    private func reset() {
        currentWords = initialWords
        missedLetters = []
        placedLetters = [:]
        misplacedLetters = []
        iteration = 0
        
        suggestNew()
    }

    private func suggestNew() {
        currentWord = currentWords.randomElement() ?? Constants.defaultWord
        print(Localization.current(word: currentWord))
        
        if currentWord.isEmpty {
            print(Localization.brokenProgram)
            exit(0)
        }
    }    

    private func filterWords() {
        // TODO: refactor in single chain
        currentWords = currentWords
            .filter { word in
                // не должен содержать ни буквы
                missedLetters.reduce(true) { $0 && !word.contains($1) }
            }

        currentWords = currentWords.filter { word in
            placedLetters.reduce(true) { partialResult, kv in
                partialResult && Array(word)[kv.0] == kv.1
            }
        }

        currentWords = currentWords.filter { word in
            let onlyMisplacedLetters = word.filter(misplacedLetters.contains(:))
            return onlyMisplacedLetters.count == misplacedLetters.count
        }

        misplacedLetters = []
    }
}
