
import XCTest

@testable import CheckPointList

final class UtilsTest: XCTestCase {
    func testRemoveTimeFromDate() {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 15, minute: 30, second: 45, of: Date())!
        
        let result = Utils.removeTimeFromDate(of: date)
        let expectedDate = calendar.startOfDay(for: date)
        XCTAssertEqual(result, expectedDate, "La hora deberia no existir en la fecha")
    }
    
    func testCalculateDaysUntilNow() {
        let calendar = Calendar.current
        let pastDate = calendar.date(byAdding: .day, value: -10, to: Date())!
        
        let result = Utils.calculateDaysUntilNow(from: pastDate)
        XCTAssertEqual(result, "10", "El cálculo de días hasta ahora debería ser 10.")
    }
    
    func testFormatDateToTextDefaultLocale() {
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 25))!
        let result = Utils.formatDateToText(of: date)
            
    XCTAssertEqual(result, "lunes, dic 25, 2023", "El formato de fecha por defecto debería coincidir con lo esperado.")
    }
    
    func testFormatDateToTextCustomFormat() {
        let date = Calendar.current.date(from: DateComponents(year: 2023, month: 12, day: 25))!
        let format = "yyyy-MM-dd"
        
        let result = Utils.formatDateToText(of: date, format: format)
        XCTAssertEqual(result, "2023-12-25", "El formato personalizado debería coincidir con lo esperado.")
    }
}


