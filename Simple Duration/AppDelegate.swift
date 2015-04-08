//
//  AppDelegate.swift
//  Simple Duration
//
//  Created by Yannick Weiss on 08/04/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//

// 🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱🐱

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  var statusItem: NSStatusItem?
  var button: NSStatusBarButton?
  var started = false
  var startTime : NSDate?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(aNotification: NSNotification) {
  }
  
  override func awakeFromNib() {

    self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1.0)
    self.button = self.statusItem?.button
    self.button?.title = "Start"
    self.button?.action = "start:"
    self.button?.target = self
  }
  
  @IBAction func start(sender : AnyObject) {
    println("start pressed")
    
    button?.title = "Stop"
    button?.action = "stop:"
    
    startTime = NSDate();
  }

  @IBAction func stop(sender : AnyObject) {
    println("stop pressed")
    
    button?.title = "Start"
    button?.action = "start:"
    
    var duration: NSTimeInterval! = startTime?.timeIntervalSinceNow
    duration = duration * -1
    
    let min: Double = duration / 60    // divide two longs, truncates
    let sec: Double = duration % 60    // remainder of long divide
    let str = NSString(format: "%02d:%02d", Int(min), Int(sec))
    
    NSLog("duration %@", str)
  }

}

