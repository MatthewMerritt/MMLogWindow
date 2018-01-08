//
//  LogWindowController.swift
//  ShiftTodayUpdater
//
//  Created by Matthew Merritt on 12/22/17.
//  Copyright © 2017 Matthew Merritt. All rights reserved.
//

import Cocoa

public class MMLogWindowController: NSWindowController, NSWindowDelegate {

    // Singleton for the only instance of LogWindowController
    public static let shared: MMLogWindowController = MMLogWindowController()

    let dateFormatter = DateFormatter()

    // The textView to show all logged messages
    @IBOutlet weak var textView: NSTextView!

    // The trash icon in the titleBar
    @IBOutlet var accessoryView: NSView!
    var accessoryViewController: NSTitlebarAccessoryViewController!

    // Holder for all the messages in case the textView has not be loaded
    var stringsToAdd: Array<String> = []

    override public func windowDidLoad() {
        super.windowDidLoad()

        // Add the trash icon to the titleBar
        accessoryViewController = NSTitlebarAccessoryViewController()
        accessoryViewController.view = accessoryView
        accessoryViewController.layoutAttribute = .right
        window?.addTitlebarAccessoryViewController(accessoryViewController)

        // Make us the delegate so we know when the LogWindowController is going to display
        window?.delegate = self

        // Add line numbers
        textView.lnv_setUpLineNumberView()

        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }

    /// Conveneince init() to load the Nib
    convenience init() {
        self.init(windowNibName: NSNib.Name(rawValue: "LogWindowController"))
    }

    public func windowDidBecomeKey(_ notification: Notification) {

//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.textView.lnv_removeLineNumberView()
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//            self.textView.lnv_setUpLineNumberView()
//        }


        for string in stringsToAdd {
            textView.string.append(string)
        }

        stringsToAdd.removeAll()
    }

    @IBAction func clearLogView(_ sender: NSButton) {
        MMLogWindowController.shared.textView.string = ""
    }

    @IBAction func toggleLineNumbers(_ sender: NSButton) {
        textView.lineNumberView.scrollView?.rulersVisible = !(textView.lineNumberView.scrollView?.rulersVisible)!
    }

    @IBAction func printButtonAction(_ sender: NSButton) {
        //    [[NSPrintOperation printOperationWithView:self] runOperation];
        let printOpts: [NSPrintInfo.AttributeKey : AnyObject] = [NSPrintInfo.AttributeKey.jobDisposition : NSPrintInfo.JobDisposition.preview as AnyObject]
        let printInfo: NSPrintInfo = NSPrintInfo(dictionary: printOpts)

        printInfo.paperSize = NSMakeSize(612, 792)
        printInfo.orientation = .portrait
        printInfo.topMargin = 15.0
        printInfo.leftMargin = 25.0
        printInfo.rightMargin = 0.0
        printInfo.bottomMargin = 0.0

        let printOp: NSPrintOperation = NSPrintOperation(view: textView, printInfo: printInfo)

        printOp.showsPrintPanel = true
        printOp.showsProgressPanel = true
        printOp.run()
    }

    /// This adds a single string to the textView, or stringsToAdd array if textView has not been loaded.
    ///
    /// - Parameters:
    ///   - string: the string to add
    ///   - title: an optional title to prepend to the string
    ///   - timeStamp: do we want to timeStamp this?
    public func add(string: String, title: String = "", timeStamp: Bool = false) {
        if textView != nil {
            textView.string.append("\(timeStamp ? dateFormatter.string(from: Date()) : "") \(title) \(string)\n")
        } else {
            stringsToAdd.append("\(timeStamp ? dateFormatter.string(from: Date()) : "") \(title) \(string)\n")
        }
    }

    /// This adds an array of strings to the textView, or stringsToAdd array if textView has not been loaded.
    ///
    /// - Parameters:
    ///   - array: the array of strings to add
    ///   - title: optional title to prepend to the strings, if it is not empty indent all the strings
    ///   - timeStamp: do we want to timeStamp this?
    public func add(string array: Array<String>, title: String = "", timeStamp: Bool = false) {
        guard array.count > 0 else { return }

        var firstString = true

        // Iterate through the array
        for string in array {
            // If textView is not nill, add string to it
            if textView != nil {
                // If this is the first string and we have a title, display it
                if firstString && title != "" {
                    textView.string.append("\(timeStamp ? dateFormatter.string(from: Date()) : "") \(title)\n")
                }

                // If we have a title, prepend a tab to indent
                let tab = title != "" ? "\t" : ""

                // Append the string
                textView.string.append("\(tab)\(string)\n")

                // We are no longer the first line, used to add the title and indent
                firstString = false
            } else {
                // The textView has not been loaded, add this string to be loaded later

                // If this is the first string and we have a title, display it
                if firstString && title != "" {
                    stringsToAdd.append("\(timeStamp ? dateFormatter.string(from: Date()) : "") \(title)\n")
                }

                // If we have a title, prepend a tab to indent
                let tab = title != "" ? "\t" : ""

                // Append the string
                stringsToAdd.append("\(tab)\(string)\n")

                // We are no longer the first line, used to add the title and indent
                firstString = false
            }
        }

        // Add an ending newline so we separate this array from the next, but only if we have a title
        if title != "" {
            if textView != nil {
                textView.string.append("\n")
                textView.scrollToEndOfDocument(nil)
            } else {
                stringsToAdd.append("\n")
            }
        }
    }

}
