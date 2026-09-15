package org.quickcart.orders.exception;

public class InsufficientStocksException extends BusinessException {

    public InsufficientStocksException(String message) {
        super(message);
    }
}
