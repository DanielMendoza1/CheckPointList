
import Foundation
import CoreData

class EventRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllEvents() throws -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return try context.fetch(fetchRequest)
    }
    
    func getEventsByName(for name: String) throws -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        return try context.fetch(fetchRequest)
    }
    
    func getSelfEvent(for event: Event) throws -> Event? {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "SELF == %@", event)
        fetchRequest.fetchLimit = 1
        return try context.fetch(fetchRequest).first
    }
    
    func createEvent(name: String, date: Date) throws {
        let newEventDate = EventDate(context: context)
        newEventDate.date = Utils.removeTimeFromDate(of: date)
        newEventDate.timestamp = Date()
        
        let newEvent = Event(context: context)
        newEvent.name = name
        newEvent.addToDates(newEventDate)
        try context.save()
    }
    
    func deleteEvent(for event: Event) throws {
        context.delete(event)
        try context.save()
    }
}
