//
//  ContentView.swift
//  HotProspects
//
//  Created by 千々岩真吾 on 2025/02/11.
//

import SamplePackage
import SwiftUI
import UserNotifications

struct ContentView: View {
    let possibleNumbers = 1...60

    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.formatted()
    }

    var body: some View {
        Text(results)
    }
}

#Preview {
    ContentView()
}
