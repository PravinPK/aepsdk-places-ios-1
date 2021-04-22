/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import XCTest
@testable import AEPPlaces

class PlacesConfigurationTests: XCTestCase {
    
    static var mockLibraries: [[String: Any]] = []
    static var mockEndpoint = "placesEdgeEndpoint"
    static var mockTtl: Int64 = 552
    
    // json is not used, but shows an example of what the data will look like in the configuration eventData
    let json = """
    "places.libraries": [
        {
            "id": "1234",
            "name": "firstLib"
        },
        {
            "id": "2345",
            "name": "secondLib"
        }
    ],
    "places.endpoint": "placesEdgeEndpoint",
    "places.membershipttl": 552
    """
    
    override func setUpWithError() throws {
        PlacesConfigurationTests.mockLibraries.append(["id": "1234", "name": "firstLib"])
        PlacesConfigurationTests.mockLibraries.append(["id": "2345", "name": "secondLib"])
    }
    
    override func tearDownWithError() throws {
        PlacesConfigurationTests.mockLibraries.removeAll()
    }
    
    func getEventData(libraries: [[String: Any]]? = mockLibraries,
                      endpoint: String? = mockEndpoint,
                      membershipTtl: Int64? = mockTtl) -> [String: Any] {
        var data: [String: Any] = [:]
        if libraries != nil {
            data[PlacesConstants.EventDataKey.Configuration.PLACES_LIBRARIES] = libraries
        }
        if endpoint != nil {
            data[PlacesConstants.EventDataKey.Configuration.PLACES_ENDPOINT] = endpoint
        }
        if membershipTtl != nil {
            data[PlacesConstants.EventDataKey.Configuration.PLACES_MEMBERSHIP_TTL] = membershipTtl
        }
        return data
    }
    
    // MARK: - tests
    
    func testEventDataConstructorHappy() throws {
        // setup
        let placesConfig = PlacesConfiguration.withEventData(getEventData())
        
        // verify
        XCTAssertNotNil(placesConfig)
        XCTAssertEqual(PlacesConfigurationTests.mockEndpoint, placesConfig?.endpoint)
        XCTAssertEqual(PlacesConfigurationTests.mockTtl, placesConfig?.membershipTtl)
        XCTAssertEqual(2, placesConfig?.libraries.count)
        let lib1 = placesConfig?.libraries[0]
        XCTAssertEqual("1234", lib1?.id)
        XCTAssertEqual("firstLib", lib1?.name)
        let lib2 = placesConfig?.libraries[1]
        XCTAssertEqual("2345", lib2?.id)
        XCTAssertEqual("secondLib", lib2?.name)
    }
    
    func testEventDataConstructorBadLibraryInMap() throws {
        // setup
        let placesConfig = PlacesConfiguration.withEventData(getEventData(libraries:[["noId":"in the map"]]))
        
        // verify
        XCTAssertNotNil(placesConfig)
        XCTAssertEqual(0, placesConfig?.libraries.count)
    }
    
    func testEventDataConstructorLibrariesDoesNotExist() throws {
        // setup
        let placesConfig = PlacesConfiguration.withEventData(getEventData(libraries:nil))
        
        // verify
        XCTAssertNil(placesConfig)
    }
    
    func testEventDataConstructorNoEndpointOrTtl() throws {
        // setup
        let placesConfig = PlacesConfiguration.withEventData(getEventData(endpoint: nil, membershipTtl: nil))
        
        // verify
        XCTAssertNotNil(placesConfig)
        XCTAssertEqual("", placesConfig?.endpoint)
        XCTAssertEqual(PlacesConstants.DefaultValues.MEMBERSHIP_TTL, placesConfig?.membershipTtl)
    }
}
