package org.quickcart.products.entity;

import jakarta.persistence.*;
import lombok.*;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Product {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;
        private String name;
        private String description;
        private Double price;
        @OneToOne(cascade = CascadeType.ALL)
        @JoinColumn(name = "stock_id")
        private Stock stock;
}
