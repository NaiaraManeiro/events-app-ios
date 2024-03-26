//
//  EventCardView.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import SwiftUI

struct EventView: View {
    let event: Event
    
    @State private var imageData: Data?
        
    var body: some View {
        VStack (alignment: .leading, spacing: 20){
            ZStack(alignment: .topLeading) {
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
                
                Text(event.dates.start.localDate)
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .padding(8)
            }
            
            if let name = event.name {
                Text(name.replacingOccurrences(of: "\r\n", with: ""))
                    .font(.headline)
                    .padding(.top, 5)
                    .lineLimit(1)
            }
            
            HStack {
                if let embedded = event._embedded, let venues = embedded.venues, let firstVenue = venues.first, let address = firstVenue.address {
                    Image(systemName: "map.fill")
                        .foregroundColor(.yellow)
                    Text(address.line1)
                } else if let place = event.place, let address = place.address {
                    Image(systemName: "map.fill")
                        .foregroundColor(.yellow)
                    Text(address.line1)
                }
            }
            
            if let priceRanges = event.priceRanges, let firstPriceRange = priceRanges.first, let min = firstPriceRange.min, let max = firstPriceRange.max {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Text(String(min) + " - ")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(String(max))
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(firstPriceRange.currency)
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .shadow(radius: 2)
                }
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let firstImage = event.images?.first, let imageURL = URL(string: firstImage.url) else {
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
}
