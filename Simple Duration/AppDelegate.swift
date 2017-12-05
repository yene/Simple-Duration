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
	var startTime : Date = Date()

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	override func awakeFromNib() {

		// Workaround for linker bug  http://stackoverflow.com/a/24026327/279890
		let NSVariableStatusItemLength: CGFloat = -1.0;

		self.statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)
		self.button = self.statusItem?.button
		self.button?.title = "Start"
		self.button?.action = #selector(AppDelegate.start(_:))
		self.button?.target = self
	}

	func start(_ sender : AnyObject) {
		button?.title = "Stop"
		button?.action = #selector(AppDelegate.stop(_:))
		startTime = Date()
	}

	func stop(_ sender : AnyObject) {
		button?.isEnabled = false

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy" //"yyyy-MM-dd 'at' HH:mm"
		let today = dateFormatter.string(from: Date())

		let startHour = (Calendar.current as NSCalendar).component(.hour, from: startTime)
		let startMinute = (Calendar.current as NSCalendar).component(.minute, from: startTime)
		
		let currentHour = (Calendar.current as NSCalendar).component(.hour, from: Date())
		let currentMinute = (Calendar.current as NSCalendar).component(.minute, from: Date())

		let str = String(format: "%@\t%02d:%02d\t%02d:%02d", today, startHour, startMinute, currentHour, currentMinute)

		let pboard = NSPasteboard.general()
		pboard.declareTypes([NSStringPboardType], owner: nil)
		pboard.setString(str, forType: NSStringPboardType)

		button?.title = "Copied to Clipboard"
		let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
				self.button?.isEnabled = true
				self.button?.title = "Start"
				self.button?.action = #selector(AppDelegate.start(_:))
			})

	}

	func timeSince(_ date: Date) -> String {
		var duration: TimeInterval! = date.timeIntervalSinceNow
		duration = duration * -1

		let hrs: Double = duration / (60 * 60)
		let min: Double = (duration / 60).truncatingRemainder(dividingBy: 60)
		return String(format: "%02dh %02dm", Int(hrs), Int(min))
	}
	
	func addMenu() {
		let menu: NSMenu = NSMenu()
        
        let wakeupMenuItem : NSMenuItem = NSMenuItem()
        wakeupMenuItem.title = "Copy last wakeup"
        wakeupMenuItem.target = self
        wakeupMenuItem.action = #selector(AppDelegate.lastWakeup(_:))
        menu.addItem(wakeupMenuItem)
        
		let quitMenuItem : NSMenuItem = NSMenuItem()
		quitMenuItem.title = "Quit"
		quitMenuItem.target = self
		quitMenuItem.action = #selector(AppDelegate.quit(_:))
		menu.addItem(quitMenuItem)
        
		self.statusItem!.menu = menu
		self.button?.performClick(self)
		self.statusItem!.menu = nil
	}
	
	func quit(_ sender: AnyObject) {
		NSApplication.shared().terminate(self)
	}
    
    func lastWakeup(_ sender: AnyObject) {
        let cmd = "pmset -g log | grep \" Wake\" | tail -n 1 | awk '{if($2 != \"since\") print $2; else print $6; }'"
		let task = Process.init()
		task.launchPath = "/bin/bash"
		task.arguments = ["-c", cmd]
		let pipe = Pipe()
		task.standardOutput = pipe
		task.standardError = pipe
		task.launch()
		task.waitUntilExit()
		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
		let dateTimeStarted = output.trimmingCharacters(in: CharacterSet.newlines)
		
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy" //"yyyy-MM-dd 'at' HH:mm"
		let today = dateFormatter.string(from: Date())
		let str = String(format: "%@\t%@", today, dateTimeStarted)
		
		let pboard = NSPasteboard.general()
		pboard.declareTypes([NSStringPboardType], owner: nil)
		pboard.setString(str, forType: NSStringPboardType)
    }

}

extension NSStatusBarButton {
	override open func rightMouseDown(with event: NSEvent) {
		self.target?.addMenu()
	}
}
