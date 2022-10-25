//
//  App.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

private let greetings = "Start of program. Will be pick random word. Input your mask, please"

final class App {
    let path: String
    let initialWords: [String]

    init(path: String, initialWords: [String]) {
        self.path = path
        self.initialWords = initialWords
    }

    // MARK: - Functions

    func start() throws {
        print("Welcome to word resolver!")
        programLoop()
        print("End of program")
    }

    // MARK: - Private

    private var currentWords = [String]()
    private var hardFilter = [Character]()
    private var easyFilter = [Character]()
    private var perfectMatch: [Int: Character] = [:]
    private var currentWord = ""

    private func reset() {
        currentWords = initialWords
        hardFilter = []
        easyFilter = []
        perfectMatch = [:]
        suggestNew()
        iteration = 0
    }

    private var iteration = 0

    private func filterWords() {
        currentWords = currentWords
            .filter { word in
                // не должен содержать ни буквы
                hardFilter.reduce(true) { partialResult, c in
                    partialResult && !word.contains(c)
                }
            }

        currentWords = currentWords.filter { word in
            let newW = word.filter { c in easyFilter.contains(c) }
            return newW.count == easyFilter.count
//            easyFilter.reduce(true) { partialResult, c in
//                partialResult && word.contains(c)
//            }
        }

        currentWords = currentWords.filter { word in
            perfectMatch.reduce(true) { partialResult, kv in
                partialResult && Array(word)[kv.0] == kv.1
            }
        }

        easyFilter = []
    }

    private func suggestNew() {
        currentWord = currentWords.randomElement() ?? ""
        print("Word is \"\(currentWord)\"")
        if currentWord == "" {
            print("Program is broken. You won")
            exit(0)
        }
    }

    private func startGame() {
        print(greetings)
        reset()
    }

    private func programLoop() {
        startGame()

        while let input = readLine() {
            let filteredInput = input.filter { $0 == "@" || $0 == "-" || $0 == "+" }
            if filteredInput.count == 5 {
                filteredInput.enumerated().forEach { index, c in
                    let wordArr = Array(currentWord)
                    if c == "-" {
                        hardFilter.append(wordArr[index])
                    } else if c == "+" {
                        easyFilter.append(wordArr[index])
                    } else if c == "@" {
                        perfectMatch[index] = wordArr[index]
                    } else {
                        fatalError()
                    }
                }

                filterWords()
                iteration += 1
                if currentWords.count == 1, let win = currentWords.first {
                    print("Your word in \(win). Number of steps \(iteration)")
                    startGame()
                } else {
                    suggestNew()
                }
            } else if input == "/start" {
                startGame()
            } else {
                print("Your input is \(input). It's invalid")
                break
            }
        }
    }
}
