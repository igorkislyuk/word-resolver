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

    init(path: String) {
        self.path = path
    }

    // MARK: - Functions

    func start() throws {
        print("Welcome to word resolver!")
        programLoop()
        print("End of program")
    }

    // MARK: - Private

    private func programLoop() {
        print(greetings)
        while let input = readLine() {
            if input == "/stop" {
                break
            } else if input == "/start" {
                print(greetings)
            } else {
                print("Your input is \(input)")
            }
        }
    }
}
