import SwiftUI

struct ManuallyOrContactView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @State private var navigateToAddNewMember = false

    var body: some View {
        VStack {
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            

            Spacer()
          
            VStack{
                NavigationLink(destination: ContactsView()) {
                    Text("Add from contacts")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))

                }
                .padding(.bottom, 10)
                
                
                Button(action: {
                             receiverViewModel.cleanValues()
                             navigateToAddNewMember = true
                         }) {
                             Text("Add manually")
                                 .font(.custom("Chillax", size: 18))
                                 .foregroundColor(.gray)
                                 .frame(width: 300, height: 50)
                                 .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                         }
                         
                         NavigationLink(destination: AddNewMemberView(), isActive: $navigateToAddNewMember) {
                             EmptyView()
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
