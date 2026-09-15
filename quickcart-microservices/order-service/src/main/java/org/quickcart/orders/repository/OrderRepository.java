package org.quickcart.orders.repository;

import org.quickcart.orders.entity.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OrderRepository extends JpaRepository<OrderItem, Long> {
}
