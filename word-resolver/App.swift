//
//  App.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

private enum Constants {
    static let missed: Character = "-"
    static let misplaced: Character = "+"
    static let placed: Character = "@"
    static let defaultWord = ""
    static let defaultCount = 5
    static let debug = false
}

final class App {

    let path: String
    let initialWords: [String]

    init(path: String, initialWords: [String]) {
        self.path = path
        self.initialWords = initialWords
    }

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
    private var currentSuggestedWords = Set<String>()
    
    private var missedLetters = Set<Character>()
    private var placedLetters: [Int: Character] = [:]
    private var misplacedLetters = Set<Character>()

    private func programLoop() {    
        startGame()

        while let input = readLine() {
            let filteredInput = input.filter { 
                $0 == Constants.missed || $0 == Constants.misplaced || $0 == Constants.placed
            }
            
            if filteredInput.count == Constants.defaultCount {
                
                filteredInput.enumerated().forEach { index, character in
                    let letterIndex = currentWord.index(currentWord.startIndex, offsetBy: index)
                    let letter = currentWord[letterIndex]
                    
                    if character == Constants.missed {
                        missedLetters.insert(letter)
                    } else if character == Constants.misplaced {
                        misplacedLetters.insert(letter)
                    } else if character == Constants.placed {
                        placedLetters[index] = letter
                    } else {
                        print(Localization.invalid(input: input))
                        exit(0)
                    }
                }

                misplacedLetters.forEach { missedLetters.remove($0) }
                placedLetters.values.forEach { missedLetters.remove($0) }

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
        currentSuggestedWords.removeAll()
        missedLetters.removeAll()
        placedLetters.removeAll()
        misplacedLetters.removeAll()
        iteration = 0
        
        suggestNew()
    }

    private func suggestNew() {
        currentWord = currentWords.filter { !currentSuggestedWords.contains($0) }.randomElement() ?? Constants.defaultWord
        currentSuggestedWords.insert(currentWord)

        print(Localization.current(word: currentWord))

        if currentWord.isEmpty { // турка
            print(Localization.brokenProgram)
            exit(0)
        }
    }    

    private func filterWords() {
        if Constants.debug {
            print("Missed: " + missedLetters.debugDescription)
        }

        currentWords = currentWords
            .filter { word in
                missedLetters.reduce(true) { $0 && !word.contains($1) }
            }

        if Constants.debug {
            print("After missed: " + currentWords.joined(separator: " "))
        }

        currentWords = currentWords.filter { word in
            placedLetters.reduce(true) { partialResult, kv in
                partialResult && Array(word)[kv.0] == kv.1
            }
        }

        if Constants.debug {
            print("Placed: " + placedLetters.debugDescription)
            print("After placed: " + currentWords.joined(separator: " "))
        }

        currentWords = currentWords.filter { word in
            misplacedLetters.reduce(true) { $0 && word.contains($1) }
        }

        if Constants.debug {
            print("Misplaced: " + misplacedLetters.debugDescription)
            print("After misplaced: " + currentWords.joined(separator: " "))
        }

        misplacedLetters.removeAll()
    }
}
