package org.quickcart.orders.feign;

import org.quickcart.orders.config.FeignConfig;
import org.quickcart.orders.dto.ProductDto;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@FeignClient(name="product-service", configuration= {FeignConfig.class})
public interface ProductClient {

    @GetMapping("/api/products/{id}")
    public ProductDto getProductById(@PathVariable Long id);

    @PostMapping("/api/products/{productId}/reserve/{quantity}")
    public ProductDto reserveStock(@PathVariable Long productId, @PathVariable Integer quantity);

    @PostMapping("/api/products/{productId}/release/{quantity}")
    public ProductDto releaseStock(@PathVariable Long productId, @PathVariable Integer quantity);
}
