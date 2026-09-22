import SwiftUI
import SwiftUIPager
import ACarousel

struct HomeView: View {
    @StateObject private var vm=HomeViewModel()
    @State private var featuredLinkSelection: Int?
    @Environment(\.openURL) private var openURL
    
    @State private var currentIndex: Int = 0

    //carousel layout: the centre slide is shown in full and `headspace`
    //points of the neighbouring slides peek in on both sides
    private let carouselSpacing: CGFloat = 10
    private let carouselHeadspace: CGFloat = 28
    //aspect ratio of the slides served by the api (1263 x 850)
    private let carouselAspectRatio: CGFloat = 1263.0 / 850.0

    @State private var carouselWidth: CGFloat = UIScreen.main.bounds.width

    //height that makes the centre slide exactly as tall as its own width allows
    private var carouselHeight: CGFloat {
        let itemWidth = max(0, carouselWidth - (carouselHeadspace + carouselSpacing) * 2)
        return itemWidth / carouselAspectRatio
    }

    @Binding var viewAllFeaturesStatus:Bool
    @Binding var selectedTab: MainTabView.Tab

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }
    var body: some View {
        
        VStack(spacing: 0) {
            // Assuming HeaderView is a custom view you have defined elsewhere
            HeaderView(
                staffName: vm.loggedInUserDetails!.staffName,
                profileImageName: vm.loggedInUserDetails!.profilephoto,
                onProfileTap: {
                    selectedTab = .profile
                }
            )
            
            ScrollView {
                VStack {
                    
                    //ACarousel crashes when the index is out of the data range,
                    //so it is only built once the slides have arrived
                    Group {
                        if vm.mainCarouselItems.isEmpty {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.15))
                                .padding(.horizontal, carouselHeadspace + carouselSpacing)
                        } else {
                            ACarousel(vm.mainCarouselItems,
                                      id: \.id,
                                      index: $currentIndex,
                                      spacing: carouselSpacing,
                                      headspace: carouselHeadspace,
                                      sidesScaling: 0.7,
                                      isWrap: true,
                                      autoScroll: .active(8)) { item in
                                carouselSlide(item)
                            }
                        }
                    }
                    .frame(height: carouselHeight)
                    //measure the real width so the height keeps the slide aspect
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: CarouselWidthKey.self,
                                            value: proxy.size.width)
                        }
                    )
                    .onPreferenceChange(CarouselWidthKey.self) { width in
                        if width > 0 { carouselWidth = width }
                    }

                    
                    //quick action buttons
                    GeometryReader{ geo in
                        let totalWidth=geo.size.width
                        let buttonWidth=(totalWidth - 40) / CGFloat(vm.quickButtons.count)
                        let circleSize=buttonWidth * 1
                        
                        HStack(spacing: (totalWidth - (circleSize * CGFloat(vm.quickButtons.count))) / CGFloat(vm.quickButtons.count - 1)){
                            ForEach(vm.quickButtons, id: \.title){action in
                                VStack(spacing:6){
                                    Button{
                                        if let url = URL(apiString: action.redirectUrl) {
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
                    .padding(.vertical,20)
                    
                    //featured links
                    if !vm.featuredLinks.isEmpty {
                        FeaturedLinksView(
                            links:vm.featuredLinks, selectedIndex: $featuredLinkSelection,btnViewAll: $viewAllFeaturesStatus
                        )
                    }
                    
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
            vm.getMainCarousel()
            vm.getQuickLinks()
            vm.getQuickButtonLinks()
        }
        //keep the active index valid whenever the slide count changes
        .onChange(of: vm.mainCarouselItems.count) { _ in
            currentIndex = 0
        }
    }

    //one carousel slide: remote image, tappable when the api sends a url
    @ViewBuilder
    private func carouselSlide(_ item: MainCarousel) -> some View {
        let slide = AsyncImage(url: item.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure:
                ZStack {
                    Color.gray.opacity(0.15)
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                }
            default:
                ZStack {
                    Color.gray.opacity(0.15)
                    ProgressView()
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .cornerRadius(8)

        if let link = item.linkURL {
            Button {
                openURL(link)
            } label: {
                slide
            }
            .buttonStyle(.plain)
        } else {
            slide
        }
    }


}


//reports the width available to the carousel
private struct CarouselWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

//
//#Preview {
//    HomeView()
//}
