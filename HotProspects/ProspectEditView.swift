import SwiftUI

struct ProspectEditView: View {
    @Bindable var prospect: Prospect

    var body: some View {
        Form {
            TextField("Name", text: $prospect.name)
                .textContentType(.name)

            TextField("Email", text: $prospect.emailAddress)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
        }
        .navigationTitle("Edit Prospect")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProspectEditView(
            prospect: Prospect(name: "John Doe", emailAddress: "john@doe.com", isContacted: false)
        )
    }
    .modelContainer(for: Prospect.self)
}
