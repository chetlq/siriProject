//
//  IntentHandler.swift
//  SiriIntent
//
//  Created by admin on 17.04.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Intents
import Foundation

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

class IntentHandler: INExtension{
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        if intent is INSendPaymentIntent{
            return SendMoneyIntentHandler()
        }
        return self
    }
  
}


func inPerson(tel:String, name:String)-> INPerson {
    let nameFormatter = PersonNameComponentsFormatter()
    let personHandle = INPersonHandle(value: tel, type: INPersonHandleType.phoneNumber)
    
    if let nameComponents = nameFormatter.personNameComponents(from: name){
        return INPerson(personHandle: personHandle, nameComponents: nameComponents, displayName: nameComponents.familyName, image: nil, contactIdentifier: nil, customIdentifier: nil)
    }else{
        return INPerson(personHandle: personHandle, nameComponents: nil, displayName: nil, image: nil, contactIdentifier: nil, customIdentifier: nil)
        
    }
    
}

class SendMoneyIntentHandler: NSObject, INSendPaymentIntentHandling{
    public func handle(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        if let person = intent.payee, let amount = intent.currencyAmount{
            completion(INSendPaymentIntentResponse.init(code: .success, userActivity: nil))
        }else{
            completion(INSendPaymentIntentResponse.init(code: .failure, userActivity: nil))
        }
    }
    
    public func resolvePayee(forSendPayment intent: INSendPaymentIntent, with completion: @escaping (INPersonResolutionResult) -> Swift.Void){
        if let payee = intent.payee {
            
            
            

            
            
            
            
            let url = URL(string: "https://sbertech.herokuapp.com/users")
            var val   = [String]()
            
            URLSession.shared.dataTask(with: url!)
            {
                data, response, error in guard error == nil else {
                    print(error!)
                    return
                }
                guard let data = data else {
                    print("Data is empty")
                    return
                }
                
                var name: String
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
                
                for item in json {
                    name = item["name"] as! String
                    
                    //val.append(name)
                    print(item["name"] as! String) // cast directly to String
                }
                //print("Count is \(val.count).")
                
                
                
                //let contacts:[PaymentContact] = PaymentContact.allContacts()
                var resolutionResult: INPersonResolutionResult?
                var matchedContacts: [INPerson] = []
                
                for contact in json {
                    let name = contact["name"] as! String
                    print("check exlist\(name) vs \(payee.displayName)")
                    
                    if name == payee.displayName{
                        val.append(name)
                        matchedContacts.append(inPerson(tel: "123", name: name))
                    }
                }
                
                switch val.count {
                case 0:
                    print("nothing matched")
                    resolutionResult = INPersonResolutionResult.unsupported()
                case 1:
                    print("best matched")
                    let recipientMatched = inPerson(tel: "123", name: val[0])
                    resolutionResult = INPersonResolutionResult.success(with: recipientMatched)
                default:
                    print("more then one matched")
                    let disambiquationOptions:[INPerson] = matchedContacts//.map{ val in return contact.inPerson()}
                    resolutionResult = INPersonResolutionResult.disambiguation(with: disambiquationOptions)
                }
                completion(resolutionResult!)
                
                
                

                
                
                }.resume()
            
            
            
            
            

            
            
            
            
        }else{
            completion(INPersonResolutionResult.needsValue())
        }
    }

}

