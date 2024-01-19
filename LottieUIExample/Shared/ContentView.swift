//
//  ContentView.swift
//  LottieUIExample
//
//  Created by jasu on 2022/02/12.
//  Copyright (c) 2022 jasu All rights reserved.
//

import SwiftUI
import LottieUI
import Scroller

struct ContentView: View {
    
    let state1 = LUStateData(type: .name("bubble1", .main), loopMode: .loop)
    let state2 = LUStateData(type: .loadedFrom(URL(string: "https://assets9.lottiefiles.com/packages/lf20_mniampqn.json")!), speed: 1.0, loopMode: .loop)
    let state3 = LUStateData(type: .filepath("/Users/jasu/Downloads/bubble2.json"), speed: 1.0, loopMode: .loop)
    
    let state4 = LUStateData(type: .name("tree1", .main), loopMode: .loop, isControlEnabled: true)
    let state5 = LUStateData(type: .filepath("/Users/jasu/Downloads/tree3.json"), speed: 1.0, loopMode: .loop, isControlEnabled: true)
    let state6 = LUStateData(type: .loadedFrom(URL(string: "https://assets1.lottiefiles.com/packages/lf20_wcjgoacf.json")!), speed: 1.0, loopMode: .loop, isControlEnabled: true)
    
    @State private var selected: Int = 0
    @State private var scrollerValue: CGFloat = 0
    
    var content: some View {
        TabView(selection: $selected) {
            ScrollView {
                if selected == 0 {
                    VStack {
                        CustomStateView(state: state1)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .frame(height: 300)
                        CustomStateView(state: state2)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .frame(height: 300)
                        CustomStateView(state: state3)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .frame(height: 300)
                    }
                    .padding()
                }
            }
            .tag(0)
            .tabItem {
                Image(systemName: "scribble.variable")
                Text("LottieUI")
            }
            
            Scroller(.horizontal, showsIndicators: true, value: $scrollerValue) {
                GeometryReader { proxy in
                    ScrollerLottieContent(value: proxy.scrollerValue(.horizontal), state: state4)
                        .overlay(
                            Text("Horizontal Scroll →")
                                .offset(x: proxy.size.width * proxy.scrollerValue(.horizontal))
                                .opacity(1.0 - proxy.scrollerValue(.horizontal) * 16.0)
                        )
                }
                .background(Color.red.opacity(0.2))
                GeometryReader { proxy in
                    ScrollerLottieContent(value: proxy.scrollerValue(.horizontal), state: state5)
                }
                .background(Color.green.opacity(0.2))
                GeometryReader { proxy in
                    ScrollerLottieContent(value: proxy.scrollerValue(.horizontal), state: state6)
                }
                .background(Color.blue.opacity(0.2))
            } lastContent: {
                Text("LottieUI with Scroller.")
            }
            .tag(1)
            .tabItem {
                Image(systemName: "scroll")
                Text("LottieUI+Scroller")
            }
        }
    }
    
    var body: some View {
#if os(iOS) || os(visionOS)
        NavigationView {
            content
                .navigationTitle(Text("LottieUI"))
                .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(.stack)
#else
        content
            .padding()
#endif
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
