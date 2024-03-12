import SwiftUI

struct ChoosePersonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var receivers: [Receiver] = [] // Array to hold fetched receivers

    private var dataManager = DataManager.shared // Accessing the shared instance
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @State private var navigateToWriteMessage = false

    var body: some View {
        VStack {
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            if receivers.isEmpty {
                Text("No previous receivers found.")
                    .padding()
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 16))
            } else {
                ScrollView {
                    ForEach(receivers, id: \.self) { receiver in
                        Button(action: {
                            receiverViewModel.name = receiver.name ?? ""
                            receiverViewModel.userNickname = receiver.userNickname ?? ""
                            receiverViewModel.telephoneNumber = receiver.telephoneNumber ?? ""
                            navigateToWriteMessage = true
                        }) {
                            Text(receiver.name ?? "Unknown Receiver")
                                .font(.custom("Chillax", size: 16))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                } // This closes the ScrollView
            } // This closes the else clause
            
            Spacer()
            
            NavigationLink(destination: ManuallyOrContactView()) {
                Text("Add new one")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                    .padding(.bottom, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
            self.receivers = dataManager.fetchReceivers()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }
        .background(
            NavigationLink(destination: WriteMessageView(), isActive: $navigateToWriteMessage) {
                EmptyView()
            }
            .hidden()
        )
    }
}

struct ChoosePersonView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePersonView()
    }
}
