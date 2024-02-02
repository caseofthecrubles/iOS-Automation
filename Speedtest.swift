//
//  speedtest2.swift
//  wifi-test-lolUITests
//
//  Created by NA on 2/1/24.
//
import Foundation
import XCTest

final class wifi_test_lolUITestsLaunchTestscom2ooklaspeedtest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    func testLaunch() throws {
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
        
        sleep(50)

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        //sleep(500)
        
    }
}
