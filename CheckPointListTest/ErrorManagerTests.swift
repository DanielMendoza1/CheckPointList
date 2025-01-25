import XCTest

@testable import CheckPointList

final class ErrorManagerTests: XCTestCase {
    
    var errorManager: ErrorManager!

    override func setUpWithError() throws {
        errorManager = ErrorManager()
    }

    override func tearDownWithError() throws {
        errorManager = nil
    }
    
    func testShowError() throws {
        let expectedErrorMessage: String = "Mensaje de error esperado."
        let expectation: XCTestExpectation = XCTestExpectation(description: "Esperando mostrar error")
        
        errorManager.showError(for: expectedErrorMessage)
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.errorManager.errorMessage, expectedErrorMessage)
            XCTAssertTrue(self.errorManager.showError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testResetError() throws {
        let expectedErrorMessage: String = "Mensaje de error esperado."
        let expectationShow: XCTestExpectation = XCTestExpectation(description: "Esperando mostrar error.")
        let expectationReset: XCTestExpectation = XCTestExpectation(description: "Esperando resetear el error.")

        errorManager.showError(for: expectedErrorMessage)
        
        DispatchQueue.main.async {
            XCTAssertEqual(self.errorManager.errorMessage, expectedErrorMessage)
            XCTAssertTrue(self.errorManager.showError)
            expectationShow.fulfill()
        }
        
        wait(for: [expectationShow], timeout: 1.0)
        
        errorManager.resetError()
        
        DispatchQueue.main.async {
            XCTAssertEqual("", self.errorManager.errorMessage)
            XCTAssertFalse(self.errorManager.showError)
            expectationReset.fulfill()
        }
        
        wait(for: [expectationReset], timeout: 1.0)
    }
}
