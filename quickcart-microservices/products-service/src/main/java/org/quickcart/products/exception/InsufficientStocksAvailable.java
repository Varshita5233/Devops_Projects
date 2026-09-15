package org.quickcart.products.exception;

public class InsufficientStocksAvailable extends RuntimeException {

    public InsufficientStocksAvailable(String message) {
        super(message);
    }
}
