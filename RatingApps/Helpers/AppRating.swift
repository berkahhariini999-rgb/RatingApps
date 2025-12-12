//
//  AppRating.swift
//  RatingApps
//
//  Created by Iqbal Alhadad on 12/12/25.
//

import SwiftUI
import StoreKit

extension View {
    @ViewBuilder
    func presentAppRating (
        initialCondition: @escaping () async -> Bool,
        askLaterCondition: @escaping () async -> Bool
    ) -> some View {
        self
            .modifier(
                AppRatingModifier (
                    initialCondition: initialCondition, askLaterCondition: askLaterCondition
                )
            )
    }
}

fileprivate
struct AppRatingModifier: ViewModifier {
    var initialCondition: () async -> Bool
    var askLaterCondition: () async -> Bool
    //view properties
    @AppStorage("isRatingInteractionComplete") private var isCompleted: Bool = false
    @AppStorage("isInitialPromptComplete") private var isInitialPromptShown: Bool = false
    @State private var showAlert:Bool = false
    @Environment(\.requestReview) private var requestReview
    func body(content: Content) -> some View {
        content
            .task {
                //guard !isCompleted else { return }
                
                let condition = isInitialPromptShown ?
                ( await askLaterCondition()) : (await initialCondition())
        
                
                if condition {
                    showAlert = true
                }
                
            }
            .alert("Would you like to rate the app?", isPresented: $showAlert){
                Button(isInitialPromptShown ? "Yes!" : "Yes, Continue!"){
                    requestReview()
                    isCompleted = true
                }
                .keyboardShortcut(.defaultAction)
                
                if isInitialPromptShown {
                    Button("Nope", role: .cancel) {
                        isCompleted = true
                    }
                } else {
                    Button("Ask Later", role: .cancel) {
                       isInitialPromptShown = true
                    }
                    
                    Button("Never Ask Me Again", role: .destructive) {
                        isCompleted = true
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}
