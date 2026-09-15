package org.quickcart.orders.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class StockDto {

    private Long id;
    private Integer reservedQuantity;
    private Integer availableQuantity;
    private Integer physicalQuantity;
}
