//
//  pumpkingApp.swift
//  pumpking
//
//  Created by David Bates on 10/7/23.
//

import SwiftUI
import AVFoundation

@main
struct pumpkingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    weak var preferencesWindow: NSWindow?
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var preferencesWindow: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let appMenu = NSMenu()
        
        appMenu.addItem(NSMenuItem(title: "About Pumpkin King", action: nil, keyEquivalent: ""))
        
        appMenu.addItem(NSMenuItem.separator())
        
        let preferencesMenuItem = NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ",")
        appMenu.addItem(preferencesMenuItem)
        
        appMenu.addItem(NSMenuItem.separator())
        
        appMenu.addItem(NSMenuItem(title: "Quit Pumpkin King", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        let mainMenu = NSMenu(title: "Main Menu")
        let appMenuItem = NSMenuItem(title: "Pumpkin King", action: nil, keyEquivalent: "")
        appMenuItem.submenu = appMenu
        mainMenu.addItem(appMenuItem)
        
        NSApp.mainMenu = mainMenu
    }
        
    @objc func showPreferences() {
        if preferencesWindow == nil {
            preferencesWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered, defer: false)
            preferencesWindow.center()
            preferencesWindow.setFrameAutosaveName("Preferences")
            preferencesWindow.contentView = NSHostingView(rootView: PreferencesView())
            preferencesWindow.title = "Preferences"
            
            // Set the delegate of the window to self
            preferencesWindow.delegate = self
            
            preferencesWindow.makeKeyAndOrderFront(nil)
        } else {
            preferencesWindow.makeKeyAndOrderFront(nil)
        }
    }
    
    func windowWillClose(_ notification: Notification) {
//        preferencesWindow?.contentView = nil
//        preferencesWindow?.delegate = nil
//        preferencesWindow = nil
    }

}
