package com.plantstein.server.dto;

import com.plantstein.server.model.Moisture;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlantConditionDTO {
    private Long plantId;
    private String plantNickname;
    private Moisture moisture;
    private boolean moistureIsOk;
    private Double brightness;
    private Double perfectBrightness;
    private boolean brightnessIsOk;
    private Double temperature;
    private Double perfectTemperature;
    private boolean temperatureIsOk;
    private Double humidity;
    private Double perfectHumidity;
    private boolean humidityIsOk;
}
