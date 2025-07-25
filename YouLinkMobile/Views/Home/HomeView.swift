import SwiftUI
import SwiftUIPager
import ACarousel

struct HomeView: View {
    @StateObject private var vm=HomeViewModel()
    @State private var featuredLinkSelection: Int?
    @Environment(\.openURL) private var openURL
    
    // CORRECT: The pager's state MUST be of type `Page`.
    @State private var page: Page = .first()
    @State private var currentIndex: Int = 1
    
    
    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }
    var body: some View {
        
        VStack(spacing: 0) {
            // Assuming HeaderView is a custom view you have defined elsewhere
            HeaderView(staffName: vm.loggedInUserDetails!.staffName, profileImageName: vm.loggedInUserDetails!.profilephoto)
            
            ScrollView {
                VStack {
                    
                    ACarousel(vm.mainCarouselItems,
                              id: \.id,
                              index: $currentIndex,
                              spacing: 30,
                              headspace: 10,
                              sidesScaling: 0.7,
                              isWrap: true,
                              autoScroll: .active(8)) { item in
                        Image(item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 370, height: 450)
                        
                            .cornerRadius(12)
                    }
                              .frame(height: 200)
                    
                    
                    //quick action buttons
                    GeometryReader{ geo in
                        let totalWidth=geo.size.width
                        let buttonWidth=(totalWidth - 40) / CGFloat(vm.quickButtons.count)
                        let circleSize=buttonWidth * 1
                        
                        HStack(spacing: (totalWidth - (circleSize * CGFloat(vm.quickButtons.count))) / CGFloat(vm.quickButtons.count - 1)){
                            ForEach(vm.quickButtons, id: \.title){action in
                                VStack(spacing:6){
                                    Button{
                                        if let url = URL(string: action.redirectUrl) {
                                            openURL(url)
                                        }
                                    } label: {
                                        Image(action.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: circleSize * 0.5, height: circleSize * 0.5)
                                            .padding((circleSize - circleSize * 0.6) / 2)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .overlay(
                                                Circle()
                                                    .stroke(action.borderColor,lineWidth:1)
                                            )
                                            .shadow(color:action.borderColor.opacity(0.5),
                                                    radius:3,x:0,y:2)
                                    }
                                    Text(action.title)
                                        .font(.caption)
                                        .foregroundColor(.primary)
                                }
                                .frame(width:buttonWidth)
                            }
                        }
                        .frame(width: totalWidth)
                    }
                    .frame(height:100)
                    .padding(.horizontal,20)
                    
                    //featured links
                    FeaturedLinksView(
                        links:vm.featuredLinks, selectedIndex: $featuredLinkSelection
                    )
                    
                    //Highlight section
                    HighlightChipView(highlightLinks:vm.highlights)
                    //Flight fleet view
                    FlightFleetView(flightFleetDataset:vm.fleetCardDataset)
                    //currency rates
                    CurrencyRatesView(rates:vm.currencyRates)
                    //Article view
                    ArticleView(articles:vm.articles)
                    
                }
                .padding(.bottom, 80 + safeAreaBottom())
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear(){
            vm.getCompanyEvent()
            vm.getExchangeRates()
            vm.getFlightInformation()
        }
    }
    
    
}


//
//#Preview {
//    HomeView()
//}
