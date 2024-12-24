

import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var date: Date = Date()
    var viewModel: EventViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del evento")) {
                    TextField("Nombre", text: $name)
                    DatePicker("Fecha", selection: $date)
                }
                Button("Guardar") {
                    viewModel.addEvent(name: name, date: date)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || viewModel.isDuplicatedName(for: name))
            }
            .navigationTitle("Nuevo evento")
        }
    }
}

