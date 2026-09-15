package org.quickcart.orders.exception;

public class OrderNotFoundException extends BusinessException {

    public OrderNotFoundException(String message) {
        super(message);
    }
}
