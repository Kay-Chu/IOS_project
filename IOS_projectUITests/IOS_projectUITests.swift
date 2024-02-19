//
//  IOS_projectUITests.swift
//  IOS_projectUITests
//
//  Created by KA YING CHU on 12/1/2024.
//

import XCTest
import SwiftUI

final class IOS_projectUITests: XCTestCase {
    
    var app = XCUIApplication()
    
    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
    }
    
    func testLoginUIFields() {

        
        app.launch()
            
        let emailTextField = app.textFields["Enter your email"]
//        XCTAssertTrue(emailTextField.waitForExistence(timeout: 10), "Email text field not found.")
        if emailTextField.exists {
            
            emailTextField.tap()
            emailTextField.typeText("User@user.com")
            
            let passwordSecureField = app.secureTextFields["Enter your password"]
            //        XCTAssertTrue(passwordSecureField.waitForExistence(timeout: 10), "Password secure field not found.")
            
            passwordSecureField.tap()
            passwordSecureField.typeText("123456")
            
            let signInButton = app.buttons["SIGN IN"]
            signInButton.tap()
        } else {
            testHomePageUIFields()
        }
        testHomePageUIFields()
    }
    

    func testHomePageUIFields(){
        
//        app.launch()
        
        let collectionViewsQuery = app.collectionViews
//        if !collectionViewsQuery.element.exists{
//            testLoginUIFields()
//        }
        
        app.collectionViews/*@START_MENU_TOKEN@*/.cells.staticTexts["School Notice 1⃣️"]/*[[".cells",".buttons[\"School Notice 1⃣️\"].staticTexts[\"School Notice 1⃣️\"]",".staticTexts[\"School Notice 1⃣️\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[2,0]]@END_MENU_TOKEN@*/.tap()
        
        let closeButton = app.buttons["Close"]
        closeButton.tap()
        
        let notification1Image = collectionViewsQuery/*@START_MENU_TOKEN@*/.images["Notification1"]/*[[".cells",".buttons[\"School Notice 1⃣️\"].images[\"Notification1\"]",".images[\"Notification1\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        notification1Image.swipeLeft()
         
        collectionViewsQuery.staticTexts["School Notice 2⃣️"].tap()
   
        if closeButton.isHittable { //Waiting for the view load
            closeButton.tap()
        }
        
        testChatbotUIFields()
        
    }
    
    func testChatbotUIFields() {
        
//        app.launch()
        
        let assistantButton = app.tabBars["Tab Bar"].buttons["Assistant"]
        
//        if !assistantButton.exists{
//            testLoginUIFields()
//        }
        
        assistantButton.tap()
        
        let textField = app.textViews["Message..."]
        textField.tap()
        textField.typeText("Hi, tell us about yourself!")
        
        let sendButton = app.buttons["Send"]
        sendButton.tap()
        sendButton.waitForExistence(timeout: 15)
        textField.tap()
        textField.typeText("Thank you!")
        sendButton.tap()
        sendButton.waitForExistence(timeout: 10)
        app.buttons["Clear"].tap()
        
        testMapUIFields()
        
    }
    
    func testMapUIFields() {
        
//        app.launch()
        
        let schoolInfoButton = app.tabBars["Tab Bar"].buttons["School Info"]
        
//        if !schoolInfoButton.exists{
//            testLoginUIFields()
//        }
//        
        schoolInfoButton.tap()
        
        let showMapButton = app.buttons["Show Map"]
        showMapButton.tap()
        app.buttons["send"].tap()
        app.buttons["send"].waitForExistence(timeout: 5)
        showMapButton.tap()
        
        testProfileUIFields()
        
    }
    
    
    func testProfileUIFields(){
        
//        app.launch()
        
        let profileButton = app.tabBars["Tab Bar"].buttons["Profile"]
        
//        if !profileButton.exists{
//            testLoginUIFields()
//        }
        
        profileButton.tap()

        
//        let shareWithFriendsStaticText = app2.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Share with friends"]/*[[".cells",".buttons[\"Share with friends\"].staticTexts[\"Share with friends\"]",".staticTexts[\"Share with friends\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
//        shareWithFriendsStaticText.tap()
//        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
//        shareWithFriendsStaticText.tap()
//        app/*@START_MENU_TOKEN@*/.collectionViews.containing(.cell, identifier:"Copy").element/*[[".collectionViews.containing(.cell, identifier:\"Add to Reading List\").element",".collectionViews.containing(.cell, identifier:\"Copy\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let logoutButton = app.buttons["Sign Out"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 10), "Logout button not found.")
        logoutButton.tap()
        
        
    }


//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//

//
//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
