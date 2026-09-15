package org.quickcart.orders.controller;

import lombok.RequiredArgsConstructor;
import org.quickcart.orders.entity.OrderItem;
import org.quickcart.orders.service.OrderService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    @PostMapping("/api/orders")
    public ResponseEntity<?> createOrder(@RequestBody OrderItem order){
        return ResponseEntity.ok(orderService.createOrder(order));
    }

    @PostMapping("/api/orders/{id}/cancel")
    public ResponseEntity<?> cancelOrder(@PathVariable Long id){
        return ResponseEntity.ok(orderService.cancelOrder(id));
    }

    @GetMapping("api/orders/{id}")
    public ResponseEntity<?> getOrderById(@PathVariable Long id) {
        return ResponseEntity.ok(orderService.getOrderById(id));
    }

    @GetMapping("api/orders")
    public ResponseEntity<List<OrderItem>> getProducts() {
        return ResponseEntity.ok(orderService.getOrders());
    }
}
