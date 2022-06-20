//
//  AppDelegate.swift
//  sw
//
//  Created by yinxianwei on 2022/6/20.
//

import Cocoa
import Carbon

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem : NSStatusItem = {
        let item =  NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button!.title = "SW"
        return item
    }()


    @discardableResult
    func acquirePrivileges() -> Bool {
        let accessEnabled = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)

        if accessEnabled != true {
            print("You need to enable the keylogger in the System Prefrences")
        }
        return accessEnabled
    }


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // https://developer.apple.com/forums/thread/94438
        // https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
        var _flag = 0
        NSEvent.addGlobalMonitorForEvents(matching: .any) { event in
            if event.type == NSEvent.EventType.flagsChanged {
                if event.keyCode == 62 {
                    if _flag == 0 {
                        _flag = 1
                    }
                    if !event.modifierFlags.contains(NSEvent.ModifierFlags.control) {
                        if _flag == 2 {
                            return _flag = 0
                        }
                        print(event.keyCode)

                        let src = CGEventSource(stateID: .privateState)
                        let space = CGEvent(keyboardEventSource: src, virtualKey: 0x31, keyDown: true)
                        let space_up = CGEvent(keyboardEventSource: src, virtualKey: 0x31, keyDown: false)
                        let command = CGEvent(keyboardEventSource: src, virtualKey: 0x37, keyDown: true)
                        let command_up = CGEvent(keyboardEventSource: src, virtualKey: 0x37, keyDown: false)
                        
                        space?.flags = CGEventFlags.maskCommand
                        let loc = CGEventTapLocation.cghidEventTap
                        command?.post(tap: loc)
                        space?.post(tap: loc)
                        space_up?.post(tap: loc)
                        command_up?.post(tap: loc)

                        _flag = 0
                    }
                }
            } else if event.type == NSEvent.EventType.keyDown {
                print(event.keyCode)
                if _flag == 1 {
                    _flag = 2
                }
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}



