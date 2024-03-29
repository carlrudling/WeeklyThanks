//
//  WeUseNotificationsView.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-03-22.
//

import SwiftUI

struct WeUseNotificationsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    var name: String
    var sendCardGoal: Int

    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            Text("Stay consistent with\nOne reflection notification per week &\nreminders ones a day, only if you forget. ")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            
            Image(systemName: "bell.fill")
                .font(.system(size: 50))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, 30)
            
            Spacer()
            
            Button(action: {
                userViewModel.createUser(name: name, sendCardGoal: sendCardGoal)
                userViewModel.checkUserExistence()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    coordinator.push(.home)
                }
                NotificationManager.shared.requestAuthorization()



            }) {
                Text("Start")
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
        .onAppear{
            print(name)
            print(sendCardGoal)
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
        }
    }
}

#Preview {
    WeUseNotificationsView(name: "Something", sendCardGoal: 2)
}
