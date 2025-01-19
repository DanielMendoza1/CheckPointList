import XCTest

final class CheckPointListUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    @MainActor
    func testOpenAddEventView() throws {
        let addEventButton: XCUIElement = app.buttons["AddEventButton"]
        
        XCTAssertTrue(addEventButton.exists, "El boton de agregar evento no existe.")
        
        addEventButton.tap()
        let eventDetailsSectionHeader: XCUIElement =  app.staticTexts["eventDetailsSectionHeader"]
        
        XCTAssertTrue(eventDetailsSectionHeader.exists, "El encabezado de la seccion de detalles de evento no fue encontrada.")
    }
    
    @MainActor
    func testCreateEvent() throws {
        let addEventButton: XCUIElement = app.buttons["AddEventButton"]
        
        XCTAssertTrue(addEventButton.exists, "El boton de agregar evento no existe.")
        
        addEventButton.tap()
        let eventDetailsSectionHeader: XCUIElement =  app.staticTexts["eventDetailsSectionHeader"]
        
        XCTAssertTrue(eventDetailsSectionHeader.exists, "El encabezado de la seccion de detalles de evento no fue encontrada.")
        
        let nameTextField: XCUIElement = app.textFields["nameTextField"]
        
        XCTAssertTrue(nameTextField.exists, "El campo de texto para el nombre no existe.")
        
        nameTextField.tap()

        nameTextField.typeText("Event1")
                
        let eventDatePicker = app.datePickers.element(boundBy: 0)
        
        XCTAssert(eventDatePicker.exists, "El date picker par el evento no existe.")
        
        eventDatePicker.tap()

        let dateButton: XCUIElement = eventDatePicker.collectionViews.buttons["Wednesday, 22 January"]

        XCTAssertTrue(dateButton.exists, "El boton del dia 22 no existe.")

        dateButton.tap()
        nameTextField.tap()

        let saveButton: XCUIElement = app.buttons["saveButton"]
        
        XCTAssertTrue(saveButton.exists, "El boton de guardar no existe.")
        
        saveButton.tap()
        
        let eventItem: XCUIElement = app.staticTexts["event_Event1"]
        
        XCTAssertTrue(eventItem.exists, "El evento Event1 no fue encontrado en la lista de eventos.")
    }
}
