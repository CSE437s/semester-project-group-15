//
//  NavigationStateManager.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/3/24.
//

import Foundation
import SwiftUI

class NavigationStateManager: ObservableObject {
    @Published var selectedTestType: TestType?
    @Published var shouldReturnToHome: Bool = false
    @Published var returnFromFullTestSession: Bool = false
    
    func resetToHome() {
        self.selectedTestType = nil
        self.shouldReturnToHome = false
    }
    
    func returnToHomeFromFullTest() {
        self.returnFromFullTestSession = true
    }
    
}
