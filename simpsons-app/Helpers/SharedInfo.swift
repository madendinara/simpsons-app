//
//  SharedInfo.swift
//  simpsons-app
//
//  Created by Динара Зиманова on 4/26/23.
//

import Foundation

enum Type: String {
    case wire = "com.vineelgolla.simpsonsviewer.pro"
    case simpsonsviewer = "com.vineelgolla.simpsonsviewer"
}

class SharedInfo {
    
    static let shared = SharedInfo()
    
    var title = ""
    var url = ""
    
    var app: Type? {
        didSet {
            switch app {
            case .wire:
                title = "The Wire"
                url = "http://api.duckduckgo.com/?q=the+wire+characters&format=json"
            case .simpsonsviewer:
                title = "Simpsons"
                url = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
            case .none:
                title = "Simpsons"
                url = "http://api.duckduckgo.com/?q=simpsons+characters&format=json"
            }
        }
    }

}
