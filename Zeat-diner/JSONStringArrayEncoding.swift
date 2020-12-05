//
//  JSONStringArrayEncoding.swift
//  Zeat-diner
//
//  Created by Kumaresan Sankaranarayanan on 9/5/17.
//  Copyright © 2017 Zeat. All rights reserved.
//


import Alamofire

struct JSONStringArrayEncoding: ParameterEncoding {
    private let myString: String
    
    init(string: String) {
        self.myString = string
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = urlRequest.urlRequest
        
        let data = myString.data(using: .utf8)!
        
        if urlRequest?.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest?.httpBody = data
        
        return urlRequest!
    }
}

