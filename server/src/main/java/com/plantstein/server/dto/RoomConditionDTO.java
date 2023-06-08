package com.plantstein.server.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoomConditionDTO {
    private Double brightness;
    private Double temperature;
    private Double humidity;
}
