import SwiftUI
import SwiftUIPager

struct HomeView: View {
    @StateObject private var vm=HomeViewModel()
    @State private var featuredLinkSelection: Int?
    // Array of image names for the slider
    let slideImages = ["slide1", "slide1", "slide1"]
    
    let quickActionButtons = [
        QuickAction(image: "sara-qa-icon",        title: "SARA",         hex: "#0247A8"),
        QuickAction(image: "hrspace-qa-icon",     title: "HR Space",     hex: "#EB6127"),
        QuickAction(image: "staff-travel-qa-icon",title: "Staff Travel", hex: "#0E9147"),
        QuickAction(image: "medi-cash-qa-icon",   title: "MediCash",     hex: "#D71E43")
    ]
    
    
    // CORRECT: The pager's state MUST be of type `Page`.
    @State private var page: Page = .first()
    
    var items = Array(0..<10)
    
    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }

    
    var body: some View {
        VStack(spacing: 0) {
            // Assuming HeaderView is a custom view you have defined elsewhere
            HeaderView(staffName: "Hasantha Pathirana", profileImageName: "placeholder")
            
            ScrollView {
                VStack {
                    Pager(page: page,
                          data: items,
                          id: \.self,
                          content: { index in
                        Image("slide1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 370, height: 450)
                            .clipped()
                            .cornerRadius(12)
                        
                        
                    })
                    .singlePagination(ratio: 0.33, sensitivity: .custom(0.2))
                    .preferredItemSize(CGSize(width: 350, height: 400))
                    .interactive(rotation: true)
                    .interactive(scale: 0.7)
                    .frame(height: 200)
                    
                    //quick action buttons
                    GeometryReader{ geo in
                        let totalWidth=geo.size.width
                        let buttonWidth=(totalWidth - 40) / CGFloat(quickActionButtons.count)
                        let circleSize=buttonWidth * 1
                        
                        HStack(spacing: (totalWidth - (circleSize * CGFloat(quickActionButtons.count))) / CGFloat(quickActionButtons.count - 1)){
                            ForEach(quickActionButtons, id: \.title){action in
                                VStack(spacing:6){
                                    Button{
                                        
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
                    Spacer()
                    
                }
                .padding(.bottom, 80 + safeAreaBottom())
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    
}


struct QuickAction {
    let image: String
    let title: String
    let hex: String
    
    // Convenience computed property
    var borderColor: Color { Color(hex: hex) }
}


#Preview {
    // You might need to add a placeholder image named "slide1"
    // to your development assets for the preview to work correctly.
    HomeView()
}
