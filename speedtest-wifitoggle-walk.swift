//March 10 2024
import Foundation
import XCTest

final class test_appUITests44LaunchTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func writeToLogFile(_ content: String) {
        let fileManager = FileManager.default

        // Get the URL for the Documents directory in the app's sandbox
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to find the documents directory")
            return
        }
        let logFileURL = documentsDirectory.appendingPathComponent("Speedtest-UITestLog.txt")

        // Create the file if it doesn't exist
        if !fileManager.fileExists(atPath: logFileURL.path) {
            fileManager.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }

        // Write content to the file
        do {
            let fileHandle = try FileHandle(forWritingTo: logFileURL)
            fileHandle.seekToEndOfFile()
            if let data = (content + "\n").data(using: .utf8) {
                fileHandle.write(data)
                print("File written successfully to \(logFileURL.path)")
            }
            fileHandle.closeFile()
        } catch {
            print("Unable to write to file: \(error)")
        }
    }

    
    func walkapp(of app: XCUIApplication) -> String? { // Return type is String?
        // Iterate through all elements
        for element in app.descendants(matching: .any).allElementsBoundByIndex {
            // Check if the element is hittable to narrow down the list to visible elements
            // Find the download element:
            let elementLabel = element.label
            if elementLabel.contains("results.") {
                //print("Element walk has found 'Download_Speed' and 'Upload Speed")
                print("FOUND YOUR SPEEDS HERE IS THE Identifier$$: \(element.identifier)")
                return elementLabel // Return the found label
            } else {
                //print("We didn't find it this time##")
                //print("Identifier: \(element.identifier)")
            }
            
        }
        XCTFail("The speedtest did not run fully or at all we did not find download")
        return nil // Return nil if no matching element is found
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
            //wifi now off
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
            
            //run speedtest
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
            
            sleep(45)
            
            let speedtestresult = walkapp(of: app)
            print("speedtestresult: \(String(describing: speedtestresult))")

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
            //wifi is off
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
            
            //open speedtest and run a speedtest
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
            
            sleep(40)

            let speedtestresult = walkapp(of: app)
            print("speedtestresult: \(String(describing: speedtestresult))")

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "speedtest"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
