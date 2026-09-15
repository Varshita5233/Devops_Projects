package org.quickcart.orders.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<ApiError> handleProductNotFound(ProductNotFoundException ex,
                                                          HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(new ApiError(Instant.now(), 404, ex.getMessage(), req.getRequestURI()));
    }


    @ExceptionHandler(InsufficientStocksException.class)
    public ResponseEntity<ApiError> handleInsufficientStocksAvailable(InsufficientStocksException ex,
                                                          HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(new ApiError(Instant.now(), 400, ex.getMessage(), req.getRequestURI()));
    }

    @ExceptionHandler(OrderNotFoundException.class)
    public ResponseEntity<ApiError> handleOrderNotFound(OrderNotFoundException ex,
                                                        HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(new ApiError(Instant.now(), 404, ex.getMessage(), req.getRequestURI()));
    }

    @ExceptionHandler(AlreadyCanceledOrderException.class)
    public ResponseEntity<ApiError> handleAlreadyCanceledOrder(AlreadyCanceledOrderException ex,
                                                        HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(new ApiError(Instant.now(), 400, ex.getMessage(), req.getRequestURI()));
    }


    @ExceptionHandler(ProductServiceNotAvailableException.class)
    public ResponseEntity<ApiError> productServiceNotAvailable(ProductServiceNotAvailableException ex,
                                                               HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.SERVICE_UNAVAILABLE)
                .body(new ApiError(Instant.now(), 503, ex.getMessage(), req.getRequestURI()));
    }

}


