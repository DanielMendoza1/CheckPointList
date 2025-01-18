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
    private let errorManager: ErrorManager

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        self.eventRepostiory = EventRepository(context: context)
        self.eventDateRepository = EventDateReporistory(context: context)
        self.validationService = ValidationService(eventRepository: eventRepostiory,
                                                   eventDateRepository: eventDateRepository)
        self.errorManager = ErrorManager()
        errorManager.$errorMessage.assign(to: &$errorMessage)
        errorManager.$showError.assign(to: &$showError)
        
        getAllEvents()
    }
    
    func getAllEvents() {
        do {
             events = try eventRepostiory.getAllEvents()
        } catch {
            showError(for: "Error al obtener todos los eventos.")
        }
    }
    
    func getMostRecentEventDateByEvent(for event: Event) -> EventDate? {
        guard let eventId: UUID  = event.id else {
            showError(for: "El evento a consultar no tiene Id.")
            return nil
        }
        
        guard validationService.isExistingEvent(for: eventId) else {
            showError(for: "El evento a consultar no existe.")
            return nil
        }
        
        do {
            return try eventDateRepository.getMostRecentEventDateByEvent(for: event)
        } catch {
            showError(for: "Error al obtener el EventDate más reciente.")
            return nil
        }
    }
    
    func getAllEventDatesByEvent(for event: Event) -> [EventDate] {
        guard let eventId: UUID  = event.id else {
            showError(for: "El evento a consultar no tiene Id.")
            return []
        }
        
        guard validationService.isExistingEvent(for: eventId) else {
            showError(for: "El evento a consultar no existe.")
            return []
        }
        
        do {
            return try eventDateRepository.getAllEventDatesByEvent(for: event)
        } catch {
            showError(for: "Error al obtener los EventDates del evento.")
            return []
        }
    }
    
    func addEvent(name: String, date: Date) {
        guard !validationService.isDuplicatedName(of: name) else {
            showError(for: "El nombre del evento ya existe.")
            return
        }
        
        guard !validationService.isEmptyEventName(of: name) else {
            showError(for: "El nombre del evento es vacio.")
            return
        }
        
        do {
            try eventRepostiory.createEvent(name: name, date: date)
            getAllEvents()
        } catch {
            showError(for: "Error al crear el evento.")
        }
    }
    
    func deleteEvent(at offset: IndexSet) {
        offset.forEach { index in
            guard index >= 0 && index < events.count else {
                showError(for: "Índice del evento a eliminar fuera de rango.")
                return
            }
            
            do {
                let event = events[index]
                try eventRepostiory.deleteEvent(for: event)
                getAllEvents()
            } catch {
                showError(for: "Error al eliminar el evento.")
            }
        }
    }
    
    func updateDateToNow(for event: Event) {
        guard let eventId: UUID  = event.id else {
            showError(for: "El evento a actualizar no tiene Id.")
            return
        }
                
        guard validationService.isExistingEvent(for: eventId) else {
            showError(for: "El evento a actualizar no existe.")
            return
        }
        
        guard !isDuplicatedEventDate(for: event, by: Date()) else {
            showError(for: "El evento a actualizar ya tiene una fecha actual.")
            return
        }
        
        do {
            try eventDateRepository.updateDateToNow(for: event)
            getAllEvents()
        } catch {
            showError(for: "Error al actualizar la fecha del evento.")
        }
    }
    
    func isDuplicatedName(for name: String) -> Bool {
        return validationService.isDuplicatedName(of: name)
    }
    
    func isDuplicatedEventDate(for event: Event, by date: Date) -> Bool {
        return validationService.isDuplicatedEventDate(for: event, by: date)
    }
    
    func showError(for message: String) {
        errorManager.showError(for: message)
    }
    
    func resetError() {
        errorManager.resetError()
    }
}
