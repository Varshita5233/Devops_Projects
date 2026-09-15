package org.quickcart.apigateway.controller;

import org.quickcart.apigateway.dto.ApiError;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;

@RestController
public class GatewayFallbackController {

        @RequestMapping("/fallback/product-service")
        public ResponseEntity<ApiError> productServiceFallback() {
            return ResponseEntity
                    .status(HttpStatus.SERVICE_UNAVAILABLE)
                    .body(new ApiError(Instant.now(), 503, "Product Service is currently unavailable. Please try again later.", "product-service"));
        }

    @RequestMapping("/fallback/order-service")
    public ResponseEntity<ApiError> orderServiceFallback() {
        return ResponseEntity
                .status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(new ApiError(Instant.now(), 503, "Order Service is currently unavailable. Please try again later.", "order-service"));
    }

}
