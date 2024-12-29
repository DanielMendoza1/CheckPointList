

import XCTest
import CoreData

@testable import CheckPointList

final class EventRepositoryTests: XCTestCase {
    var persistenCointainer: NSPersistentContainer!
    var repository: EventRepository!
    
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
        
        repository = EventRepository(context: persistenCointainer.viewContext)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        persistenCointainer = nil
    }
    
    func testCreateEvent() throws {
        try repository.createEvent(name: "Event1", date: Date())
        
        let events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.first?.name, "Event1")
    }
    
    func testGetAllEvents() throws {
        try repository.createEvent(name: "Event2", date: Date())
        try repository.createEvent(name: "Event3", date: Date())

        let events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.map { $0.name }, ["Event2", "Event3"])
    }
    
    func testGetAllEventsEmpty() throws {
        let events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 0)
    }
    
    func testGetEventByName() throws {
        try repository.createEvent(name: "Event4", date: Date())
        try repository.createEvent(name: "Event5", date: Date())
        
        let event4 = try repository.getEventsByName(for: "Event4")
        let event5 = try repository.getEventsByName(for: "Event5")
        
        XCTAssertEqual(event4.count, 1)
        XCTAssertEqual(event4.first?.name, "Event4")
        
        XCTAssertEqual(event5.count, 1)
        XCTAssertEqual(event5.first?.name, "Event5")
    }
    
    func testGetEventByNotFoundName() throws {
        let notFoundEvent = try repository.getEventsByName(for: "NotFoundName")
        XCTAssertEqual(notFoundEvent.count, 0)
    }
    
    func testDeleteEvent() throws {
        try repository.createEvent(name: "Event6", date: Date())
        try repository.createEvent(name: "Event7", date: Date())

        var events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.map { $0.name }, ["Event6", "Event7"])
        
        let event6 = events.filter { $0.name == "Event6" }.first
        try repository.deleteEvent(for: event6!)
        
        events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.map { $0.name }, ["Event7"])
    }
    
    func testDeleteNotExistingEvent() throws {
        try repository.createEvent(name: "Event8", date: Date())
        try repository.createEvent(name: "Event9", date: Date())

        var events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 2)
        XCTAssertEqual(events.map { $0.name }, ["Event8", "Event9"])
        
        let event8 = events.filter { $0.name == "Event8" }.first
        try repository.deleteEvent(for: event8!)
        
        events = try repository.getAllEvents()
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.map { $0.name }, ["Event9"])
        
        try repository.deleteEvent(for: event8!)
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events.map { $0.name }, ["Event9"])
    }
}
