import SwiftUI

struct RemoveReceiverView: View {
    @Binding var isPresented: Bool
    
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @State private var selectedReceivers: [UUID: Bool] = [:]
    
    // Define a public initializer
        public init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
        }
    
    var body: some View {
        VStack {
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            if receiverViewModel.receivers.isEmpty {
                Text("No previous friends found.")
                    .padding()
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 16))
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(receiverViewModel.receivers, id: \.self) { receiver in
                        Button(action: {
                                    // Toggle the selected state for this receiver
                                    let isSelected = selectedReceivers[receiver.id ?? UUID()] ?? false
                                    selectedReceivers[receiver.id ?? UUID()] = !isSelected
                                }) {
                                    HStack {
                                        Text(receiver.name ?? "Unknown Receiver")
                                            .font(.custom("Chillax", size: 18))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: selectedReceivers[receiver.id ?? UUID()] ?? false ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedReceivers[receiver.id ?? UUID()] ?? false ? .red : .white)
                                            .font(.custom("Chillax", size: 16))
                                    }
                                    .padding()
                                    .foregroundColor(.clear)
                                }
//                                .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to avoid any default button styling
                    }

                }
            }
            
            Spacer()
            
            Button(action: {
                // Filter out the receivers that are selected for deletion
                let receiversToDelete = receiverViewModel.receivers.filter { selectedReceivers[$0.id ?? UUID()] ?? false }
                // Call the delete method for each selected receiver
                for receiver in receiversToDelete {
                    receiverViewModel.deleteReceiver(receiver: receiver)
                }
                // Clear the selected receivers
                selectedReceivers.removeAll()
                isPresented = false // <-- This will dismiss the view

            }) {
                Text("Delete Selected Receivers")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.red.opacity(selectedReceivers.count > 0 ? 1.0 : 0.5)))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 10)
            }


            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
          
             selectedReceivers = [:]
        }
    }
}


//#Preview {
//    RemoveReceiverView()
//}
