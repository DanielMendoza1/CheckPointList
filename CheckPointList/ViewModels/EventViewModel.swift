import SwiftUI
import CoreData

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    private let viewContext: NSManagedObjectContext
    
    private let eventRepostiory: EventRepository
    private let eventDateRepository: EventDateReporistory
    private let validationService: ValidationService

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.eventRepostiory = EventRepository(context: context)
        self.eventDateRepository = EventDateReporistory(context: context)
        self.validationService = ValidationService(eventRepository: eventRepostiory,
                                                   eventDateRepository: eventDateRepository)
        getAllEvents()
    }
    
    func getAllEvents() {
        do {
             events = try eventRepostiory.getAllEvents()
        } catch {
            generateErrorMessage(for: "Error al obtener todos los eventos.")
        }
    }
    
    func getMostRecentEventDateByEvent(for event: Event) -> EventDate? {
        do {
            return try eventDateRepository.getMostRecentEventDateByEvent(for: event)
        } catch {
            generateErrorMessage(for: "Error al obtener el EventDate más reciente.")
            return nil
        }
    }
    
    func getAllEventDatesByEvent(for event: Event) -> [EventDate] {
        do {
            return try eventDateRepository.getAllEventDatesByEvent(for: event)
        } catch {
            generateErrorMessage(for: "Error al obtener los EventDates del evento.")
            return []
        }
    }
    
    func addEvent(name: String, date: Date) {
        do {
            try eventRepostiory.createEvent(name: name, date: date)
            getAllEvents()
        } catch {
            generateErrorMessage(for: "Error al crear el evento.")
        }
    }
    
    func deleteEvent(at offset: IndexSet) {
        offset.forEach { index in
            let event = events[index]
            do {
                try eventRepostiory.deleteEvent(for: event)
                getAllEvents()
            } catch {
                generateErrorMessage(for: "Error al eliminar el evento.")
            }
        }
    }
    
    func updateDateToNow(event: Event) {
        if validationService.isExistingEvent(of: event) {
            do {
                try eventDateRepository.updateDateToNow(for: event)
                getAllEvents()
            } catch {
                generateErrorMessage(for: "Error al actualizar la fecha del evento.")
            }
        } else {
            generateErrorMessage(for: "El evento a actualizar no existe.")
        }
    }
    
    func isDuplicatedName(for name: String) -> Bool {
        return validationService.isDuplicatedName(of: name)
    }
    
    func isDuplicatedEventDate(for event: Event, by date: Date) -> Bool {
        return validationService.isDuplicatedEventDate(for: event, by: date)
    }
    
    func resetErrorMessage() {
        self.errorMessage = ""
        self.showError = false
    }
    
    func generateErrorMessage(for errorMessage: String) {
        self.errorMessage = errorMessage
        self.showError = true
    }
}
