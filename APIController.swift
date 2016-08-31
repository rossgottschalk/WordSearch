//
//  APIController.swift
//  WordSearch
//
//  Created by Ross Gottschalk on 8/30/16.
//  Copyright © 2016 The Iron Yard. All rights reserved.
//

import Foundation

class APIController
{
    func initialAPI() -> [[String: AnyObject]]
    {
        var capabilities = [[String: AnyObject]]()
        
        let firstURL = NSURL(string: "http://54.211.91.163:8080/capabilities")
        let firstRequest = NSURLRequest(URL: firstURL!)
        let firstTask = NSURLSession.sharedSession().dataTaskWithRequest(firstRequest) {
            data, response, error in
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            do {
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSArray
                
                if let parseJSON = myJSON {
                    
                    for i in 0..<parseJSON.count
                    {
                        let capabilitiesDict = parseJSON[i]
                        capabilities.append(capabilitiesDict as! [String : AnyObject])
                    }
                }
            } catch {
                print(error)
            }
            
        }
        
        
        firstTask.resume()
        
        print(capabilities)
        return capabilities
        
    }
    
    func postAPI(width: String, height: String, words: String, minLength: String, maxLength: String, capabilities: [String]) //-> Puzzle
    {
        let seed = Int(arc4random())
        
        var jsonString: NSData?
        
        let myUrl = NSURL(string: "http://54.211.91.163:8080/puzzle")
        let request = NSMutableURLRequest(URL: myUrl!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPMethod = "POST"  // Compose a query string
        
        let dic = ["width": width, "height": height, "words": words, "minLength": minLength, "maxLength": maxLength, "capabilities": capabilities, "seed": seed]
        
        do {
            jsonString = try NSJSONSerialization.dataWithJSONObject(dic, options: [])
            // here "jsonData" is the dictionary encoded in JSON data
        } catch let error as NSError {
            print(error)
        }
        
        /*
         var jsonData: NSData = NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted, error: &error)!
         if error == nil {
         return NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
         }
         */
        
        
        let postString = jsonString
        
        request.HTTPBody = postString //dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("response = \(response)")
            
            // Print out response body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            do {
                let myJSON =  try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                print(myJSON)
                if let parseJSON = myJSON {
                    
                    // Now we can access values by its keys
                    let aPuzzle = parseJSON["puzzle"] as? [[String]]
                    let theWords = parseJSON["words"] as? [[String: AnyObject]]
                    // print("firstNameValue: \(firstNameValue)")
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        
    }
    
    
}

