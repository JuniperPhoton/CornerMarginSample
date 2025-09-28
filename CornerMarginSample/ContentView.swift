//
//  ContentView.swift
//  CornerMarginSample
//
//  Created by juniperphoton on 9/28/25.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.cornerAdaptationMargin) private var cornerAdaptationMargin
    
    @State private var showSafeAreaBackground: Bool = true
    @State private var showCornerAdaptationMarginBackground: Bool = true
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("My Title")
                    .font(.largeTitle.bold())
                    .padding(.leading, cornerAdaptationMargin.leading)
                
                Rectangle()
                    .fill(.red)
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                
                IconButton()
            }
            
            Spacer()
            
            VStack {
                Text("SafeAreaInsets")
                    .bold()
                
                Text(String(describing: safeAreaInsets))
                
                Text("CornerAdaptationMargin")
                    .bold()
                    .padding(.top)
                Text(String(describing: cornerAdaptationMargin))
            }.padding()
            
            VStack {
                Toggle(isOn: $showSafeAreaBackground.animation()) {
                    HStack {
                        Text("SafeAreaInsets Background")
                        Circle().fill(Color.cyan).frame(width: 20, height: 20)
                    }
                }
                
                Toggle(isOn: $showCornerAdaptationMarginBackground.animation()) {
                    HStack {
                        Text("CornerAdaptationMargin Background")
                        Circle().fill(Color.yellow).frame(width: 20, height: 20)
                    }
                }
            }.padding()
                .frame(maxWidth: 500)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 12))
                .padding()
            
            Spacer()
        }
        .background {
            if showSafeAreaBackground {
                Color.cyan
                    .padding(safeAreaInsets)
                    .ignoresSafeArea()
            }
            
            if showCornerAdaptationMarginBackground {
                Color.yellow
                    .padding(cornerAdaptationMargin)
                    .ignoresSafeArea()
            }
        }
        .animation(.default, value: cornerAdaptationMargin)
        .animation(.default, value: safeAreaInsets)
    }
}

private struct IconButton: View {
    var body: some View {
        Image(systemName: "ellipsis")
            .imageScale(.large)
            .foregroundStyle(.tint)
            .padding()
            .background(Circle().fill(.regularMaterial))
    }
}
