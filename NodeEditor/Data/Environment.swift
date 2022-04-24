//
//  Environment.swift
//  ShaderNodeEditor
//
//  Created by fincher on 4/18/22.
//

import Foundation
import Combine
import SwiftUI

class Environment : ObservableObject {
    
    
    @UserDefault(key: "useContextMenuOnNodes", defaultValue: false)
    var useContextMenuOnNodes: Bool
    @UserDefault(key: "enableBlurEffectOnNodes", defaultValue: true)
    var enableBlurEffectOnNodes: Bool
    @UserDefault(key: "debugMode", defaultValue: false)
    var debugMode: Bool
    @UserDefault(key: "toggleNodeListPanel", defaultValue: false)
    var toggleNodeListPanel: Bool
    @UserDefault(key: "toggleLivePanel", defaultValue: false)
    var toggleLivePanel: Bool
    @UserDefault(key: "toggleDocPanel", defaultValue: false)
    var toggleDocPanel: Bool
    
    private var notificationSubscription: AnyCancellable?
    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { notif in
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
}
