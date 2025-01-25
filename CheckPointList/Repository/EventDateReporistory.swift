import Foundation
import CoreData

class EventDateReporistory {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
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
    
    func getEventDateByDate(for event: Event, by date: Date) throws -> [EventDate] {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@ && date == %@",
        event, Utils.removeTimeFromDate(of: date) as CVarArg)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(fetchRequest)
    }
    
    func updateDateToNow(for event: Event) throws {
        let newEventDate = EventDate(context: context)
        newEventDate.date = Utils.removeTimeFromDate(of: Date())
        newEventDate.timestamp = Date()
        event.addToDates(newEventDate)
        try context.save()
    }
}
