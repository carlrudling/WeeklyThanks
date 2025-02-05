import SwiftUI

struct ManuallyOrContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @State private var navigateToAddNewMember = false
    @EnvironmentObject var coordinator: NavigationCoordinator

    var body: some View {
        VStack {
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            

            Spacer()
          
            VStack{

                Button(action: {
                    coordinator.push(.Contacts)

                }, label: {
                    Text("Add from contacts")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                })
                .padding(.bottom, 10)
                
                
                Button(action: {
                             receiverViewModel.cleanValues()
                            coordinator.push(.addNewMember)

                         }) {
                             Text("Add manually")
                                 .font(.custom("Chillax", size: 18))
                                 .foregroundColor(.gray)
                                 .frame(width: 300, height: 50)
                                 .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                                 .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                         }
                         
                Spacer()
                
                
            }
            .padding(.top, 100)
        
           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen

        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }
    }
}

struct ManuallyOrContactView_Previews: PreviewProvider {
    static var previews: some View {
        ManuallyOrContactView()
    }
}
