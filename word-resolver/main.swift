//
//  main.swift
//  word-resolver
//
//  Created by Igor Kislyuk on 25.10.2022.
//

import Foundation

let path = ProcessInfo.processInfo.environment["SRCROOT"]!

let pathURL = URL(fileURLWithPath: path, isDirectory: true)
let wordsPath = pathURL.appendingPathComponent("russian-5").appendingPathExtension("txt")
let words = try String(contentsOfFile: wordsPath.path, encoding: .utf8)

try App(path: path, initialWords: []).run()
