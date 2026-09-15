package org.quickcart.products.service;

import lombok.RequiredArgsConstructor;
import org.jspecify.annotations.Nullable;
import org.quickcart.products.exception.InsufficientStocksAvailable;
import org.quickcart.products.exception.ProductsNotFoundException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import org.quickcart.products.entity.Product;
import org.quickcart.products.repository.ProductRepository;

import javax.naming.InsufficientResourcesException;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductsService {

    private final ProductRepository productRepository;

    public List<Product> getProducts() {
        List<Product> products = productRepository.findAll();
        if(products.isEmpty()) {
            throw new ProductsNotFoundException("Product not found");
        }
        return products;
    }

    public Product getProductById(Long id) {
        Product product = productRepository.findById(id).orElse(null);
        if(product == null) {
            throw new ProductsNotFoundException("Product not found");
        }
        return product;
    }

    public Product saveProduct(Product product) {
        int availableQuantity=product.getStock().getAvailableQuantity()!=null
                ? product.getStock().getAvailableQuantity() : 0;
        int physicalQuantity=product.getStock().getPhysicalQuantity()!=null
                ? product.getStock().getPhysicalQuantity() : 0;
        product.getStock().setAvailableQuantity(physicalQuantity);
        return productRepository.save(product);
    }

    public Product reserveStock(Long productId, int quantity) {

        Product product = getProductById(productId);

        if(product==null) {
            throw new ProductsNotFoundException("Product not found");
        }

        if(product.getStock().getAvailableQuantity()<quantity) {
            throw new InsufficientStocksAvailable("Insufficient stock available");
        }
        int reservedQuantity=product.getStock().getReservedQuantity()!=null
                ? product.getStock().getReservedQuantity() : 0;

        int availableQuantity=product.getStock().getAvailableQuantity()!=null
                ? product.getStock().getAvailableQuantity() : 0;

        product.getStock().setReservedQuantity(quantity+reservedQuantity);
        product.getStock().setAvailableQuantity(availableQuantity-quantity);
        productRepository.save(product);
        return product;
    }

    public Product releaseStock(Long productId, int quantity) {
        Product product = getProductById(productId);
        if(product==null) {
            throw new ProductsNotFoundException("Product not found");
        }
        int reservedQuantity=product.getStock().getReservedQuantity()!=null
                ? product.getStock().getReservedQuantity() : 0;

        int availableQuantity=product.getStock().getAvailableQuantity()!=null
                ? product.getStock().getAvailableQuantity() : 0;

        product.getStock().setAvailableQuantity(availableQuantity+quantity);
        product.getStock().setReservedQuantity(reservedQuantity-quantity);
        productRepository.save(product);
        return product;
    }
}
