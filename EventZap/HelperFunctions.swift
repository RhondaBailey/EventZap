//
//  HelperFunctions.swift
//  EventZap
//
//  Created by Rhonda Bailey on 10/31/23.
//

import SwiftUI
import CloudKit
import Foundation
import CoreLocation

class HelperFunctions {
    
    static func validateEventFieldData(name: String, isNameValid: Bool, facilityName: String, isFacilityNameValid: Bool, address: String, isAddressValid: Bool, city: String, isCityValid: Bool, state: String, isStateValid: Bool, description: String, isDescriptionValid: Bool, invalidFields: Bool) -> (isValid: Bool, isNameValid: Bool, isFacilityNameValid: Bool, isAddressValid: Bool, isCityValid: Bool, isStateValid: Bool, isDescriptionValid: Bool, invalidFields: Bool) {
        var newIsNameValid = isNameValid
        var newIsFacilityNameValid = isFacilityNameValid
        var newIsAddressValid = isAddressValid
        var newIsCityValid = isCityValid
        var newIsStateValid = isStateValid
        var newIsDescriptionValid = isDescriptionValid
        var newInvalidFields = invalidFields

        if name.isEmpty {
            newIsNameValid = false
            newInvalidFields = true
        }
        if facilityName.isEmpty {
            newIsFacilityNameValid = false
            newInvalidFields = true
        }
        if address.isEmpty {
            newIsAddressValid = false
            newInvalidFields = true
        }
        if city.isEmpty {
            newIsCityValid = false
            newInvalidFields = true
        }
        if state.isEmpty {
            newIsStateValid = false
            newInvalidFields = true
        }
        if description.isEmpty {
            newIsDescriptionValid = false
            newInvalidFields = true
        }

        return (isValid: newInvalidFields, isNameValid: newIsNameValid, isFacilityNameValid: newIsFacilityNameValid, isAddressValid: newIsAddressValid, isCityValid: newIsCityValid, isStateValid: newIsStateValid, isDescriptionValid: newIsDescriptionValid, invalidFields: newInvalidFields)
    }

    
    static func saveImageLocally(imageData: Data) -> CKAsset? {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let uniqueFilename = UUID().uuidString + ".png"
        let fileURL = documentDirectory.appendingPathComponent(uniqueFilename)
        
        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            print("Error saving image locally: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getCoordinatesFromAddress(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) async {
        print("Step Two ")
        print("address = ", address)
        let geocoder = CLGeocoder()

        //Task {
            do {
                let placemarks = try await geocoder.geocodeAddressString(address)
                if let placemark = placemarks.first {
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    completion(coordinate, nil)
                } else {
                    completion(nil, NSError(domain: "GeocodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No placemarks found."]))
                }
            } catch {
                completion(nil, error)
            }
        //}
    }

    
    /*static func getCoordinatesFromAddress(address: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) async {
        print("Step Two " )
        print("address = ", address)
        let geocoder = CLGeocoder()
        
        await geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                completion(nil, error)
            } else if let placemark = placemarks?.first {
                let location = placemark.location
                let coordinate = location?.coordinate
                completion(coordinate, nil)
            } else {
                completion(nil, NSError(domain: "GeocodingError", code: 1, userInfo: [NSLocalizedDescriptionKey: "No placemarks found."]))
            }
        }
    }*/
    
    
    
}
