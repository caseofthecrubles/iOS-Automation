//feb 25 2024
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
            
            sleep(60)

            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.41s Find the "Test results. Download Speed, 157megabits per second. Upload speed, 286megabits per second. Connection results. Idle ping result35milliseconds, 28milliseconds Jitter, Download ping result 121milliseconds 42 milliseconds Jitter, Upload ping result 84milliseconds 32 milliseconds Jitter" Other
            // Assuming 'downloadSpeedIdentifier' and 'uploadSpeedIdentifier' are the accessibility identifiers for the result elements
            // Access the 26th element in the hierarchy
            let targetElement = app.descendants(matching: .any).element(boundBy: 25)

            // Check if the element exists and is hittable
            if targetElement.waitForExistence(timeout: 5) && targetElement.isHittable {
                let elementLabel = targetElement.label
                
                // Check for the presence of "Download Speed" and "Upload Speed" in the element's label
                //Swift contains is also looking at attached charters so a , or anything else will force a non match 
                if elementLabel.contains("Download") {
                    writeToLogFile("Element Label contains 'Download Speed' and 'Upload Speed': \(elementLabel)")
                    
                    print("Element_Label_25_MUST_CONTAIN_'Download_Speed'_and_'Upload Speed': \(elementLabel)")

                    // Further parsing can be done here to extract actual speed values
                } else {
                    writeToLogFile("Element Label does not contain 'Download Speed' and 'Upload Speed': \(elementLabel)")
                    XCTFail("Element does not contain 'Download Speed' and 'Upload Speed'")
                    print("Element_Label_25_MUST_CONTAIN_'Download_Speed'_and_'Upload Speed': \(elementLabel)")
                }
            } else {
                XCTFail("Target element not found or not hittable./Element Label does not contain 'Download Speed' and 'Upload Speed'")
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
            
            sleep(60)

            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.38s Find the Any (Element at index 25)
            //t =    38.41s Find the "Test results. Download Speed, 157megabits per second. Upload speed, 286megabits per second. Connection results. Idle ping result35milliseconds, 28milliseconds Jitter, Download ping result 121milliseconds 42 milliseconds Jitter, Upload ping result 84milliseconds 32 milliseconds Jitter" Other
            // Assuming 'downloadSpeedIdentifier' and 'uploadSpeedIdentifier' are the accessibility identifiers for the result elements
            // Access the 26th element in the hierarchy
            let targetElement = app.descendants(matching: .any).element(boundBy: 25)

            // Check if the element exists and is hittable
            if targetElement.waitForExistence(timeout: 5) && targetElement.isHittable {
                let elementLabel = targetElement.label
                
                // Check for the presence of "Download Speed" and "Upload Speed" in the element's label
                if elementLabel.contains("Download") {
                    writeToLogFile("Element Label contains 'Download Speed' and 'Upload Speed': \(elementLabel)")
                    
                    print("Element_Label_25_MUST_CONTAIN_'Download_Speed'_and_'Upload Speed': \(elementLabel)")

                    // Further parsing can be done here to extract actual speed values
                } else {
                    writeToLogFile("Element Label does not contain 'Download Speed' and 'Upload Speed': \(elementLabel)")
                    print("Element_Label_25_MUST_CONTAIN_'Download': \(elementLabel)")
                    XCTFail("Element does not contain 'Download Speed' and 'Upload Speed'")
                }
            } else {
                XCTFail("Target element not found or not hittable./Element Label does not contain 'Download Speed' and 'Upload Speed'")
                writeToLogFile("Target element not found or not hittable. (Speedtest failed)")
            }

            let attachment = XCTAttachment(screenshot: app.screenshot())
            attachment.name = "speedtest"
            attachment.lifetime = .keepAlways
            add(attachment)
        }
    }
}
