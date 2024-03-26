//
//  EventbriteManager.swift
//  event-app-ios
//
//  Created by Naiara Maneiro on 25/3/24.
//

import Foundation

class EventAPI {
    private static let apiKey = "oWtNc9iw5vFgWW4zNRbLkqdvPFLMxZJK"
    private static let baseURL = "https://app.ticketmaster.com"
    private static let eventsEndpoint = "/discovery/v2/events.json"
    private static let eventDetailsEndpoint = "/discovery/v2/events/"
    
    private static let session: URLSession = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
            return URLSession(configuration: configuration)
        }()
    
    
    static func fetchEvents(completion: @escaping (EventListResponse?) -> Void) {
        let urlString = "\(baseURL)\(eventsEndpoint)?apikey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
            
        let request = URLRequest(url: url)
            
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("No data received")
                completion(nil)
                return
            }
                
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EventListResponse.self, from: data)
                completion(result)
            } catch {
                print("Error fetch: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    static func fetchEventDetails(id: String, completion: @escaping (EventDetailsResponse?) -> Void) {
        let urlString = "\(baseURL)\(eventDetailsEndpoint)\(id)?apikey=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
            
        let request = URLRequest(url: url)
            
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("No data received")
                completion(nil)
                return
            }
                
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(EventDetailsResponse.self, from: data)
                completion(result)
            } catch {
                print("Error fetch: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
