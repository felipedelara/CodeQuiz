//
//  Keywords.swift
//  Code Quiz
//
//  Created by Felipe Ramon de Lara on 10/08/19.
//  Copyright © 2019 Felipe de Lara. All rights reserved.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let keywords = try Keywords(json)
// MARK: - Keywords
struct Keywords: Codable {
    let question: String?
    let answer: [String]?
}

// MARK: Keywords convenience initializers and mutators

extension Keywords {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Keywords.self, from: data)
    }
    
    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        question: String?? = nil,
        answer: [String]?? = nil
        ) -> Keywords {
        return Keywords(
            question: question ?? self.question,
            answer: answer ?? self.answer
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

/* Fixed JSON looks like this in theory:
 {
     "question": "What are all the java keywords?",
     "answer": [
         "abstract",
         "assert",
         "boolean",
         "break",
         "byte",
         "case",
         "catch",
         "char",
         "class",
         "const",
         "continue",
         "default",
         "do",
         "double",
         "else",
         "enum",
         "extends",
         "final",
         "finally",
         "float",
         "for",
         "goto",
         "if",
         "implements",
         "import",
         "instanceof",
         "int",
         "interface",
         "long",
         "native",
         "new",
         "package",
         "private",
         "protected",
         "public",
         "return",
         "short",
         "static",
         "strictfp",
         "super",
         "switch",
         "synchronized",
         "this",
         "throw",
         "throws",
         "transient",
         "try",
         "void",
         "volatile",
         "while"
         ]
 }

 */
