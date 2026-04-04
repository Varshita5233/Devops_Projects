package org.quickcart.orders.exception;

public class AlreadyCanceledOrderException extends BusinessException {

    public AlreadyCanceledOrderException(String message) {
        super(message);
    }
}
