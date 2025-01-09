
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
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event1"], "La lista de nombres de eventos deberia contener solo 'Event1'")
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
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"], "La lista de nombres de eventos deberia contener 'Event1' y 'Event2'")
    }
    
    func testAddEventRepeatedName() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event1", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 1, "La cantidad de eventos deberia ser de 1.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event1"], "La lista de nombres de eventos deberia contener solo 'Event1'")
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
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event3", "Event2", "Event1"],  "La lista de nombres de eventos deberia contener 'Event3', 'Event2' y 'Event1'")
        
        eventViewModel.deleteEvent(at: IndexSet(integer: 1))
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event3", "Event1"], "La lista de nombres de eventos deberia contener 'Event3' y 'Event1'")
    }
    
    func testDeleteEventNotExistingEvent() throws {
        eventViewModel.addEvent(name: "Event1", date: Date())
        eventViewModel.addEvent(name: "Event2", date: Date())
        
        eventViewModel.getAllEvents()
        
        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"], "La lista de nombres de eventos deberia contener 'Event2' y 'Event1'")
        
        eventViewModel.deleteEvent(at: IndexSet(integer: -1))
        eventViewModel.deleteEvent(at: IndexSet(integer: 3))

        eventViewModel.getAllEvents()

        XCTAssertEqual(eventViewModel.events.count, 2, "La cantidad de eventos deberia ser de 2.")
        XCTAssertEqual(eventViewModel.events.map { $0.name }, ["Event2", "Event1"], "La lista de nombres de eventos deberia contener 'Event2' y 'Event1'")
    }
}
