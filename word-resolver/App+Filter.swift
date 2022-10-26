//
//  App+Filter.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

extension App {
    func processFile() throws {
        let scrURL = URL(fileURLWithPath: path, isDirectory: true)
        let originalStings = scrURL.appendingPathComponent("russian-5").appendingPathExtension("txt")

        let words = try String(contentsOfFile: originalStings.path, encoding: .utf8)

        let newWords = words
            .components(separatedBy: "\n")
            .filter { $0.range(of: "\\d{1,4}\\.", options: .regularExpression, range: nil, locale: nil) != nil }
            .joined(separator: "\n")

        FileManager.default.createFile(atPath: originalStings.path, contents: newWords.data(using: .utf8), attributes: [:])
    }
}
