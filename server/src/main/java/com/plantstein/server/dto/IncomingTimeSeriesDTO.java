package com.plantstein.server.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

@Data
public class IncomingTimeSeriesDTO {

    @NotEmpty
    private Double brightness;

    @NotEmpty
    private Double temperature;

    @NotEmpty
    private Double humidity;

    @NotEmpty
    private String moisture;
}
