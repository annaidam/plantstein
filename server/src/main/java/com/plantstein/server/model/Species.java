package com.plantstein.server.model;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Entity
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Species {

    @Id
    private String name;

    @NotEmpty
    private Double perfectTemperature;

    @NotEmpty
    private Double perfectLight;

    @NotEmpty
    private Double perfectHumidity;

    @NotEmpty
    private String homeland;

   @NotEmpty
   private String botanicalName;

   @NotEmpty
   private String bloomTime;

    @NotNull
    private Double maxHeight;
}
