//
//  HomeView.swift
//  ArroSocial
//
//  Created by Derek Hsieh on 2/23/22.
//

import SwiftUI

struct HomeView: View {
    @State var selectedTab = "house"
    
    @State var tabBarCenter: CGFloat = 0
    @Namespace var animation
    
    
    init() {
        // hidden since tab bar will be custom
        UITabBar.appearance().isHidden = true
        
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selectedTab) {
                Color.green
                    .overlay(Text("home"))
                    .tag("house")
                    .ignoresSafeArea(.all, edges: .all)
                Color.blue
                    .overlay(Text("explore"))
                    .tag("globe.americas")
                    .ignoresSafeArea(.all, edges: .all)
                Color.yellow
                    .overlay(Text("activity"))
                    .tag("bell")
                    .ignoresSafeArea(.all, edges: .all)
                Color.purple
                    .overlay(Text("settings"))
                    .tag("gear")
                    .ignoresSafeArea(.all, edges: .all)
            }
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation(.spring()) {
                                self.selectedTab = image
                                tabBarCenter = reader.frame(in: .global).minX
                            }
                        }) {
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .modifier(Poppins(fontWeight: selectedTab == image ? AppFont.semiBold : AppFont.medium))
                                .foregroundColor(selectedTab == image ? Color.black : Color.gray)
//                                .fontWeight(selectedTab == image ? .bold : .none)
                                .padding(selectedTab == image ? 15 : 0)
                                .background(Color.white.opacity(selectedTab == image ? 1 : 0))
                                .matchedGeometryEffect(id: image, in: animation)
                                .clipShape(Circle())
                                .offset(x: reader.frame(in: .global).minX - reader.frame(in: .global).midX ,y: selectedTab == image ? -50 : 0)
                            
                        }
                        .onAppear() {
                            if image == tabs.first {
                                tabBarCenter = reader.frame(in: .global).minX
                            }
                        }
                    }
                    
                    .frame(width: 25, height: 25)
                    
                    if image != tabs.last{
                        // dynamically render spacing
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal , 30)
            .padding(.vertical)
            .background(Color.white.clipShape(CurveShape(center: tabBarCenter)).cornerRadius(12))
            .padding(.horizontal)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    
}

var tabs = ["house", "globe.americas", "bell", "gear"]

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


// tab view curve
struct CurveShape: Shape {
    
    var center: CGFloat
    var animatableData: CGFloat {
        get {return center}
        set{center = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = center
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25, y: 0)
            let control2 = CGPoint(x: center - 25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25, y: 35)
            let control4 = CGPoint(x: center + 25, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}
