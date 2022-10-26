//
//  Localization.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 26.10.2022.
//

import Foundation

enum Localization {
    static let welcome = "Welcome to Word Resolver!"
    static let programStart = "Start of program. Will be pick random word. Input your mask, please"
    static let end = "End of program"
    static let brokenProgram = "Program is broken. You won"

    static func current(word: String) -> String {
        "Word is \"\(word)\""
    }

    static func invalid(input: String) -> String {
        "Your input is \(input). It's invalid"
    }

    static func won(word: String, iteration: Int) -> String {
        "Your word in \(word). Number of steps \(iteration)\n:DDDDDD\n"
    }
}
