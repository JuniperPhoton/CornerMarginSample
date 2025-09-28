//
//  StandardContentView.swift
//  CornerMarginSample
//
//  Created by juniperphoton on 9/28/25.
//
import SwiftUI

struct StandardContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("StandardContentView")
            }.navigationTitle("My app")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Info", systemImage: "info") {
                            // ignored
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("More", systemImage: "ellipsis") {
                            // ignored
                        }
                    }
                }
        }
    }
}
