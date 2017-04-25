//
//  PaymentContact.swift
//  siriProject
//
//  Created by admin on 24.04.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Intents

class PaymentContact: NSObject {
    let name:String
    let email:String
    
    init(name: String, email: String){
        self.name = name
        self.email = email
    }
    
    class func allContacts() -> [PaymentContact]{
        return [
            PaymentContact(name: "Anber", email: "amber@apple.com"),
            PaymentContact(name: "Sheldom", email: "sheldom@apple.com"),
            PaymentContact(name: "Freeman", email: "freeman@apple.com")
        ]
    }
    
    func inPerson()-> INPerson {
        let nameFormatter = PersonNameComponentsFormatter()
        let personHandle = INPersonHandle(value: self.email, type: INPersonHandleType.emailAddress)
        
        if let nameComponents = nameFormatter.personNameComponents(from: name){
            return INPerson(personHandle: personHandle, nameComponents: nameComponents, displayName: nameComponents.familyName, image: nil, contactIdentifier: nil, customIdentifier: nil)
        }else{
            return INPerson(personHandle: personHandle, nameComponents: nil, displayName: nil, image: nil, contactIdentifier: nil, customIdentifier: nil)

        }
        
    }

}
