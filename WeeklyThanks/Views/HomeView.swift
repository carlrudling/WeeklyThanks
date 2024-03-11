//
//  HomeView.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-02-29.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel

    var body: some View {
        VStack{
            
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 80)
                .foregroundColor(.white)
            
            
            Text("Reflect over the week. Anything you want to thank someone for? Remember the small things counts.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            HStack{
              
                
                Text("\(userViewModel.count) cards sent")
                    .font(.custom("Chillax", size: 12))
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.buttonColorLight)
                    .font(.system(size: 12))
            }
            
            Spacer()
            
            NavigationLink(destination: ChoosePersonView()) {
                         Text("write a card")
                             .font(.custom("Chillax", size: 18))
                             .foregroundColor(.gray)
                             .frame(width: 300, height: 50)
                             .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                             .padding(.bottom, 40)

                     }
            
            
            
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen

        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
                    userViewModel.fetchCurrentUser()
                }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let userViewModel = UserViewModel()

        HomeView()
            .environmentObject(userViewModel)

    }
}
