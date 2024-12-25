import SwiftUI
import CoreData

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private let viewContext: NSManagedObjectContext
    
    private let eventRepostiory: EventRepository
    private let eventDateRepositort: EventDateReporistory

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.eventRepostiory = EventRepository(context: context)
        self.eventDateRepositort = EventDateReporistory(context: context)
    }
    
    func isDuplicatedName(for name: String) -> Bool {
        return ValidationService.isDuplicatedName(of: name, from: viewContext)
    }
    
    func isDuplicatedEventDate(for event: Event, newEventDate: Date) -> Bool {
        return ValidationService.isDuplicatedEventDate(for: event, with: newEventDate, from: viewContext)
    }
    
    func getAllEvents() -> [Event] {
        do {
            return try eventRepostiory.getAllEvents()
        } catch {
            print("Error al obtener los eventos: \(error.localizedDescription)")
            return []
        }
    }
    
    func getMostRecentEventDateByEvent(for event: Event) -> EventDate? {
        do {
            return try eventDateRepositort.getMostRecentEventDateByEvent(for: event)
        } catch {
            print("Error al obtener el EventDate más reciente: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getAllEventDatesByEvent(for event: Event) -> [EventDate] {
        do {
            return try eventDateRepositort.getAllEventDatesByEvent(for: <#T##Event#>)
        } catch {
            print("Error al obtener los EventDates: \(error.localizedDescription)")
            return []
        }
    }
    
    func addEvent(name: String, date: Date) {
        do {
            try eventRepostiory.createEvent(name: <#T##String#>, date: <#T##Date#>)
        } catch {
            print("Error al crear el evento: \(error.localizedDescription)")
        }
    }
    
    func deleteEvent(at offset: IndexSet) {
        offset.forEach { index in
            let event = events[index]
            do {
                try eventRepostiory.deleteEvent(for: event)
            } catch {
                print("Error al eleiminar el evento: \(error.localizedDescription)")
            }
        }
    }
    
    func updateDateToNow(event: Event) {
        do {
            try eventDateRepositort.updateDateToNow(for: event)
        } catch {
            print("Error al actualizar la fecha del evento: \(error.localizedDescription)")
        }
    }
    
}
