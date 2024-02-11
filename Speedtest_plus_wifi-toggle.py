import Foundation
import XCTest

final class test_appUITests44LaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testToggleWiFi() throws {
        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.launch()

        // Wait for the Settings app to load and navigate to the Wi-Fi section
        let wifiCell = settingsApp.cells["Wi-Fi"]
        if wifiCell.waitForExistence(timeout: 10) {
            wifiCell.tap()
            
            
            // Wait for the Wi-Fi switch to appear and then toggle it- always start with wifi on
            let wifiSwitch = settingsApp.switches.element(boundBy: 0) // Select the first switch element
            if wifiSwitch.waitForExistence(timeout: 5) {
                wifiSwitch.tap() // Toggles the Wi-Fi switch
            } else {
                XCTFail("Wi-Fi switch not found. cant turn off wifi")
                // Taking a screenshot of the Wi-Fi settings after toggling Wi-Fi
                let attachment = XCTAttachment(screenshot: settingsApp.screenshot())
                attachment.name = "Wi-Fi Settings Screen"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
            
            sleep(1)
            
            // turn wifi back on
            let wifiSwitch2 = settingsApp.switches.element(boundBy: 0) // Select the first switch element
            if wifiSwitch2.waitForExistence(timeout: 5) {
                wifiSwitch2.tap() // Toggles the Wi-Fi switch
            } else {
                XCTFail("Wi-Fi switch not found. cant turn wifi back on ")
                // Taking a screenshot of the Wi-Fi settings after toggling Wi-Fi
                let attachment = XCTAttachment(screenshot: settingsApp.screenshot())
                attachment.name = "Wi-Fi Settings Screen"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
            
            sleep(15)
            
            // Replace "your.bundle.identifier" with the actual bundle identifier of the speed test app.
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

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "speedtest"
            attachment.lifetime = .keepAlways
            add(attachment)
            
        } else {
            
            //this stage is if we are already in the wifi menu
            
            // Wait for the Wi-Fi switch to appear and then toggle it- always start with wifi on
            let wifiSwitch = settingsApp.switches.element(boundBy: 0) // Select the first switch element
            if wifiSwitch.waitForExistence(timeout: 5) {
                wifiSwitch.tap() // Toggles the Wi-Fi switch
            } else {
                XCTFail("Wi-Fi switch not found. cant turn off wifi")
                // Taking a screenshot of the Wi-Fi settings after toggling Wi-Fi
                let attachment = XCTAttachment(screenshot: settingsApp.screenshot())
                attachment.name = "Wi-Fi Settings Screen"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
            
            sleep(1)
            
            // turn wifi back on
            let wifiSwitch2 = settingsApp.switches.element(boundBy: 0) // Select the first switch element
            if wifiSwitch2.waitForExistence(timeout: 5) {
                wifiSwitch2.tap() // Toggles the Wi-Fi switch
            } else {
                XCTFail("Wi-Fi switch not found. cant turn wifi back on ")
                // Taking a screenshot of the Wi-Fi settings after toggling Wi-Fi
                let attachment = XCTAttachment(screenshot: settingsApp.screenshot())
                attachment.name = "Wi-Fi Settings Screen"
                attachment.lifetime = .keepAlways
                add(attachment)
            }
            
            sleep(15)
            
            // Replace "your.bundle.identifier" with the actual bundle identifier of the speed test app.
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

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "speedtest"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
