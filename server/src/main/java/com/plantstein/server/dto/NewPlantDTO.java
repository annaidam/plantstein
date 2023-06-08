package com.plantstein.server.dto;

import lombok.Data;

@Data
public class NewPlantDTO {
    private String nickname;
    private String species;
    private Long roomId;
}
