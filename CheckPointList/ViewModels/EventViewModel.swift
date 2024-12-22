import SwiftUI
import CoreData

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchEvents()
    }
    
    func fetchEvents() {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        do {
            events = try viewContext.fetch(fetchRequest)
        } catch {
            print("Error fetching events: \(error)")
        }
    }
    
    func getMostRecentEventDateByEvent(for event: Event) -> EventDate? {
        let fetchRequest: NSFetchRequest<EventDate> = generateEventDateFetchRequest(for: event)
        
        fetchRequest.fetchLimit = 1
        
        do {
            let result = try viewContext.fetch(fetchRequest)
                    return result.first // Regresa el más reciente
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
        newEventDate.date = date
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
            print("Error saving context: \(error)")
        }
    }
    
    func formatDateToText(date: Date, format: String = "EEEE, MMM d, yyyy", locale: String = "es_MX") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: locale)
        return formatter.string(from: date)
    }
    
    func updateDateToNow(eventToUpdate: Event) {
        let newEventDate = EventDate(context: viewContext)
        newEventDate.date = Date()
        newEventDate.timestamp = Date()
        eventToUpdate.addToDates(newEventDate)
        saveContext()
    }
    
    func calculateDaysUntilNow(start: Date) -> String {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: start)
        let endOfDate = calendar.startOfDay(for: Date())
        let components = calendar.dateComponents([.day], from: startOfDate, to: endOfDate)
        return String(components.day ?? 0)
    }
    
}
