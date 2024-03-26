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
    
    @State private var imageData: Data?
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 20){
                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                if let details = eventDetails {
                    Text(details.name ?? "")
                        .font(.title2)
                        .padding(.top, 5)
                    
                    HStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.blue)
                                VStack (alignment: .leading) {
                                    Text(details.dates.start.localDate)
                                        .font(.footnote)
                                    Text(formatTime(details.dates.start.localTime))
                                        .font(.caption)
                                }
                            }
                            if let embedded = details._embedded, let venues = embedded.venues, let firstVenue = venues.first {
                                HStack {
                                    Image(systemName: "map.fill")
                                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.yellow)
                                    VStack {
                                        VStack (alignment: .leading) {
                                            Text(firstVenue.name)
                                                .font(.footnote)
                                            if let address = firstVenue.address {
                                                Text(address.line1)
                                                    .font(.caption)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            if let prices = details.priceRanges, let firstPrices = prices.first {
                                HStack {
                                    Image(systemName: "dollarsign")
                                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.green)
                                    VStack (alignment: .leading) {
                                        Text("\("from".localized(language)) \(String(firstPrices.min)) \(firstPrices.currency)")
                                            .font(.footnote)
                                        Text("\("to".localized(language)) \(String(firstPrices.max)) \(firstPrices.currency)")
                                            .font(.footnote)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    if let classif = details.classifications, let firstClassif = classif.first {
                        HStack(spacing: 5) {
                            Text(firstClassif.segment.name)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.orange.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Text(firstClassif.genre.name)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.red.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Text(firstClassif.subGenre.name)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.brown.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    if let sales = details.sales, let salesP = sales.public {
                        VStack(spacing: 8) {
                            Spacer()
                            
                            HStack {
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 50, height: 2)
                                Text("saledPeriod".localized(language))
                                    .font(.headline)
                                Rectangle()
                                    .fill(Color.black)
                                    .frame(width: 50, height: 2)
                            }
                            
                            Spacer()
                            
                            let (startDateStr, startTimeStr) = formattedDate(salesP.startDateTime)
                            let (endDateStr, endTimeStr) = formattedDate(salesP.endDateTime)
                            
                            HStack {
                                VStack {
                                    Text("from".localized(language))
                                    Text("\("date".localized(language)) \(startDateStr)")
                                        .font(.subheadline)
                                    Text("\("time".localized(language)) \(startTimeStr)")
                                        .font(.subheadline)
                                }
                                Spacer()
                                VStack {
                                    Text("to".localized(language))
                                    Text("\("date".localized(language)) \(endDateStr)")
                                        .font(.subheadline)
                                    Text("\("time".localized(language)) \(endTimeStr)")
                                        .font(.subheadline)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        UIApplication.shared.open(URL(string: details.url)!)
                    }) {
                        Text("buyButton".localized(language))
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack{
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .bold()
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
    }
    
    private func fetchEventDetails() {
        isLoading = true
        EventAPI.fetchEventDetails(id: id) { fetchedEventDetails in
            DispatchQueue.main.async {
                isLoading = false
                if let fetchedEventDetails = fetchedEventDetails {
                    eventDetails = fetchedEventDetails
                    loadImage()
                }
            }
        }
    }
    
    private func loadImage() {
        guard let details = eventDetails, let firstImage = details.images?.first, let imageURL = URL(string: firstImage.url) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    self.imageData = data
                }
            }
        }.resume()
    }
    
    func formatTime(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return timeString
    }
    
    private func formattedDate(_ dateString: String) -> (String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd"
            let dateStr = formatter.string(from: date)
                
            formatter.dateFormat = "HH:mm"
            let timeStr = formatter.string(from: date)
                
            return (dateStr, timeStr)
        }
            
        return ("", "")
    }
}
