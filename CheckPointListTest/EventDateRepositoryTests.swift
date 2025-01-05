import XCTest
import CoreData

@testable import CheckPointList

final class EventDateRepository: XCTestCase {
    var persistenCointainer: NSPersistentContainer!
    var eventDateRepository: EventDateReporistory!
    var eventRepository: EventRepository!
    
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
    }
    
    override func tearDownWithError() throws {
        eventDateRepository = nil
        eventRepository = nil
        persistenCointainer = nil
    }
    
    func testGetAllEventDatesByEvent() throws {
        try eventRepository.createEvent(name: "Event1", date: Date())
        
        let event1 = try eventRepository.getEventsByName(for: "Event1").first
        
        let eventDates = try eventDateRepository.getAllEventDatesByEvent(for: event1!)
        
        XCTAssertEqual(eventDates.count, 1, "La cantidad de fechas obtenidas para el event1 deberia ser de 1.")
        XCTAssertEqual(eventDates.map { $0.date }, [Utils.removeTimeFromDate(of: Date())], "La fecha obtenida de event1 deberia ser la fecha de hoy.")
    }
    
    func testGetAllEventDatesByNotFoundEvent() throws {
        let notExistingEvent = Event(context: persistenCointainer.viewContext)
        let notFoundEventDates = try eventDateRepository.getAllEventDatesByEvent(for: notExistingEvent)
        
        XCTAssertEqual(notFoundEventDates.count, 0, "La cantidad de fechas obtenidas deberian ser 0 para un evento no existente.")
    }
    
    func testUpdateDateToNow() throws {
        let todayDate = Utils.removeTimeFromDate(of: Date())
        let yesterdayDate = Utils.removeTimeFromDate(of: Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? todayDate)
        
        try eventRepository.createEvent(name: "Event2", date: yesterdayDate)
        let event2 = try eventRepository.getEventsByName(for: "Event2").first
        try eventDateRepository.updateDateToNow(for: event2!)
        
        let event2Dates = try eventDateRepository.getAllEventDatesByEvent(for: event2!)
        XCTAssertEqual(event2Dates.count, 2, "La cantidad de fechas del evento debe ser 2.")
        XCTAssertEqual(event2Dates.map { $0.date }, [todayDate, yesterdayDate], "Las fechas obtenidas deberian ser las fechas de ayer y hoy.")
    }
    
    func testGetEventDatesByDate() throws {
        let todayDate = Utils.removeTimeFromDate(of: Date())
        let yesterdayDate = Utils.removeTimeFromDate(of: Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? todayDate)
        
        try eventRepository.createEvent(name: "Event3", date: yesterdayDate)
        let event3 = try eventRepository.getEventsByName(for: "Event3").first
        try eventDateRepository.updateDateToNow(for: event3!)
        
        let event3Dates = try eventDateRepository.getEventDateByDate(for: event3!, by: yesterdayDate)
        XCTAssertEqual(event3Dates.count, 1, "La funcion getEventDateByDate deberia retornar un solo elemento.")
        XCTAssertEqual(event3Dates.map { $0.date }, [yesterdayDate], "La funcion getEventDateByDate deberia retornar el evento con la fecha de hoy.")
    }
    
    func testGetEventDatesByNotExistingDate() throws {
        let todayDate = Utils.removeTimeFromDate(of: Date())
        let yesterdayDate = Utils.removeTimeFromDate(of: Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? todayDate)
        
        try eventRepository.createEvent(name: "Event3", date: yesterdayDate)
        let event3 = try eventRepository.getEventsByName(for: "Event3").first
        
        let event3Dates = try eventDateRepository.getEventDateByDate(for: event3!, by: todayDate)
        XCTAssertEqual(event3Dates.count, 0, "La funcion getEventDateByDate deberia retornar un arreglo vacio si no existe el evento con la fecha de hoy.")
    }
    
    func testGetMostRecentEventDateByEvent() throws {
        let todayDate = Utils.removeTimeFromDate(of: Date())
        let yesterdayDate = Utils.removeTimeFromDate(of: Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? todayDate)
        
        try eventRepository.createEvent(name: "Event4", date: yesterdayDate)
        let event4 = try eventRepository.getEventsByName(for: "Event4").first
        try eventDateRepository.updateDateToNow(for: event4!)
        
        let mostRecentEventDate = try eventDateRepository.getMostRecentEventDateByEvent(for: event4!)
        XCTAssertEqual(mostRecentEventDate?.date, todayDate, "La fecha de evento mas reciente deberia ser hoy.")
    }
    
    func testGetMostRecentEventDateByNotExistingEvent() throws {
        let todayDate = Utils.removeTimeFromDate(of: Date())
        let yesterdayDate = Utils.removeTimeFromDate(of: Calendar.current.date(byAdding: .day, value: -1, to: todayDate) ?? todayDate)
        let notExistingEvent = Event(context: persistenCointainer.viewContext)
        notExistingEvent.name = "notExistingEvent"
        
        try eventRepository.createEvent(name: "Event5", date: yesterdayDate)
        let event5 = try eventRepository.getEventsByName(for: "Event5").first
        try eventDateRepository.updateDateToNow(for: event5!)
        
        let mostRecentEventDate = try eventDateRepository.getMostRecentEventDateByEvent(for: notExistingEvent)
        XCTAssertNil(mostRecentEventDate, "La funcion deberia retornar nil al no exsitir el evento a buscar.")
    }
}
