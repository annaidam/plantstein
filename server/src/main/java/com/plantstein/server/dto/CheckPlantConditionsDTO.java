package com.plantstein.server.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CheckPlantConditionsDTO {
    private Long plantId;
    private String plantName;
    private String message;
}
