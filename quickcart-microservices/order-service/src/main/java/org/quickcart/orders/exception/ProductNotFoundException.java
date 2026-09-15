package org.quickcart.orders.exception;

public class ProductNotFoundException extends BusinessException {

    public ProductNotFoundException(String message) {
        super(message);
    }
}
