//
//  ProspectsView.swift
//  HotProspects
//
//  Created by 千々岩真吾 on 2025/02/15.
//

import SwiftData
import SwiftUI

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]

    enum FilterType {
        case none, contacted, uncontacted
    }

    let filter: FilterType

    init(filter: FilterType) {
        self.filter = filter

        if filter != .none {
            let showContactedOnly = filter == .contacted

            _prospects = Query(
                filter: #Predicate {
                    $0.isContacted == showContactedOnly
                }, sort: [SortDescriptor(\Prospect.name)])
        }
    }

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted people"
        case .uncontacted:
            "Uncontacted people"
        }
    }

    var body: some View {
        NavigationStack {
            List(prospects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button("Scan", systemImage: "qrcode.viewfinder") {
                    let prospect = Prospect(
                        name: "Paul Hudson", emailAddress: "paul@hackingwithswift.com",
                        isContacted: false)
                    modelContext.insert(prospect)
                }
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self, inMemory: true)
}
