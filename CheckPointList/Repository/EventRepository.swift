
import Foundation
import CoreData

class EventRepository {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func getAllEvents() throws -> [Event] {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        return try context.fetch(fetchRequest)
    }
    
    func getMostRecentEventDateByEvent(for event: Event) throws -> EventDate? {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", event)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        return try context.fetch(fetchRequest).first
    }
    
    func getAllEventDatesByEvent(for event: Event) throws -> [EventDate] {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@", event)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(fetchRequest)
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
    
    func updateDateToNow(eventToUpdate: Event) throws {
        let newEventDate = EventDate(context: context)
        newEventDate.date = Utils.removeTimeFromDate(of: Date())
        newEventDate.timestamp = Date()
        eventToUpdate.addToDates(newEventDate)
        try context.save()
    }
    
    func deleteEvent(for event: Event) throws {
        context.delete(event)
        try context.save()
    }
}
