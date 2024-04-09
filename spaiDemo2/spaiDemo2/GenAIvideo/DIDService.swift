//
//  DIDService.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 3/31/24.
//


import Foundation

struct DIDService {
    static let baseURL = "https://api.d-id.com/clips"
    static let presenterID = "amy-Aq6OmGZnMt"
    static let driverID = "Vcq0R4a8F0"
    static let credentials = "api key here".data(using: .utf8)?.base64EncodedString() ?? ""
    
    static func createClip(withText text: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = [
            "script": [
                "type": "text",
                "input": text
            ],
            "presenter_id": presenterID,
            "driver_id": driverID
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error creating clip: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("Raw response: \(responseString ?? "N/A")")

            if let clipResponse = try? JSONDecoder().decode(ClipCreationResponse.self, from: data) {
                completion(clipResponse.id)
            } else {
                print("Failed to decode clip creation response")
                completion(nil)
            }
        }
        task.resume()

    }

    static func fetchClip(withId id: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch clip: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            if let clipResponse = try? JSONDecoder().decode(ClipFetchResponse.self, from: data) {
                if clipResponse.status == "done" {
                    completion(clipResponse.result_url)
                } else {
                    // The clip is not ready yet, wait for a few seconds before trying again
                    DispatchQueue.global().asyncAfter(deadline: .now() + 5) { // Wait for 5 seconds
                        fetchClip(withId: id, completion: completion)
                    }
                }
            } else {
                print("Failed to decode clip fetch response")
                completion(nil)
            }
        }

        task.resume()
    }

}

struct ClipCreationResponse: Codable {
    let id: String
    let created_at: String
    let object: String
    let status: String
}


struct ClipFetchResponse: Codable {
    let status: String
    let result_url: String?
}

