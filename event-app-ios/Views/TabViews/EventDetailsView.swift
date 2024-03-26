//
//  EventDetailsView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 26/3/24.
//

import SwiftUI

struct EventDetailsView: View {
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    let id: String
    
    @State private var eventDetails: EventDetailsResponse?
    @State private var isLoading = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20){

        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                    }
                    Text("detailsTitle".localized(language))
                        .font(.title)
                        .bold()
                }
            }
        }
        .onAppear {
            fetchEventDetails()
        }
    }
    
    private func fetchEventDetails() {
        isLoading = true
        EventAPI.fetchEventDetails(id: id) { fetchedEventDetails in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchedEventDetails = fetchedEventDetails {
                    eventDetails = fetchedEventDetails
                }
            }
        }
    }
}
