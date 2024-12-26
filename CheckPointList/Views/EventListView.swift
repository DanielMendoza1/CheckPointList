import CoreData
import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel: EventViewModel
    @State private var showingAddEventView = false
    
    init (context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: EventViewModel(context: context))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.events) { event in
                    NavigationLink(destination: EventDetailsView(event: event, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(event.name ?? "Sin Nombre")
                                .foregroundColor(.primary)
                            if let date = viewModel.getMostRecentEventDateByEvent(for: event)?.date {
                                Text("Fecha: \(Utils.formatDateToText(of: date))")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .alert("Error", isPresented: $viewModel.showError) {
                            Button("OK", role: .cancel) {
                                viewModel.resetErrorMessage()
                            }
                        } message: {
                            Text(viewModel.errorMessage)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteEvent)
            }
            .navigationTitle("Eventos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEventView = true }) {
                        Label("Agregar Evento", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEventView) {
                AddEventView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    EventListView(context: PersistenceController.preview.container.viewContext)
}

