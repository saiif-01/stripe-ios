//
//  PaymentSheetGCashUITests.swift
//  PaymentSheetUITest
//
//  Copyright © 2026 Stripe, Inc. All rights reserved.
//

import XCTest

class PaymentSheetGCashUITests: PaymentSheetStandardLPMUICase {
    func testPaymentIntent() {
        confirm(mode: .payment)
    }

    func testPaymentIntentWithSetupFutureUsage() {
        confirm(mode: .paymentWithSetup)
    }

    func testSetupIntent() {
        confirm(mode: .setup)
    }

    private func confirm(mode: PaymentSheetTestPlaygroundSettings.Mode) {
        // Given a GCash checkout with the supported intent mode
        var settings = PaymentSheetTestPlaygroundSettings.defaultValues()
        settings.layout = .horizontal
        settings.customerMode = .new
        settings.apmsEnabled = .off
        settings.applePayEnabled = .off
        settings.currency = .php
        settings.merchantCountryCode = .US
        settings.supportedPaymentMethods = "gcash"
        settings.mode = mode
        loadPlayground(app, settings)

        // When the customer confirms and authorizes in the hosted test flow
        app.buttons["Present PaymentSheet"].waitForExistenceAndTap()
        let confirmButton = mode == .setup
            ? app.buttons["Set up"]
            : app.buttons.matching(NSPredicate(format: "label BEGINSWITH %@", "Pay ")).firstMatch
        confirmButton.waitForExistenceAndTap()
        let authorizeButton = mode == .setup ? webviewAuthorizeSetupButton : webviewAuthorizePaymentButton
        authorizeButton.waitForExistenceAndTap(timeout: 30)

        // Then the redirect returns to the app and the intent completes
        XCTAssertTrue(app.staticTexts["Success!"].waitForExistence(timeout: 30))
    }
}
