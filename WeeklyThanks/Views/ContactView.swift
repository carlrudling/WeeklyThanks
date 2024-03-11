import SwiftUI
import Contacts

struct ContactsView: View {
    @State private var contacts: [CNContact] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    private let contactsManager = ContactsManager() // Instance of ContactsManager
    
    init() {
        // Customize the appearance of the list and its rows
        UITableView.appearance().backgroundColor = .clear // Make UITableView background clear
        UITableViewCell.appearance().backgroundColor = .clear // Make UITableViewCell background clear
    }
    
    var body: some View {
        ZStack {
            // Set your gradient or custom background here
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            
            
            
            
            // Now the List
            List(contacts, id: \.identifier) { contact in
                VStack(alignment: .leading) {
                    Text(contact.givenName + " " + contact.familyName)
                        .foregroundColor(.white) // Customize text color
                    ForEach(contact.phoneNumbers, id: \.value.stringValue) { phoneNumber in
                        Text(phoneNumber.value.stringValue)
                            .foregroundColor(.white) // Customize text color
                    }
                }
                .listRowBackground(Color.clear) // Make individual row background clear
            }
            .listStyle(PlainListStyle()) // Use PlainListStyle for more control over styling
            .padding(.top, 20)
        }
        .onAppear {
            contactsManager.requestAccessToContacts { granted in
                if granted {
                    contactsManager.fetchContacts { fetchedContacts in
                        self.contacts = fetchedContacts
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
            ToolbarItem(placement: .principal) {
                                Text("Contacts") // Additional text in the toolbar
                                    .font(.custom("Chillax", size: 25))
                                    .foregroundColor(.white)
                            }
        }
    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
