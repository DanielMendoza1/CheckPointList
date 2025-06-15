@testable import CheckPointList
import Foundation

class FailingEventRepository: EventRepositoryProtocol {
    
    let ERRORCODE: Int = 999
    let DOMAIN: String = "TestError"
    
    func getAllEvents() throws -> [CheckPointList.Event] {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func getEventsByName(for name: String) throws -> [CheckPointList.Event] {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func getEventById(for id: UUID) throws -> CheckPointList.Event? {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func createEvent(name: String, date: Date) throws {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func deleteEvent(for event: CheckPointList.Event) throws {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
}
