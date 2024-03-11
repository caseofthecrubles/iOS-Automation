//March 11th
import XCTest

class SpeedTestWalk_curl: XCTestCase {
    // This function searches for the download label to identify the speedtest speed
    func walkapp_curl(of app: XCUIApplication) -> String? { // Return type is String?
        // Iterate through all elements
        for element in app.descendants(matching: .any).allElementsBoundByIndex {
            // Check if the element is hittable to narrow down the list to visible elements
            if element.isHittable {
                // Find the download element:
                let elementLabel = element.label
                if elementLabel.contains("results.") {
                    //print("Element walk has found 'Download_Speed' and 'Upload Speed")
                    //print("FOUND YOUR SPEEDS HERE IS THE Identifier$$: \(element.identifier)")
                    //curl 10.8.0.234:8080 -H "testdfasdfasdfasdfasdfasdf: Somevalue"

                    let urlString = "http://iot-dev.seantech.info:8080"
                    let url = URL(string: urlString)!

                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    // Here you should add the actual header field name and the value
                    // For example, if you have a header field named "X-Download-Speed"
                    // and you want to pass the `downloadSpeed` as its value, do the following:
                    request.addValue(elementLabel, forHTTPHeaderField: "X-Download-Speed")
                    print(elementLabel)
                    
                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }
                        
                        guard let httpResponse = response as? HTTPURLResponse,
                              (200...299).contains(httpResponse.statusCode) else {
                            print("Error with the response, unexpected status code: \(String(describing: response))")
                            return
                        }
                        
                        if let mimeType = httpResponse.mimeType, mimeType == "application/json",
                           let data = data,
                           let dataString = String(data: data, encoding: .utf8) {
                            print("Got data: \(dataString)")
                        }
                    }

                    task.resume()

                    return elementLabel // Return the found label
                } else {
                    //print("We didn't find it this time##")
                    //print("Identifier: \(element.identifier)")
                }
            }
        }
        return nil // Return nil if no matching element is found
    }

    func testPrintIdentifiers() {
        let app = XCUIApplication(bundleIdentifier: "com.ookla.speedtest")
        app.launch()
        
        let goButton = app.buttons["GO"]

        //look for a hittable button, you will have the most success :)
        let exists = NSPredicate(format: "hittable == true")
        expectation(for: exists, evaluatedWith: goButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        goButton.tap()
        
        sleep(30)
        
        let speedtestresult = walkapp_curl(of: app)
        print("speedtestresult: \(String(describing: speedtestresult))")
    }
}
