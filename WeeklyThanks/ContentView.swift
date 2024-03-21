import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: NavigationCoordinator
    @State private var userExists = false
    

    var body: some View {
        NavigationStack(path: $coordinator.paths){
            if userExists {
                // Pass the UserViewModel as an EnvironmentObject to HomeView
                 HomeView()
                    .navigationDestination(for: Screen.self) { screen in
                               switch screen {
                               case .home:
                                   HomeView()
                               case .choosePerson:
                                   ChoosePersonView()
                               case .manuallyOrContact:
                                   ManuallyOrContactView()
                               case .Contacts:
                                   ContactsView()
                               case .addNewMember:
                                   AddNewMemberView()
                               case .WriteMessage:
                                   WriteMessageView()
                               case .afterSentCard:
                                   AfterSentCardView()
                               }
                           }

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
        if userExists {
            print("User Exist")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class NavigationCoordinator: ObservableObject {
    @Published var paths = NavigationPath()

    func push(_ screen: Screen) {
        // You can customize this method to add views to the navigation path
        paths.append(screen)

    }

    func popToRoot() {
        paths = NavigationPath() // This reinitializes the path, clearing the navigation stack

       }
}


enum Screen {
    case home
    case choosePerson
    case manuallyOrContact
    case Contacts
    case addNewMember
    case WriteMessage
    case afterSentCard
    
}
