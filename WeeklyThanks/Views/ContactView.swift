import SwiftUI
import Contacts

struct ContactsView: View {
    @State private var contacts: [CNContact] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    @State private var navigateToaddMembersView: Bool = false

    private let contactsManager = ContactsManager()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack {
                    ForEach(contacts, id: \.identifier) { contact in
                        Button(action: {
                            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                                receiverViewModel.name = "\(contact.givenName)"
                                receiverViewModel.telephoneNumber = phoneNumber
//                                navigateToaddMembersView = true
                                coordinator.push(.addNewMember)

                            }
                        }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(contact.givenName) \(contact.familyName)")
                                        .foregroundColor(.white)
                                    Text(contact.phoneNumbers.first?.value.stringValue ?? "")
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        }
                    }
                }
                .padding(.top, 10)
            }
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
                    Image(systemName: "chevron.backward").foregroundColor(.white).padding(12)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Contacts").font(.custom("Chillax", size: 25)).foregroundColor(.white)
            }
        }

    }
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView()
    }
}
