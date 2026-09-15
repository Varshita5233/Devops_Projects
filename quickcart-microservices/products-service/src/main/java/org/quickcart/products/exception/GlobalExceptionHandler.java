package org.quickcart.products.exception;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ProductsNotFoundException.class)
    public ResponseEntity<ApiError> handleAlreadyCanceledOrder(ProductsNotFoundException ex,
                                                               HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(new ApiError(Instant.now(), 404, ex.getMessage(), req.getRequestURI()));
    }

    @ExceptionHandler(InsufficientStocksAvailable.class)
    public ResponseEntity<ApiError> handleInsufficientStocks(InsufficientStocksAvailable ex,
                                                               HttpServletRequest req) {
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(new ApiError(Instant.now(), 400, ex.getMessage(), req.getRequestURI()));
    }

}
