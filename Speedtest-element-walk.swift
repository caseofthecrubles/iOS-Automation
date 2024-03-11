//Walk the entire speedtest APP to identify the ID of each element and print each element in the console
import XCTest

class SpeedTestWalk: XCTestCase {
    // This function searches for the download label to identify the speedtest speed
    func walkapp(of app: XCUIApplication) -> String? { // Return type is String?
        // Iterate through all elements
        for element in app.descendants(matching: .any).allElementsBoundByIndex {
            // Check if the element is hittable to narrow down the list to visible elements
            if element.isHittable {
                // Find the download element:
                let elementLabel = element.label
                if elementLabel.contains("results.") {
                    //print("Element walk has found 'Download_Speed' and 'Upload Speed")
                    print("FOUND YOUR SPEEDS HERE IS THE Identifier$$: \(element.identifier)")
                    return elementLabel // Return the found label
                } else {
                    print("We didn't find it this time##")
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
        
        let speedtestresult = walkapp(of: app)
        print("speedtestresult: \(String(describing: speedtestresult))")
    }
}
