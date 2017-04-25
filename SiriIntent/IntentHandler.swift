//
//  IntentHandler.swift
//  SiriIntent
//
//  Created by admin on 17.04.17.
//  Copyright © 2017 admin. All rights reserved.
//

import Intents

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

class SendMoneyIntentHandler: NSObject, INSendPaymentIntentHandling{
    public func handle(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        if let person = intent.payee, let amount = intent.currencyAmount{
            completion(INSendPaymentIntentResponse.init(code: .success, userActivity: nil))
        }else{
            completion(INSendPaymentIntentResponse.init(code: .success, userActivity: nil))
        }
    }
    
    public func resolvePayee(forSendPayment intent: INSendPaymentIntent, with completion: @escaping (INPersonResolutionResult) -> Swift.Void){
        if let payee = intent.payee {
            let contacts:[PaymentContact] = PaymentContact.allContacts()
            var resolutionResult: INPersonResolutionResult?
            var matchedContacts: [PaymentContact] = []
            
            for contact in contacts {
                print("check exlist\(contact.name) vs \(payee.displayName)")
                
                if contact.name == payee.displayName{
                    matchedContacts.append(contact)
                }
            }
            
            switch matchedContacts.count {
            case 0:
                print("nothing matched")
                resolutionResult = INPersonResolutionResult.unsupported()
            case 1:
                print("best matched")
                let recipientMatched = matchedContacts[0].inPerson()
                resolutionResult = INPersonResolutionResult.success(with: recipientMatched)
            default:
                print("more then one matched")
                let disambiquationOptions:[INPerson] = matchedContacts.map{ contact in return contact.inPerson()}
                resolutionResult = INPersonResolutionResult.disambiguation(with: disambiquationOptions)
            }
            completion(resolutionResult!)
        }else{
            completion(INPersonResolutionResult.needsValue())
        }
    }

}

