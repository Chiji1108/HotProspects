//
//  ContentView.swift
//  HotProspects
//
//  Created by 千々岩真吾 on 2025/02/11.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red

    var body: some View {
        List {
            Text("Taylor Swift")
                .swipeActions {
                    Button("Delete", systemImage: "minus.circle", role: .destructive) {
                        print("Deleting")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button("Pin", systemImage: "pin") {
                        print("Pinning")
                    }
                    .tint(.orange)
                }
        }
    }
}

#Preview {
    ContentView()
}
