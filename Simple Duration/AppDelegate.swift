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

		var startHour = NSCalendar.currentCalendar().component(.Hour, fromDate: startTime)
		var startMinute = NSCalendar.currentCalendar().component(.Hour, fromDate: startTime)
		(startHour, startMinute) = roundTime(startHour, minutes: startMinute)
		
		
		var currentHour = NSCalendar.currentCalendar().component(.Hour, fromDate: NSDate())
		var currentMinute = NSCalendar.currentCalendar().component(.Minute, fromDate: NSDate())
		(currentHour, currentMinute) = roundTime(currentHour, minutes: currentMinute)


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

	func roundTime(hours: Int, minutes: Int) -> (Int, Int) {
		switch (minutes) {
		case 0..<7:
			return(hours, 0)
		case 7..<22:
			return(hours, 15)
		case 22..<37:
			return(hours, 30)
		case 37..<52:
			return(hours, 45)
		default:
			return(hours + 1, 0)
		}
	}

}

