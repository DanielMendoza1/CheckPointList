import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var date: Date = Date()
    var viewModel: EventViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del evento")
                    .accessibilityIdentifier("eventDetailsSectionHeader")) {
                    TextField("Nombre", text: $name)
                        .accessibilityIdentifier("nameTextField")
                        DatePicker("Fecha", selection: $date, displayedComponents: .date)
                        .accessibilityIdentifier("eventDatePicker")
                }
                Button("Guardar") {
                    viewModel.addEvent(name: name, date: date)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || viewModel.isDuplicatedName(for: name))
                .accessibilityIdentifier("saveButton")
            }
            .navigationTitle("Nuevo evento")
        }
    }
}
