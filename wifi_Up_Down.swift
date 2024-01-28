import XCTest

final class test_appUITests44LaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

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
            
            // Wait for the Wi-Fi switch to appear and then toggle it
            let wifiSwitch = settingsApp.switches.element(boundBy: 0) // Select the first switch element
            if wifiSwitch.waitForExistence(timeout: 5) {
                wifiSwitch.tap() // Toggles the Wi-Fi switch
            } else {
                XCTFail("Wi-Fi switch not found.")
            }
        } else {
            XCTFail("Wi-Fi cell not found.")
        }
        
        // Taking a screenshot of the Wi-Fi settings after toggling Wi-Fi
        let attachment = XCTAttachment(screenshot: settingsApp.screenshot())
        attachment.name = "Wi-Fi Settings Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

