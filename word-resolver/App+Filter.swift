//
//  App+Filter.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

extension App {
    /// Does not called at all
    func filterWords(scrRoot: String) throws {
        let scrURL = URL(fileURLWithPath: scrRoot, isDirectory: true)
        let allWords = scrURL.appendingPathComponent("russian").appendingPathExtension("txt")
        let newWordsPath = scrURL.appendingPathComponent("russian-5").appendingPathExtension("txt")

        let words = try String(contentsOfFile: allWords.path, encoding: .utf8)

        let newWords = words
            .components(separatedBy: "\n")
            .filter { $0.count == 5 }
            .joined(separator: "\n")

        FileManager.default.createFile(atPath: newWordsPath.path, contents: newWords.data(using: .utf8), attributes: [:])
    }
}
