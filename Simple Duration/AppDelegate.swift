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
    //duration = 3+4*60+5*60*60
    
    let hrs: Double = duration / (60*60)
    let min: Double = duration / 60
    let sec: Double = duration % 60
    let formattedDuration = NSString(format: "%02d:%02d:%02d", Int(hrs), Int(min), Int(sec))
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd.MM.yyyy" //"yyyy-MM-dd 'at' HH:mm"
    let today = formatter.stringFromDate(NSDate())
    
    let str = NSString(format: "Worked %@ at %@", formattedDuration, today)
    
    println(str)

    
  }

}

