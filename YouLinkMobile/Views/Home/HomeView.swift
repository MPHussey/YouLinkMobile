import SwiftUI
import SwiftUIPager

struct HomeView: View {
    // Array of image names for the slider
    let slideImages = ["slide1", "slide1", "slide1"]
    
    // CORRECT: The pager's state MUST be of type `Page`.
    @State private var page: Page = .first()
    
    var items = Array(0..<10)

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
                              .frame(width: 300, height: 400)
                              .clipped()
                              .cornerRadius(12)

                            
                        })
                    .singlePagination(ratio: 0.33, sensitivity: .custom(0.2))
                       .preferredItemSize(CGSize(width: 300, height: 400))
                       .interactive(rotation: true)
                           .interactive(scale: 0.7)
                       .frame(height: 150)
                    
                }
            }
        }
        .ignoresSafeArea(edges: .top)
    }


}



#Preview {
    // You might need to add a placeholder image named "slide1"
    // to your development assets for the preview to work correctly.
    HomeView()
}
