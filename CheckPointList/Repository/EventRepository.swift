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
    
    func getEventById(for id: UUID) throws -> Event? {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        let result: [Event] = try context.fetch(fetchRequest)
        return result.first(where: { !$0.hasChanges })
    }
    
    func createEvent(name: String, date: Date) throws {
        let newEventDate = EventDate(context: context)
        newEventDate.date = Utils.removeTimeFromDate(of: date)
        newEventDate.timestamp = Date()
        
        let newEvent = Event(context: context)
        newEvent.id = UUID()
        newEvent.name = name
        newEvent.addToDates(newEventDate)
        try context.save()
    }
    
    func deleteEvent(for event: Event) throws {
        context.delete(event)
        try context.save()
    }
}
