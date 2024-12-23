

import SwiftUI

struct EventDetailsView: View {
    @ObservedObject var event: Event
    var viewModel: EventViewModel

    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Nombre del evento", value: event.name ?? "Sin Nombre")
                    LabeledContent("Fecha del evento", value: viewModel.formatDateToText(date: viewModel.getMostRecentEventDateByEvent(for: event)?.date ?? Date()))
                } header: {
                    Text("Informacion Extra")
                }
                Section {
                    Button(action: {
                        viewModel.updateDateToNow(eventToUpdate: event)
                    }) {
                        Text("Actualizar fecha")
                    }
                    .disabled(viewModel.isDuplicatedEventDate(for: event, newEventDate: Date()))
                }
                Section {
                    LabeledContent("Dias transcurridos", value: viewModel.calculateDaysUntilNow(start: viewModel.getMostRecentEventDateByEvent(for: event)?.date ?? Date()))
                } header: {
                    Text("Estadisticas")
                }
                Section {
                    List(viewModel.getAllEventDatesByEvent(for: event)) { eventDate in
                        Text("Fecha: \(viewModel.formatDateToText(date: eventDate.date ?? Date()))")
                    }
                } header: {
                    Text("Fechas registradas")
                }
            }
            .navigationBarTitle("Detalles")
        }
    }
}
