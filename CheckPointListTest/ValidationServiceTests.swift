
import XCTest
import CoreData

@testable import CheckPointList

final class ValidationServiceTests: XCTestCase {
    
    var persistenCointainer: NSPersistentContainer!
    var eventDateRepository: EventDateReporistory!
    var eventRepository: EventRepository!
    var validationService: ValidationService!

    override func setUpWithError() throws {
        persistenCointainer = NSPersistentContainer(name: "CheckPointList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        persistenCointainer.persistentStoreDescriptions = [description]
        
        persistenCointainer.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Error al cargar la tienda persistente: \(error.localizedDescription)")
            }
        }
        eventDateRepository = EventDateReporistory(context: persistenCointainer.viewContext)
        eventRepository = EventRepository(context: persistenCointainer.viewContext)
        validationService = ValidationService(eventRepository: eventRepository, eventDateRepository: eventDateRepository)
    }

    override func tearDownWithError() throws {
        persistenCointainer = nil
        eventDateRepository = nil
        eventRepository = nil
        validationService = nil
    }
    
    func testIsDuplicatedName() throws {
        try eventRepository.createEvent(name: "Event1", date: Date())
        
        let isDuplicatedName = validationService.isDuplicatedName(of: "Event1")
        XCTAssertTrue(isDuplicatedName)
    }
    
    func testIsDuplicatedNameNotDuplicated() throws {
        try eventRepository.createEvent(name: "Event1", date: Date())
        
        let isDuplicatedName = validationService.isDuplicatedName(of: "Event2")
        XCTAssertFalse(isDuplicatedName)
    }
    
    func testIsDuplicatedNameEmpty() throws {
        let isDuplicatedName = validationService.isDuplicatedName(of: "Event1")
        XCTAssertFalse(isDuplicatedName)
    }
    
    func testIsDuplicatedEventDate() throws {
        let fechaActual: Date = Date()
        let nombreEvento: String = "Event1"
        try eventRepository.createEvent(name: nombreEvento, date: fechaActual)
        
        let event1 = try XCTUnwrap(eventRepository.getEventsByName(for: nombreEvento).first, "No se encontró el evento, test fallido.")
        let isDuplicatedEventDate = validationService.isDuplicatedEventDate(for: event1, by: fechaActual)
        
        XCTAssertTrue(isDuplicatedEventDate, "La fecha del evento deberia ser duplicada.")
    }
    
    func testIsDuplicatedEventDateNotDuplicated() throws {
        let fechaActual: Date = Date()
        let fechaAnterior: Date = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: -1, to: fechaActual))
        let nombreEvento: String = "Event1"
        try eventRepository.createEvent(name: nombreEvento, date: fechaAnterior)
        
        let event1: Event = try XCTUnwrap(eventRepository.getEventsByName(for: nombreEvento).first, "No se encontró el evento, test fallido.")
        let isDuplicatedEventDate: Bool = validationService.isDuplicatedEventDate(for: event1, by: fechaActual)
        
        XCTAssertFalse(isDuplicatedEventDate, "La fecha del evento no deberia ser duplicada.")
    }
    
    func testIsDuplicatedEventDateNotExistingEvent() throws {
        let fechaActual: Date = Date()
        let nombreEvento: String = "Event1"
        let event1: Event = Event(context: persistenCointainer.viewContext)
        event1.name = nombreEvento
        event1.id = UUID()
        
        let isDuplicatedEventDate: Bool = validationService.isDuplicatedEventDate(for: event1, by: fechaActual)
        XCTAssertFalse(isDuplicatedEventDate, "La fecha del evento no deberia ser duplicada.")
    }
    
    func testIsExistingEvent() throws {
        try eventRepository.createEvent(name: "Event1", date: Date())
        
        let event1: Event = try XCTUnwrap(eventRepository.getEventsByName(for: "Event1").first, "No se encontró el evento, test fallido.")
        let event1Id: UUID = try XCTUnwrap(event1.id)
        let isExistingEvent: Bool = validationService.isExistingEvent(for: event1Id)
        
        XCTAssertTrue(isExistingEvent, "El evento deberia existir.")
    }
    
    func testIsExistingEventNotExisting() throws {
        let notExistingEvent: Event = Event(context: persistenCointainer.viewContext)
        notExistingEvent.id = UUID()
        notExistingEvent.name = "NotExistingEvent"
        
        let notExistingEventId: UUID = try XCTUnwrap(notExistingEvent.id)
        let isExistingEvent: Bool = validationService.isExistingEvent(for: notExistingEventId)
        
        XCTAssertFalse(isExistingEvent, "El evento no deberia existir.")
    }

    func testIsEmptyEventName() throws {
        let isEmptyEventName: Bool = validationService.isEmptyEventName(of: "")
        XCTAssertTrue(isEmptyEventName, "El nombre del evento deberia estar vacio.")
    }
    
    func testIsEmptyEventNameNotEmpty() throws {
        let isEmptyEventName: Bool = validationService.isEmptyEventName(of: "notEmpty")
        XCTAssertFalse(isEmptyEventName, "El nombre del evento no deberia estar vacio.")
    }
}
