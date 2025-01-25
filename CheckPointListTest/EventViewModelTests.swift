import XCTest
import CoreData

@testable import CheckPointList

final class EventViewModelTests: XCTestCase {

    var persistenCointainer: NSPersistentContainer!
    var eventViewModel: EventViewModel!

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
        eventViewModel = EventViewModel(context: persistenCointainer.viewContext)
    }

    override func tearDownWithError() throws {
        persistenCointainer = nil
        eventViewModel = nil
    }
    
    func testGetAllEvents() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 1, "La cantidad de evento deberia ser de 1.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event1"],
        "La lista de nombres de eventos deberia contener solo 'Event1'")
    }
    
    func testGetAllEventsEmpty() throws {
        eventViewModel.getAllEvents()
        XCTAssertEqual(eventViewModel.events.count, 0, "La lista de eventos deberia ser vacia.")
    }
    
    func testAddEvent() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event2", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"],
        "La lista de nombres de eventos deberia contener 'Event1' y 'Event2'")
    }
    
    func testAddEventRepeatedName() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event1", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 1, "La cantidad de eventos deberia ser de 1.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event1"],
        "La lista de nombres de eventos deberia contener solo 'Event1'")
    }
    
    func testAddEventEmptyName() throws {
        eventViewModel.addEvent(name: "", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 0, "La lista de eventos deberia ser vacia.")
    }
    
    func testDeleteEvent() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event2", date: Date())
        eventViewModel.addEvent(name: "Event3", date: Date())

        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 3, "La cantidad de eventos deberia ser de 3.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event3", "Event2", "Event1"],
        "La lista de nombres de eventos deberia contener 'Event3', 'Event2' y 'Event1'")
        
        eventViewModel.deleteEvent(at: IndexSet(integer: 1))
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event3", "Event1"],
        "La lista de nombres de eventos deberia contener 'Event3' y 'Event1'")
    }
    
    func testDeleteEventNotExistingEvent() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event2", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"],
        "La lista de nombres de eventos deberia contener 'Event2' y 'Event1'")
        
        eventViewModel.deleteEvent(at: IndexSet(integer: -1))
        eventViewModel.deleteEvent(at: IndexSet(integer: 3))

        eventViewModel.getAllEvents()

        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"],
        "La lista de nombres de eventos deberia contener 'Event2' y 'Event1'")
    }
    
    func testUpdateDateToNow() throws {
        let todayDate: Date = Calendar.current.startOfDay(for: Date())
        let yestardayDate: Date = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: -1, to: todayDate))
        
        eventViewModel.addEvent(name: "Event1", date: yestardayDate)
        eventViewModel.getAllEvents()
        
        let event1: Event = try XCTUnwrap(eventViewModel.events.first)
        var eventDates: [EventDate] = eventViewModel.getAllEventDatesByEvent(for: event1)
        
        XCTAssertEqual(eventDates.count, 1, "El evento 'Event1' debe tener un solo eventDate.")
        XCTAssertEqual(eventDates.map { $0.date }, [yestardayDate], "La fecha del event1 debe ser ayer.")
        
        eventViewModel.updateDateToNow(for: event1)
        
        eventDates = eventViewModel.getAllEventDatesByEvent(for: event1)
        XCTAssertEqual(eventDates.count, 2, "El evento 'Event1' debe tener un 2 eventDates.")
        XCTAssertEqual(eventDates.map { $0.date }, [todayDate, yestardayDate],
        "La fecha del event1 debe ser ayer y hoy.")
    }
    
    func testUpdateToNowNotExistingEvent() throws {
        let notExistingEvent: Event = Event(context: persistenCointainer.viewContext)
        notExistingEvent.id = UUID()
        notExistingEvent.name = "NotExistingEvent"
            
        eventViewModel.updateDateToNow(for: notExistingEvent)
        
        let eventDates: [EventDate] = eventViewModel.getAllEventDatesByEvent(for: notExistingEvent)
        
        XCTAssertEqual(eventDates.count, 0, "El evento 'notExistingEvent' no debe tener fechas.")
    }
    
    func testUpdateToNowDuplicatedEventDate() throws {
        let todayDate: Date = Calendar.current.startOfDay(for: Date())
        
        eventViewModel.addEvent(name: "Event1", date: todayDate)
        eventViewModel.getAllEvents()

        let event1: Event = try XCTUnwrap(eventViewModel.events.first)
        var eventDates: [EventDate] = eventViewModel.getAllEventDatesByEvent(for: event1)

        XCTAssertEqual(eventDates.count, 1, "El evento 'Event1' debe tener un solo eventDate.")
        XCTAssertEqual(eventDates.map { $0.date }, [todayDate], "La fecha del event1 debe ser hoy.")
        
        eventViewModel.updateDateToNow(for: event1)
        eventDates = eventViewModel.getAllEventDatesByEvent(for: event1)
        
        XCTAssertEqual(eventDates.count, 1, "El evento 'Event1' debe tener un solo eventDate.")
        XCTAssertEqual(eventDates.map { $0.date }, [todayDate], "La fecha del event1 debe ser hoy.")
    }
    
    func testGetMostRecentEventDateByEvent() throws {
        let todayDate: Date = Calendar.current.startOfDay(for: Date())
        let yestardayDate: Date = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: -1, to: todayDate))
        eventViewModel.addEvent(name: "Event1", date: yestardayDate)
        
        let event1: Event = try XCTUnwrap(eventViewModel.events.first)
        eventViewModel.updateDateToNow(for: event1)
        let mostRecentEventDate: EventDate = try XCTUnwrap(eventViewModel.getMostRecentEventDateByEvent(for: event1))
        
        XCTAssertEqual(mostRecentEventDate.date, todayDate, "La fecha del evento 'Event1' debe ser hoy.")
    }
    
    func testGetMostRecentEventDateByEventNotExistingEvent() throws {
        let notExistingEvent: Event = Event(context: persistenCointainer.viewContext)
        notExistingEvent.id = UUID()
        notExistingEvent.name = "NotExistingEvent"
        
        let mostRecentEventDate: EventDate? = eventViewModel.getMostRecentEventDateByEvent(for: notExistingEvent)
        
        XCTAssertNil(mostRecentEventDate)
    }
    
    func testGetAllEventDatesByEvent() throws {
        let todayDate: Date = Calendar.current.startOfDay(for: Date())
        let yestardayDate: Date = try XCTUnwrap(Calendar.current.date(byAdding: .day, value: -1, to: todayDate))
        
        eventViewModel.addEvent(name: "Event1", date: yestardayDate)
        eventViewModel.getAllEvents()
        
        let event1: Event = try XCTUnwrap(eventViewModel.events.first)
        
        eventViewModel.updateDateToNow(for: event1)
        
        let eventDates: [EventDate] = eventViewModel.getAllEventDatesByEvent(for: event1)
        XCTAssertEqual(eventDates.count, 2, "El evento 'Event1' debe tener un 2 eventDates.")
        XCTAssertEqual(eventDates.map { $0.date }, [todayDate, yestardayDate],
        "La fecha del event1 debe ser ayer y hoy.")
    }
    
    func testGetAllEventDatesByEventNotExistingEvent() throws {
        let notExistingEvent: Event = Event(context: persistenCointainer.viewContext)
        notExistingEvent.id = UUID()
        notExistingEvent.name = "NotExistingEvent"
        
        let eventDates: [EventDate] = eventViewModel.getAllEventDatesByEvent(for: notExistingEvent)
        
        XCTAssertEqual(eventDates.count, 0, "El evento 'NotExistingEvent' debe tener un 0 eventDates.")
    }
}
