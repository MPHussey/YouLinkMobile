//
//  MainTabView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-21.
//

import SwiftUI

struct MainTabView: View {
    enum Tab{case home,chats,notifications,profile}
    @State private var selected:Tab = .home;
    
    var body: some View {
        ZStack{
            Group{
                switch selected {
                case .home:
                    NavigationStack{HomeView()}
                case .chats:
                    NavigationStack{TestView()}
                case .notifications:
                    NavigationStack{Text("Notification View")}
                case .profile:
                    NavigationStack{ProfileView()}
                }
            
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            VStack{
                Spacer()
                CustomTabBar(selected: $selected)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


struct CustomTabBar: View {
  @Binding var selected: MainTabView.Tab

  var body: some View {
    ZStack {
      // Background
      Rectangle()
            .fill(Color(hex:"#05497B"))
        .frame(height: 90)
        .shadow(radius: 2)

        HStack(spacing:25) {
        tabItem(.home,"home-reg-icon","Home")
        tabItem(.chats,"chat-reg-icon","Chats")
        Spacer(minLength: 0)
        tabItem(.notifications,"notification-reg-icon","Notifications", badge: 2)
        tabItem(.profile,"profile-reg-icon","Profile")
      }
      .padding(.horizontal, 30)
      .frame(height: 60)

      // Center logo
      Button {
        // handle tap if needed
      } label: {
        Image("bottom-nav-logo") // add "YourLogo" asset in Assets.xcassets
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
          .padding(20)
          .background(Color.white)
          .clipShape(Circle())
          .shadow(radius: 4)
      }
      .offset(y: -40)
    }
  }


    @ViewBuilder
     private func tabItem(
       _ tab: MainTabView.Tab,
       _ imageName: String,
       _ title: String,
       badge: Int? = nil
     ) -> some View {
       Button {
         selected = tab
       } label: {
         VStack(spacing: 4) {
           ZStack(alignment: .topTrailing) {
             Image(imageName)
                   .resizable()
                   .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                   .foregroundColor(selected == tab ? .white: .gray )
                   .frame(width:27,height:25)

             if let count = badge, count > 0 {
               Text("\(count)")
                 .font(.caption2)
                 .foregroundColor(.white)
                 .padding(4)
                 .background(Color.red)
                 .clipShape(Circle())
                 .offset(x: 8, y: -8)
             }
           }
           Text(title)
                 .font(.system(size:12))
             .foregroundColor(selected == tab ? .white : .gray)
         }
       }
     }
   }

   struct MainTabView_Previews: PreviewProvider {
     static var previews: some View {
       MainTabView()
     }
   }
