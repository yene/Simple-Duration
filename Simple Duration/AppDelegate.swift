//
//  AppDelegate.swift
//  Simple Duration
//
//  Created by Yannick Weiss on 08/04/15.
//  Copyright (c) 2015 Yannick Weiss. All rights reserved.
//

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
  
  func start(sender : AnyObject) {
    button?.title = "Stop"
    button?.action = "stop:"
    startTime = NSDate();
  }

  func stop(sender : AnyObject) {
    button?.enabled = false
    
    var duration: NSTimeInterval! = startTime?.timeIntervalSinceNow
    duration = duration * -1
    
    let hrs: Double = duration / (60*60)
    let min: Double = (duration / 60) % 60
    let formattedDuration = NSString(format: "%02dh %02dm", Int(hrs), Int(min))
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd/MM/yyyy" //"yyyy-MM-dd 'at' HH:mm"
    let today = formatter.stringFromDate(NSDate())
    
    let str = NSString(format: "%@\t%@", today, formattedDuration)
    
    let pboard = NSPasteboard.generalPasteboard()
    pboard.declareTypes([NSStringPboardType], owner: nil)
    pboard.setString(str, forType: NSStringPboardType)
    
    button?.title = "Copied to Clipboard"
    var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
      self.button?.enabled = true
      self.button?.title = "Start"
      self.button?.action = "start:"
    })
    
  }

}

