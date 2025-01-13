

import SwiftUI

struct EventDetailsView: View {
    @ObservedObject var event: Event
    var viewModel: EventViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Nombre del evento", value: event.name ?? "Sin Nombre")
                    LabeledContent("Fecha del evento", value: Utils.formatDateToText(of: viewModel.getMostRecentEventDateByEvent(for: event)?.date ?? Date()))
                } header: {
                    Text("Informacion Extra")
                }
                Section {
                    Button(action: {
                        viewModel.updateDateToNow(for: event)
                    }) {
                        Text("Actualizar fecha")
                    }
                    .disabled(viewModel.isDuplicatedEventDate(for: event, by: Date()))
                }
                Section {
                    LabeledContent("Dias transcurridos", value: Utils.calculateDaysUntilNow(from: viewModel.getMostRecentEventDateByEvent(for: event)?.date ?? Date()))
                } header: {
                    Text("Estadisticas")
                }
                Section {
                    List(viewModel.getAllEventDatesByEvent(for: event)) { eventDate in
                        Text("Fecha: \(Utils.formatDateToText(of: eventDate.date ?? Date()))")
                    }
                } header: {
                    Text("Fechas registradas")
                }
            }
            .navigationBarTitle("Detalles")
        }
    }
}
