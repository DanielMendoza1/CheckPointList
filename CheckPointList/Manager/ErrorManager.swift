import Foundation

class ErrorManager: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false

    func showError(for errorMessage: String) {
        DispatchQueue.main.async {
            self.errorMessage = errorMessage
            self.showError = true
        }
    }

    func resetError() {
        DispatchQueue.main.async {
            self.errorMessage = ""
            self.showError = false
        }
    }
}
