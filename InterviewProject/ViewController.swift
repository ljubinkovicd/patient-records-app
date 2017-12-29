//
//  ViewController.swift
//  InterviewProject
//
//  Created by Dorde Ljubinkovic on 12/28/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(Constants.EdamamApi.baseUrl)?q=chicken&app_id=\(Constants.EdamamApi.appId)&app_key=\(Constants.EdamamApi.appKey)")
        
        let request = String(format:
            "https://api.edamam.com/search?q=chicken&app_id=\(Constants.EdamamApi.appId)&app_key=\(Constants.EdamamApi.appKey)")
        
        Alamofire.request(request).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }
}

