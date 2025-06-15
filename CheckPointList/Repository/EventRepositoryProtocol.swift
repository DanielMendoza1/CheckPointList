import Foundation
protocol EventRepositoryProtocol {
    func getAllEvents() throws -> [Event]
    func getEventsByName(for name: String) throws -> [Event]
    func getEventById(for id: UUID) throws -> Event?
    func createEvent(name: String, date: Date) throws
    func deleteEvent(for event: Event) throws
}
