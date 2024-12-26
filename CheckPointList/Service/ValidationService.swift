
import Foundation
import CoreData

class ValidationService {
    private let eventRepository: EventRepository
    private let eventDateRepository: EventDateReporistory
    
    init(eventRepository: EventRepository, eventDateRepository: EventDateReporistory) {
        self.eventRepository = eventRepository
        self.eventDateRepository = eventDateRepository
    }
    
    func isDuplicatedName(of name: String) -> Bool {
        do {
            let result = try eventRepository.getEventsByName(for: name)
            return !result.isEmpty
        } catch {
            print("Error al consultar nombre de eventos: \(error.localizedDescription)")
            return false
        }
    }
    
    func isDuplicatedEventDate(for event: Event, by date: Date) -> Bool {
        do {
            let result = try eventDateRepository.getEventDateByDate(for: event, by: date)
            return !result.isEmpty
        } catch {
            print("Error al consultar fechas de eventos: \(error.localizedDescription)")
            return false
        }
    }
}
