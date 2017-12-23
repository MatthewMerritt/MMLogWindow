//
//  ViewController.swift
//  MMLogWindowExample
//
//  Created by Matthew Merritt on 12/22/17.
//  Copyright © 2017 Matthew Merritt. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var logWindow = MMLogWindowController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func logWindowAction(_ sender: NSMenuItem) {
        logWindow.showWindow(self)

        logWindow.add(string: "First String", title: "First Title", timeStamp: true)
    }
}

