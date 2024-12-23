import SwiftUI
import CoreData

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchEvents()
    }
    
    func isDuplicatedEventName(for event: Event, eventName: String) -> Bool {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", eventName)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error al consultar nombres de eventos: \(error.localizedDescription)")
            return false
        }
    }
    
    func isDuplicatedEventDate(for event: Event, newEventDate: Date) -> Bool {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@ && date == %@", event, Utils.removeTimeFromDate(of: newEventDate) as CVarArg)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error al consultar fechas de eventos: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchEvents() {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            events = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error al obtener los eventos: \(error)")
        }
    }
    
    func getMostRecentEventDateByEvent(for event: Event) -> EventDate? {
        let fetchRequest: NSFetchRequest<EventDate> = generateEventDateFetchRequest(for: event)
        
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try viewContext.fetch(fetchRequest)
                    return result.first
            } catch {
                print("Error al obtener el EventDate más reciente: \(error.localizedDescription)")
                return nil
            }
    }
    
    func getAllEventDatesByEvent(for event: Event) -> [EventDate] {
        let fetchRequest: NSFetchRequest<EventDate> = generateEventDateFetchRequest(for: event)
        
        do {
            let result = try viewContext.fetch(fetchRequest)
                return result
            } catch {
                print("Error al obtener los EventDates: \(error.localizedDescription)")
                return []
            }
    }
    
    func generateEventDateFetchRequest(for event: Event) -> NSFetchRequest<EventDate> {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", event)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return fetchRequest
    }
    
    func addEvent(name: String, date: Date) {
        let newEventDate = EventDate(context: viewContext)
        newEventDate.date = Utils.removeTimeFromDate(of: date)
        newEventDate.timestamp = Date()
        
        let newEvent = Event(context: viewContext)
        newEvent.name = name
        newEvent.addToDates(newEventDate)
        saveContext()
    }
    
    func deleteEvent(at offset: IndexSet) {
        offset.map { events[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            fetchEvents()
        } catch {
            print("Error al salvar el contexto: \(error)")
        }
    }
    
     
    func updateDateToNow(eventToUpdate: Event) {
        let newEventDate = EventDate(context: viewContext)
        newEventDate.date = Utils.removeTimeFromDate(of: Date())
        newEventDate.timestamp = Date()
        eventToUpdate.addToDates(newEventDate)
        saveContext()
    }
    
}
