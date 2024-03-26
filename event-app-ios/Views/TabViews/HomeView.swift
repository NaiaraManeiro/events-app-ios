//
//  HomeView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import SwiftUI

struct HomeView: View {
    @State private var events: [Event] = []
    @State private var isLoading = false
    
    @AppStorage("language")
    private var language = LocalizationService.shared.language
    
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var currentPage = 0
    @State private var selectedSortOption = SortOption.random
    
    @Binding var emailUsuario: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                } else if events.isEmpty {
                    Text("noEvents".localized(language))
                } else {
                    HStack {
                        Button(action: {
                            if currentPage > 0 {
                                currentPage -= 1
                                fetchEvents()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(currentPage > 0 ? .blue : .gray)
                        }
                        Text("\("page".localized(language)) \(currentPage + 1)")
                        Button(action: {
                            currentPage += 1
                            fetchEvents()
                        }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Picker("Sort By", selection: $selectedSortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue)
                                    .tag(option)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        .padding(.horizontal)
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 1)) {
                            ForEach(events) { event in
                                NavigationLink {
                                    EventDetailsView(id: event.id)
                                } label : {
                                    EventView(event: event)
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "searchBar".localized(language))
            .padding()
            .onChange(of: searchText) { newValue in
                searchText = newValue
                fetchEvents()
            }
            .onChange(of: selectedSortOption) { _ in
                fetchEvents()
            }
            .onAppear {
                fetchEvents()
            }
        }
    }
    
    private func fetchEvents() {
        isLoading = true
        
        var parameters: [[String: String]] = []
        
        if searchText != "" {
            parameters.append(["keyword": searchText])
        }
            
        parameters.append(["page": String(currentPage)])
        
        switch selectedSortOption {
            case .dateAsc:
                parameters.append(["sort": "date,asc"])
            case .dateDesc:
                parameters.append(["sort": "date,desc"])
            case .nameAsc:
                parameters.append(["sort": "name,asc"])
            case .nameDesc:
                parameters.append(["sort": "name,desc"])
            case .random:
                parameters.append(["sort": "random"])
        }
        
        EventAPI.fetchEvents(withParameters: parameters) { fetchedEvents in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchedEvents = fetchedEvents {
                    events = fetchedEvents._embedded.events
                }
            }
        }
    }
}
