//
//  ViewController.swift
//  siriProject
//
//  Created by admin on 17.04.17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Intents

class ViewController: UIViewController {

    @IBOutlet weak var siriSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        siriSwitch.setOn(false, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func siriSwitchSwitched(_ sender: Any) {
        if siriSwitch.isOn{
            INPreferences.requestSiriAuthorization({(status) in
            print(status)})
        }
    }

}

