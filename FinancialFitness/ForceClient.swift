//
//  ForceClient.swift
//  FinancialFitness
//
//  Created by Ashish Mishra on 9/24/16.
//  Copyright © 2016 Ashish Mishra. All rights reserved.
//

import UIKit
import Alamofire

let baseForceUrl = "https://na35.salesforce.com/services/data/v37.0/sobjects/"

let accessToken = "Bearer 00D41000000GYQ7!AQ8AQG0xVv6sZUnwqJfLZitvpJWzuY4pdxALU0pMlkZZLpM9.uYoKc5l5BvazfRF7ZfA62XV.aSxXu0XM5RsPKjV4r8i8K.4"

class ForceClient: NSObject {

    var questionMapper : QuestionMapper = QuestionMapper()
    var answerMapper : AnswerMapper = AnswerMapper()
    
    func createRequest() -> NSMutableURLRequest {
        let request = NSMutableURLRequest()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 00D41000000GYQ7!AQ8AQG0xVv6sZUnwqJfLZitvpJWzuY4pdxALU0pMlkZZLpM9.uYoKc5l5BvazfRF7ZfA62XV.aSxXu0XM5RsPKjV4r8i8K.4", forHTTPHeaderField: "Authorization")
        return request
    }

    func createUrl(urlString : String) -> NSURL? {
        let url = NSURL(string: urlString)
        return url
    }
    
    static func getContactById() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://na35.salesforce.com/services/data/v37.0/sobjects/Contact/00341000003oBot")!)
        request.HTTPMethod = "GET"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer 00D41000000GYQ7!AQ8AQG0xVv6sZUnwqJfLZitvpJWzuY4pdxALU0pMlkZZLpM9.uYoKc5l5BvazfRF7ZfA62XV.aSxXu0XM5RsPKjV4r8i8K.4", forHTTPHeaderField: "Authorization")
                
        Alamofire.request(request).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                print(responseData)
                //completionHandler(response: responseData.response, error: nil)
            }
        }
    }
    
    //===================== Questions =========================
    func getAllQuestions(completion : (questions : [Question]?, error : NSError?) -> Void) {
        let urlString = "https://na35.salesforce.com/services/data/v37.0/query/?q=Select+Id,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,LastActivityDate,Question__c,Language__c+FROM+Language_Question__c+WHERE+Question__r.Include_Question_on_Main_Flow__c=true+and+Language__c='English'+ORDER+BY+Question__r.Order__c"
        let request = createRequest()
        request.URL = createUrl(urlString)
        Alamofire.request(request).responseJSON { (response) -> Void in
            if((response.result.value) != nil) {
                print(response)
                if (response.result.isSuccess) {
                    let responseDictionary = response.result.value as! NSDictionary
                    completion(questions: self.questionMapper.toQuestions(responseDictionary), error: nil)
                } else {
                    completion(questions: nil, error: response.result.error)
                }
            }
        }
    }
    
    func getAnswersByQuestionId(questionCustomId : String, completion : (answers : [Answer]?, error : NSError?) -> Void) {
        let urlString = "https://na35.salesforce.com/services/data/v37.0/query/?q=Select+Id,IsDeleted,Name,CreatedDate,CreatedById,LastModifiedDate,LastModifiedById,SystemModstamp,LastActivityDate,Answer__c,Language__c+FROM+Language_Answer__c+WHERE+Answer__r.Question__c='\(questionCustomId)'+and+Language__c=+'English'+ORDER+BY+Answer__r.Order__c"
        let request = createRequest()
        request.URL = createUrl(urlString)
        Alamofire.request(request).responseJSON { (response) -> Void in
            if((response.result.value) != nil) {
                print(response)
                if (response.result.isSuccess) {
                    let responseDictionary = response.result.value as! NSDictionary
                    completion(answers: self.answerMapper.toAnswers(responseDictionary), error : nil)
                } else {
                    completion(answers: nil, error: response.result.error)
                }
            }
        }
    }
}
