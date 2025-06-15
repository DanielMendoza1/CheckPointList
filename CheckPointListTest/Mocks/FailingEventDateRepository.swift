@testable import CheckPointList
import Foundation

class FailingEventDateRepository: EventDateRepositoryProtocol {
    
    let ERRORCODE: Int = 999
    let DOMAIN: String = "TestError"
    
    func getMostRecentEventDateByEvent(for event: CheckPointList.Event) throws -> CheckPointList.EventDate? {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func getAllEventDatesByEvent(for event: CheckPointList.Event) throws -> [CheckPointList.EventDate] {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func getEventDateByDate(for event: CheckPointList.Event, by date: Date) throws -> [CheckPointList.EventDate] {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
    
    func updateDateToNow(for event: CheckPointList.Event) throws {
        throw NSError(domain: DOMAIN, code: ERRORCODE)
    }
}
