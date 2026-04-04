package org.quickcart.products.controller;

import lombok.RequiredArgsConstructor;
import org.quickcart.products.entity.Product;
import org.quickcart.products.service.ProductsService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProductsController {

    private final ProductsService productsService;

    @GetMapping("/api/products")
    public ResponseEntity<List<Product>> getProducts() {
        return ResponseEntity.ok(productsService.getProducts());
    }

    @GetMapping("/api/products/{id}")
    public ResponseEntity<?> getProductById(@PathVariable Long id) {
        return ResponseEntity.ok(productsService.getProductById(id));
    }

    @PostMapping("/api/products")
    public ResponseEntity<Product> createProduct(@RequestBody Product product) {
        Product savedProduct =productsService.saveProduct(product);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedProduct);
    }

    @PostMapping("/api/products/{productId}/reserve/{quantity}")
    public ResponseEntity<?> reserveStock(@PathVariable Long productId,@PathVariable Integer quantity) {
        return ResponseEntity.ok(productsService.reserveStock(productId,quantity));
    }

    @PostMapping("/api/products/{productId}/release/{quantity}")
    public ResponseEntity<?> releaseStock(@PathVariable Long productId, @PathVariable Integer quantity) {
        return ResponseEntity.ok(productsService.releaseStock(productId,quantity));
    }
}
