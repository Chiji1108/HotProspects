//
//  ProspectsView.swift
//  HotProspects
//
//  Created by 千々岩真吾 on 2025/02/15.
//

import CodeScanner
import SwiftData
import SwiftUI

struct ProspectsView: View {
    @Environment(\.modelContext) var modelContext
    @Query var prospects: [Prospect]
    @State private var isShowingScanner = false
    @State private var selectedProspects = Set<Prospect>()

    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect(name: details[0], emailAddress: details[1], isContacted: false)

            modelContext.insert(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

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

    func delete() {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
        selectedProspects.removeAll()
    }

    var body: some View {
        NavigationStack {
            List(prospects, selection: $selectedProspects) { prospect in
                VStack(alignment: .leading) {
                    Text(prospect.name)
                        .font(.headline)
                    Text(prospect.emailAddress)
                        .foregroundStyle(.secondary)
                }
                .swipeActions {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        modelContext.delete(prospect)
                    }
                    if prospect.isContacted {
                        Button("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark") {
                            prospect.isContacted.toggle()
                        }
                        .tint(.blue)
                    } else {
                        Button(
                            "Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark"
                        ) {
                            prospect.isContacted.toggle()
                        }
                        .tint(.green)
                    }
                }
                .tag(prospect)
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                if selectedProspects.isEmpty == false {
                    ToolbarItem(placement: .bottomBar) {
                        Button(role: .destructive) {
                            delete()
                        } label: {
                            Text("Delete Selected")
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "qrcode.viewfinder") {
                        isShowingScanner = true
                    }
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(
                    codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com",
                    completion: handleScan)
            }
        }
    }
}

#Preview {
    ProspectsView(filter: .none)
        .modelContainer(for: Prospect.self, inMemory: true)
}
