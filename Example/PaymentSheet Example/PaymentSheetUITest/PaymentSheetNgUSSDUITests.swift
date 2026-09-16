//
//  PaymentSheetNgUSSDUITests.swift
//  PaymentSheetUITest
//
//  Copyright © 2026 Stripe, Inc. All rights reserved.
//

import XCTest

class PaymentSheetNgUSSDUITests: PaymentSheetStandardLPMUICase {
    func testPaymentIntent() {
        // Given a Naira USSD payment
        var settings = PaymentSheetTestPlaygroundSettings.defaultValues()
        settings.layout = .horizontal
        settings.customerMode = .new
        settings.customerKeyType = .legacy
        settings.apmsEnabled = .off
        settings.applePayEnabled = .off
        settings.currency = .ngn
        settings.merchantCountryCode = .US
        settings.supportedPaymentMethods = "ng_ussd"
        settings.mode = .payment
        loadPlayground(app, settings)

        // When the customer confirms and authorizes in the hosted test flow
        app.buttons["Present PaymentSheet"].waitForExistenceAndTap()
        let confirmButton = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Pay ")).firstMatch
        confirmButton.waitForExistenceAndTap()
        webviewAuthorizePaymentButton.waitForExistenceAndTap(timeout: 30)

        // Then the redirect returns to the app and the intent completes
        XCTAssertTrue(app.staticTexts["Success!"].waitForExistence(timeout: 30))
    }
}
