import Foundation
protocol EventDateRepositoryProtocol {
    func getMostRecentEventDateByEvent(for event: Event) throws -> EventDate?
    func getAllEventDatesByEvent(for event: Event) throws -> [EventDate]
    func getEventDateByDate(for event: Event, by date: Date) throws -> [EventDate]
    func updateDateToNow(for event: Event) throws
}
