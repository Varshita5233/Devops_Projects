package org.quickcart.orders.exception;

import feign.codec.ErrorDecoder;

public class FeignErrorDecoder implements ErrorDecoder {

    @Override
    public Exception decode(String methodKey, feign.Response response) {
        switch (response.status()) {
            case 404:
                return new ProductNotFoundException("No product found with the given ID");
            case 400:
                return new InsufficientStocksException("Insufficient stock available");
            default:
                return feign.FeignException.errorStatus(methodKey, response);
        }
    }
}
