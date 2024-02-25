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
            
            let targetElement = app.descendants(matching: .any).element(boundBy: 25)

            // Check if the element exists and is hittable
            if targetElement.waitForExistence(timeout: 5) && targetElement.isHittable {
                let elementLabel = targetElement.label
                print("Element Label: \(elementLabel)")
                writeToLogFile("Element Label: \(elementLabel)")

                // Extract and process the speed data from elementLabel
                // You will need to parse the string to extract the relevant information
            } else {
                XCTFail("Target element not found or not hittable.")
                writeToLogFile("Target element not found or not hittable. (Speedtest failed)")
            }

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

            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.41s Find the "Test results. Download Speed, 157megabits per second. Upload speed, 286megabits per second. Connection results. Idle ping result35milliseconds, 28milliseconds Jitter, Download ping result 121milliseconds 42 milliseconds Jitter, Upload ping result 84milliseconds 32 milliseconds Jitter" Other
            // Assuming 'downloadSpeedIdentifier' and 'uploadSpeedIdentifier' are the accessibility identifiers for the result elements
            // Access the 26th element in the hierarchy
            let targetElement = app.descendants(matching: .any).element(boundBy: 25)

            // Check if the element exists and is hittable
            if targetElement.waitForExistence(timeout: 5) && targetElement.isHittable {
                let elementLabel = targetElement.label
                print("Element Label: \(elementLabel)")
                writeToLogFile("Element Label: \(elementLabel)")

                // Extract and process the speed data from elementLabel
                // You will need to parse the string to extract the relevant information
            } else {
                XCTFail("Target element not found or not hittable.")
                writeToLogFile("Target element not found or not hittable. (Speedtest failed)")
            }

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "speedtest"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
