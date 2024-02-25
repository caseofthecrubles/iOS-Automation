//Walk the entire speedtest APP to identify the ID of each element and print each element in the console
import XCTest

class SpeedTestWalk: XCTestCase {

    func printIdentifiers(of app: XCUIApplication) {
        // Iterate through all elements
        for element in app.descendants(matching: .any).allElementsBoundByIndex {
            // Check if the element is hittable to narrow down the list to visible elements
            if element.isHittable {
                print("Element Type: \(element.elementType)")
                print("Identifier: \(element.identifier)")
                print("Label: \(element.label)")
                print("Value: \(element.value ?? "nil")")
                print("----------------------------")
            }
        }
    }

    func testPrintIdentifiers() {
        let app = XCUIApplication(bundleIdentifier: "com.ookla.speedtest")
        app.launch()
        
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app
        
        let goButton = app.buttons["GO"]

        //look for a hittable button, you will have the most success :)
        let exists = NSPredicate(format: "hittable == true")
        expectation(for: exists, evaluatedWith: goButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        goButton.tap()
        
        sleep(30)

        printIdentifiers(of: app)
    }
}
