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
	var startTime : NSDate = NSDate()

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(aNotification: NSNotification) {
	}

	override func awakeFromNib() {

		// Workaround for linker bug  http://stackoverflow.com/a/24026327/279890
		let NSVariableStatusItemLength: CGFloat = -1.0;

		self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
		self.button = self.statusItem?.button
		self.button?.title = "Start"
		self.button?.action = "start:"
		self.button?.target = self
	}

	func start(sender : AnyObject) {
		button?.title = "Stop"
		button?.action = "stop:"
		startTime = NSDate()
	}

	func stop(sender : AnyObject) {
		button?.enabled = false

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy" //"yyyy-MM-dd 'at' HH:mm"
		let today = dateFormatter.stringFromDate(NSDate())

		let startHour = NSCalendar.currentCalendar().component(.Hour, fromDate: startTime)
		let startMinute = NSCalendar.currentCalendar().component(.Minute, fromDate: startTime)
		
		let currentHour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
		let currentMinute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())

		let str = String(format: "%@\t%02d:%02d\t%02d:%02d", today, startHour, startMinute, currentHour, currentMinute)

		let pboard = NSPasteboard.generalPasteboard()
		pboard.declareTypes([NSStringPboardType], owner: nil)
		pboard.setString(str, forType: NSStringPboardType)

		button?.title = "Copied to Clipboard"
		let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC)))
		dispatch_after(dispatchTime, dispatch_get_main_queue(), {
				self.button?.enabled = true
				self.button?.title = "Start"
				self.button?.action = "start:"
			})

	}

	func timeSince(date: NSDate) -> String {
		var duration: NSTimeInterval! = date.timeIntervalSinceNow
		duration = duration * -1

		let hrs: Double = duration / (60 * 60)
		let min: Double = (duration / 60) % 60
		return String(format: "%02dh %02dm", Int(hrs), Int(min))
	}
	
	func addMenu() {
		let menu: NSMenu = NSMenu()
        
        let wakeupMenuItem : NSMenuItem = NSMenuItem()
        wakeupMenuItem.title = "Copy last wakeup"
        wakeupMenuItem.target = self
        wakeupMenuItem.action = Selector("lastWakeup:")
        menu.addItem(wakeupMenuItem)
        
		let quitMenuItem : NSMenuItem = NSMenuItem()
		quitMenuItem.title = "Quit"
		quitMenuItem.target = self
		quitMenuItem.action = Selector("quit:")
		menu.addItem(quitMenuItem)
        
		self.statusItem!.menu = menu
		self.button?.performClick(self)
		self.statusItem!.menu = nil
	}
	
	func quit(sender: AnyObject) {
		NSApplication.sharedApplication().terminate(self)
	}
    
    func lastWakeup(sender: AnyObject) {
        // http://blog.nottoobadsoftware.com/swiftshell/how-to-use-swift-for-shell-scripting/
        let cmd = "pmset -g log | grep \" Wake\" | tail -n 1 | awk '{print $2}' | pbcopy"
        NSTask.launchedTaskWithLaunchPath("/bin/bash", arguments:["-c", cmd]).waitUntilExit()
    }

}

extension NSStatusBarButton {
	override public func rightMouseDown(event: NSEvent) {
		self.target?.addMenu()
	}
}
