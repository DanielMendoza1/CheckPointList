
import Foundation
import CoreData

class ValidationService {
    static func isDuplicatedName(of name: String, from context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error al consultar nombre de eventos: \(error.localizedDescription)")
            return false
        }
    }
    
    static func isDuplicatedEventDate(for event: Event, with newDate: Date, from context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<EventDate> = EventDate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "event == %@ && date == %@", event, Utils.removeTimeFromDate(of: newDate) as CVarArg)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error al consultar fechas de eventos: \(error.localizedDescription)")
            return false
        }
    }
}
