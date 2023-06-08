package com.plantstein.server.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RoomConditionOverTimeDTO {
    private String weekday;
    private double brightness;
    private double temperature;
    private double humidity;
}
