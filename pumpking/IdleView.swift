//
//  IdleView.swift
//  pumpking
//
//  Created by David Bates on 10/7/23.
//

import SwiftUI
import WebKit
import Combine
import AVFoundation



struct IdleView: View {
    @StateObject private var viewModel = WebViewViewModel()
    @State private var player: AVPlayer?
    @ObservedObject var isPlayingModel: PlaybackViewModel
    
    var body: some View {
        WebViewWrapper(webView: viewModel.webView)
            .onReceive(isPlayingModel.$isPlaying) { isPlaying in
//                viewModel.webView.evaluateJavaScript("document.querySelector('video').focus();", completionHandler: nil)
                viewModel.togglePlayPause()
//                viewModel.webView.sendSpacebarKeystroke()
                        }
//            .onReceive(viewModel.keyPressSubject) { key in
//                switch key {
//                case "p":
//                    viewModel.togglePlayPause()
//                    playLocalMP3()
//                default:
//                    break
//                }
//            }
            .frame(minWidth: 800, minHeight: 600)
    }
    
    func playLocalMP3() {
            guard player == nil else {
                // If the player is already initialized, play the sound
                player?.play()
                return
            }

            if let path = Bundle.main.path(forResource: "on_this", ofType: "mp3") {
                let url = URL(fileURLWithPath: path)
                player = AVPlayer(url: url)
                player?.play()
            }
        }
}

struct WebViewWrapper: NSViewRepresentable {
    let webView: WKWebView
    
    func makeNSView(context: Context) -> WKWebView {
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {}
}

class WebViewViewModel: ObservableObject {
    let webView: WKWebView
    let keyPressSubject = PassthroughSubject<String, Never>()
    
    init() {
        self.webView = WKWebView()
        webView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
        let cookieProperties: [HTTPCookiePropertyKey: Any] = [
                .domain: ".youtube.com", // Adjust this to the appropriate domain
                .path: "/",
                .name: "LOGIN_INFO",    // Replace with your cookie's name
                .value: "AFmmF2swRQIhAJVADuCouLcZa3OrFuM-CBnaV6EYy_3v21aajLi3olETAiBSckOhfrH2RNp0xnYV983ekiZh7lpm1_aCGbVSaoCtiQ:QUQ3MjNmeTlrRmFVcWdmckVyT3pFWGFOZXkyblJmOWZnb2Zyemp0Rjg0N1RMZ2dwa2tfZXFEazN6amNfcHZmRHBTbG9MMXRQV1RIa290QW9lWjlpY0dpTXE3S25jOFF0RkZLZV9MQ00za0xxMkMzRWExQ0lmQ19OaFRQUEswODhPbTZLb0JKZ0d1NEpYbU43aFJ2VXNHcTdocVZtMTB4cG1B",  // Replace with your cookie's value
                // ... any other properties like .expires ...
            ]
            if let cookie = HTTPCookie(properties: cookieProperties) {
                webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
            }
        if let url = URL(string: "https://music.youtube.com/watch?v=pRd6nqu_ocA&list=PLxH-SuyTFpHEE2flqnrHKFotpCIQYCtPo") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if let key = event.characters {
                self?.keyPressSubject.send(key)
            }
            return event
        }
    }
    
    func togglePlayPause() {
        webView.evaluateJavaScript("document.querySelector('video').paused ? document.querySelector('video').play() : document.querySelector('video').pause()", completionHandler: nil)
    }
    
}
extension WKWebView {
    func sendSpacebarKeystroke() {
        let spacebarEventDown = """
            var event = new KeyboardEvent('keydown', {
                'key': ' ',
                'code': 'Space',
                'which': 32,
                'bubbles': true,
                'cancelable': true
            });
            document.dispatchEvent(event);
        """
        
        let spacebarEventUp = """
            var event = new KeyboardEvent('keyup', {
                'key': ' ',
                'code': 'Space',
                'which': 32,
                'bubbles': true,
                'cancelable': true
            });
            document.dispatchEvent(event);
        """
        
        self.evaluateJavaScript(spacebarEventDown, completionHandler: nil)
        self.evaluateJavaScript(spacebarEventUp, completionHandler: nil)
    }
}


