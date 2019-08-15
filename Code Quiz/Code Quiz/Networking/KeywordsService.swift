//
//  KeywordsService.swift
//  Code Quiz
//
//  Created by Felipe Ramon de Lara on 10/08/19.
//  Copyright © 2019 Felipe de Lara. All rights reserved.
//

import Foundation

class KeywordsService{
    static func request(completionHandler: @escaping (Bool, String, [String]) -> Void){
        let request = NSMutableURLRequest(url: NSURL(string: "https://codechallenge.arctouch.com/quiz/java-keywords")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "no error")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse ?? "no response")
                guard let data = data else{
                    completionHandler(false, "", [])
                    return
                }
                print(String(data: data, encoding: .utf8) ?? "")
                if let keywords = try? Keywords(data: data) {
                    print(keywords.question ?? "no question")
                    guard let question = keywords.question, let answers = keywords.answer else{
                        completionHandler(false, "", [])
                        return
                    }
                    completionHandler(true, question, answers)
                }else{
                    print("Failed on data to model conversion")
                }
            }
        })
        
        dataTask.resume()
    }
}

let correctedJsonResponse = "{\r\n  \"question\": \"What are all the java keywords?\",\r\n  \"answer\": [\r\n    \"abstract\",\r\n    \"assert\",\r\n    \"boolean\",\r\n    \"break\",\r\n    \"byte\",\r\n    \"case\",\r\n    \"catch\",\r\n    \"char\",\r\n    \"class\",\r\n    \"const\",\r\n    \"continue\",\r\n    \"default\",\r\n    \"do\",\r\n    \"double\",\r\n    \"else\",\r\n    \"enum\",\r\n    \"extends\",\r\n    \"final\",\r\n    \"finally\",\r\n    \"float\",\r\n    \"for\",\r\n    \"goto\",\r\n    \"if\",\r\n    \"implements\",\r\n    \"import\",\r\n    \"instanceof\",\r\n    \"int\",\r\n    \"interface\",\r\n    \"long\",\r\n    \"native\",\r\n    \"new\",\r\n    \"package\",\r\n    \"private\",\r\n    \"protected\",\r\n    \"public\",\r\n    \"return\",\r\n    \"short\",\r\n    \"static\",\r\n    \"strictfp\",\r\n    \"super\",\r\n    \"switch\",\r\n    \"synchronized\",\r\n    \"this\",\r\n    \"throw\",\r\n    \"throws\",\r\n    \"transient\",\r\n    \"try\",\r\n    \"void\",\r\n    \"volatile\",\r\n    \"while\"\r\n  ]\r\n}\r\n"
