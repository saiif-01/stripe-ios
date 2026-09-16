//
//  PaymentSheetMonduUITests.swift
//  PaymentSheetUITest
//
//  Copyright © 2026 Stripe, Inc. All rights reserved.
//

import XCTest

class PaymentSheetMonduUITests: PaymentSheetStandardLPMUICase {
    func testPaymentIntent() {
        // Given a Mondu payment
        var settings = PaymentSheetTestPlaygroundSettings.defaultValues()
        settings.layout = .horizontal
        settings.customerMode = .guest
        settings.apmsEnabled = .off
        settings.applePayEnabled = .off
        settings.currency = .eur
        settings.merchantCountryCode = .DE
        settings.supportedPaymentMethods = "mondu"
        settings.mode = .payment
        loadPlayground(app, settings)

        // When the customer confirms and authorizes in the hosted test flow
        app.buttons["Present PaymentSheet"].waitForExistenceAndTap()
        XCTAssertTrue(app.staticTexts["Invoice payment for business buyers.\n\nAfter submission, you will be redirected to Mondu to complete the next steps."].waitForExistence(timeout: 5))
        let confirmButton = app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Pay ")).firstMatch
        confirmButton.waitForExistenceAndTap()
        webviewAuthorizePaymentButton.waitForExistenceAndTap(timeout: 30)

        // Then the redirect returns to the app and the intent completes
        XCTAssertTrue(app.staticTexts["Success!"].waitForExistence(timeout: 30))
    }
}
