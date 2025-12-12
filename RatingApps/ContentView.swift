//
//  ContentView.swift
//  RatingApps
//
//  Created by Iqbal Alhadad on 12/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Detail View"){
                   Text("Hello from Detail View")
                        .onAppear {
                           let count = UserDefaults.standard.integer(forKey: "ScreenCount")
                            UserDefaults.standard.set(count + 1, forKey: "ScreenCount")
                        }
                }
            }
            .navigationTitle("App Rating")
            .presentAppRating {
                let count = UserDefaults.standard.integer(forKey: "ScreenCount")
                return count >= 2
            } askLaterCondition: {
                let count = UserDefaults.standard.integer(forKey: "ScreenCount")
                return count >= 4
            }
        }
    }
}

#Preview {
    ContentView()
}
