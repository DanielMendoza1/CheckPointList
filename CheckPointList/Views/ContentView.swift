import SwiftUICore
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        EventListView(context: viewContext)
    }
}
