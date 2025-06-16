import XCTest

final class CheckPointListUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        XCTAssertTrue(app.buttons["AddEventButton"].waitForExistence(timeout: 3),
        "la aplicacion no se lanza correctamente")
    }

    @MainActor
    func testOpenAddEventView() throws {
        let addEventButton: XCUIElement = app.buttons["AddEventButton"]
        
        XCTAssertTrue(addEventButton.waitForExistence(timeout: 3), "El boton de agregar evento no existe.")
        
        addEventButton.tap()
        
        let eventDetailsSectionHeader: XCUIElement =  app.staticTexts["eventDetailsSectionHeader"]
        
        XCTAssertTrue(eventDetailsSectionHeader.waitForExistence(timeout: 3),
        "El encabezado de la seccion de detalles de evento no fue encontrada.")
    }
    
    @MainActor
    func testCreateEvent() throws {
        let addEventButton: XCUIElement = app.buttons["AddEventButton"]
        
        XCTAssertTrue(addEventButton.waitForExistence(timeout: 3), "El boton de agregar evento no existe.")
        
        addEventButton.tap()
        
        let eventDetailsSectionHeader: XCUIElement =  app.staticTexts["eventDetailsSectionHeader"]
        
        XCTAssertTrue(eventDetailsSectionHeader.waitForExistence(timeout: 3),
        "El encabezado de la seccion de detalles de evento no fue encontrada.")
      
        let nameTextField: XCUIElement = app.textFields["nameTextField"]
        
        XCTAssertTrue(nameTextField.waitForExistence(timeout: 3), "El campo de texto para el nombre no existe.")
        
        nameTextField.tap()

        nameTextField.typeText("Event1")
                
        let eventDatePicker = app.datePickers.element(boundBy: 0)
        
        XCTAssert(eventDatePicker.waitForExistence(timeout: 3), "El date picker para el evento no existe.")
        
        eventDatePicker.tap()

        let dateButton: XCUIElement = eventDatePicker.collectionViews.buttons.element(boundBy: 6)

        XCTAssertTrue(dateButton.waitForExistence(timeout: 3), "El boton del dia 7 no existe.")

        dateButton.tap()
        nameTextField.tap()

        let saveButton: XCUIElement = app.buttons["saveButton"]
        
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3), "El boton de guardar no existe.")
        
        saveButton.tap()
        
        let eventItem: XCUIElement = app.staticTexts["event_Event1"]
        
        XCTAssertTrue(eventItem.waitForExistence(timeout: 3),
        "El evento Event1 no fue encontrado en la lista de eventos.")
    }
}
