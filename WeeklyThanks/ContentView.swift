import SwiftUI

struct ContentView: View {
    @State private var userExists = false
    // Instantiate the UserViewModel

    var body: some View {
        NavigationStack {
            if userExists {
                // Pass the UserViewModel as an EnvironmentObject to HomeView
                // HomeView()
                TestView()

            } else {
                // Also ensure StartView has access to UserViewModel if needed
                StartView()
            }
        }
        .onAppear {
            checkUserExistence()
        }
    }
    
    private func checkUserExistence() {
        let users = DataManager.shared.fetchUsers()
        userExists = !users.isEmpty
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
