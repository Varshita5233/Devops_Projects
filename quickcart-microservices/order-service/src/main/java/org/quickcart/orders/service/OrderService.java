package org.quickcart.orders.service;

import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import lombok.RequiredArgsConstructor;
import org.quickcart.orders.dto.ProductDto;
import org.quickcart.orders.entity.OrderItem;
import org.quickcart.orders.entity.OrderStatus;
import org.quickcart.orders.exception.*;
import org.quickcart.orders.feign.ProductClient;
import org.quickcart.orders.repository.OrderRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final ProductClient productClient;
    private final OrderRepository orderRepository;

    private final Logger logger = LoggerFactory.getLogger(getClass());

    @CircuitBreaker(name="product-service", fallbackMethod = "createOrderFallback")
    @Retry(name="product-service")
    public OrderItem createOrder(OrderItem order) {
        ProductDto product = productClient.getProductById(order.getProductId());
        productClient.reserveStock(order.getProductId(),  order.getQuantity());
        OrderItem orderItem = new OrderItem();
        orderItem.setProductId(product.getId());
        orderItem.setQuantity(order.getQuantity());
        orderItem.setProductName(product.getName());
        orderItem.setPrice(product.getPrice()*order.getQuantity());
        orderItem.setStatus(OrderStatus.CREATED);

        return orderRepository.save(orderItem);
    }


    @CircuitBreaker(name="product-service", fallbackMethod = "cancelOrderFallback")
    @Retry(name="product-service")
    public OrderItem cancelOrder(Long id){
        OrderItem order=orderRepository.findById(id).orElse(null);
        logger.info("order "+order);
        if(order==null) {
            throw new OrderNotFoundException("Order not found");
        }
        if(order.getStatus() == OrderStatus.CANCELLED) {
            throw new AlreadyCanceledOrderException("Order is already cancelled");
        }
        if(order.getStatus() == OrderStatus.CREATED) {
            productClient.releaseStock(order.getProductId(), order.getQuantity());
            order.setStatus(OrderStatus.CANCELLED);
        }
        return orderRepository.save(order);
    }

    public OrderItem getOrderById(Long id) {
        OrderItem order=orderRepository.findById(id).orElse(null);
        if(order==null) {
            throw new OrderNotFoundException("Order not found");
        }
        return order;
    }

    public List<OrderItem> getOrders() {
        List<OrderItem> orders = orderRepository.findAll();
        if(orders.isEmpty()) {
            throw new OrderNotFoundException("No Orders found");
        }
        return orders;
    }

    public OrderItem createOrderFallback(OrderItem order, Throwable t) throws Throwable {

        if (t instanceof BusinessException) {
            throw t;
        }

        throw new ProductServiceNotAvailableException("Product Service is currently unavailable. Please try again later.");
    }

    public OrderItem cancelOrderFallback(Long id, Throwable t) throws Throwable {

        if (t instanceof BusinessException) {
            throw t;
        }
        throw new ProductServiceNotAvailableException("Product Service is currently unavailable. Please try again later.");
    }
}

