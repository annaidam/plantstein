package com.plantstein.server.rest;

import com.plantstein.server.AppConfig;
import com.plantstein.server.dto.NewPlantDTO;
import com.plantstein.server.dto.PlantConditionDTO;
import com.plantstein.server.dto.RoomConditionDTO;
import com.plantstein.server.exception.NotFoundException;
import com.plantstein.server.model.*;
import com.plantstein.server.repository.PlantRepository;
import com.plantstein.server.repository.PlantTimeSeriesRepository;
import com.plantstein.server.repository.RoomRepository;
import com.plantstein.server.repository.SpeciesRepository;
import com.plantstein.server.util.Utils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * The rest controller for all plant related requests.
 */
@RestController
@RequestMapping("/plant")
@Tag(name = "Plant")
@RequiredArgsConstructor
public class PlantRestController {
    private final PlantRepository plantRepository;
    private final SpeciesRepository speciesRepository;
    private final RoomRepository roomRepository;
    private final PlantTimeSeriesRepository plantTimeSeriesRepository;
    private final RoomRestController roomRestController;

    @Operation(summary = "Get all plants of user")
    @ApiResponse(responseCode = "200", description = "List of plants")
    @GetMapping("/all")
    public List<Plant> getAll(@RequestHeader String clientId) {
        return plantRepository.findByClientId(clientId);
    }

    @Operation(summary = "Get plants of user by nickname")
    @ApiResponse(responseCode = "200", description = "List of plants with that nickname (list can be empty)")
    @GetMapping("/nickname/{nickname}")
    public List<Plant> getByNickname(@PathVariable String nickname, @RequestHeader String clientId) {
        return plantRepository.findByClientIdAndNickname(nickname, clientId);
    }

    @Operation(summary = "Get plant")
    @ApiResponse(responseCode = "200", description = "Plant object")
    @ApiResponse(responseCode = "404", description = "Plant with that ID not found", content = @Content)
    @GetMapping("/get/{id}")
    public Plant getPlant(@PathVariable Long id) {
        return plantRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Plant " + id + " does not exist"));
    }

    @Operation(summary = "Add plant")
    @ApiResponse(responseCode = "201", description = "Added plant")
    @ApiResponse(responseCode = "400", description = "Invalid plant data", content = @Content)
    @ApiResponse(responseCode = "404", description = "Room does not exist", content = @Content)
    @ApiResponse(responseCode = "404", description = "Species does not exist", content = @Content)
    @PostMapping("/add")
    public ResponseEntity<Plant> addPlant(@RequestBody NewPlantDTO plantDTO) {
        Room room = roomRepository.findById(plantDTO.getRoomId())
                .orElseThrow(() -> new NotFoundException("Room with ID " + plantDTO.getRoomId() + " does not exist"));
        Species species = speciesRepository.findById(plantDTO.getSpecies())
                .orElseThrow(() -> new NotFoundException("Species " + plantDTO.getSpecies() + " does not exist"));

        Plant plant = Plant.builder()
                .nickname(plantDTO.getNickname())
                .species(species)
                .room(room)
                .build();

        return new ResponseEntity<>(plantRepository.save(plant), HttpStatus.CREATED);
    }

    @Operation(summary = "Rename plant")
    @ApiResponse(responseCode = "200", description = "Plant renamed")
    @ApiResponse(responseCode = "404", description = "Plant with that ID not found", content = @Content)
    @PutMapping("/rename/{id}/{newName}")
    public Plant renamePlant(@PathVariable Long id, @PathVariable String newName) {
        if (!plantRepository.existsById(id))
            throw new NotFoundException("Plant " + id + " does not exist");

        plantRepository.updatePlantName(id, newName);
        return plantRepository.findById(id).orElseThrow();
    }

    @Operation(summary = "Change room of plant")
    @ApiResponse(responseCode = "200", description = "Plant moved into new room")
    @ApiResponse(responseCode = "404", description = "Plant with that ID not found", content = @Content)
    @PutMapping("/change-room/{plantId}/{newRoom}")
    public Plant changeRoom(@PathVariable Long plantId, @PathVariable Long newRoom) {
        if (!plantRepository.existsById(plantId))
            throw new NotFoundException("Plant " + plantId + " does not exist");
        if (!roomRepository.existsById(newRoom)) {
            throw new NotFoundException("Room with ID " + newRoom + " does not exist");
        }
        plantRepository.updatePlantRoom(plantId, newRoom);
        return plantRepository.findById(plantId).orElseThrow();
    }

    @Operation(summary = "Delete plant")
    @ApiResponse(responseCode = "200", description = "Plant deleted")
    @ApiResponse(responseCode = "404", description = "Plant with that ID not found", content = @Content)
    @DeleteMapping("/delete/{id}")
    public Plant deletePlant(@PathVariable Long id) {
        Plant plant = plantRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Plant " + id + " does not exist"));
        plantRepository.deleteById(id);
        return plant;
    }

    @Operation(summary = "Get condition")
    @ApiResponse(responseCode = "200", description = "Plant condition object")
    @ApiResponse(responseCode = "404", description = "Plant with that ID not found", content = @Content)
    @GetMapping("/condition/{id}")
    public PlantConditionDTO getCondition(@PathVariable Long id) {
        Plant plant = plantRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Plant " + id + " does not exist"));
        RoomConditionDTO condition = roomRestController.getCondition(plant.getRoom().getId());

        List<PlantTimeSeries> plantRTSEntries = plantTimeSeriesRepository.findFirst3ByPlantIdOrderByTimestampDesc(id);
        Moisture averageMoisture = plantRTSEntries.isEmpty() ? null : Moisture.getAverageMoisture(
                plantRTSEntries.stream()
                        .map(PlantTimeSeries::getMoisture)
                        .toList()
        );

        boolean brightnessIsOk = condition.getBrightness() == null ? false : Utils.checkWithinTargetValue(condition.getBrightness(), plant.getSpecies().getPerfectLight(), AppConfig.BRIGHTNESS_SLACK) == 0;
        boolean temperatureIsOk = condition.getTemperature() == null ? false : Utils.checkWithinTargetValue(condition.getTemperature(), plant.getSpecies().getPerfectTemperature(), AppConfig.TEMPERATURE_SLACK) == 0;
        boolean humidityIsOk = condition.getHumidity() == null ? false : Utils.checkWithinTargetValue(condition.getHumidity(), plant.getSpecies().getPerfectHumidity(), AppConfig.HUMIDITY_SLACK) == 0;
        boolean moistureIsOk = averageMoisture == null ? false : averageMoisture.equals(Moisture.OKAY);

        return PlantConditionDTO.builder()
                .plantId(id)
                .plantNickname(plant.getNickname())
                .temperature(condition.getTemperature())
                .perfectTemperature(plant.getSpecies().getPerfectTemperature())
                .temperatureIsOk(temperatureIsOk)
                .humidity(condition.getHumidity())
                .perfectHumidity(plant.getSpecies().getPerfectHumidity())
                .humidityIsOk(humidityIsOk)
                .brightness(condition.getBrightness())
                .perfectBrightness(plant.getSpecies().getPerfectLight())
                .brightnessIsOk(brightnessIsOk)
                .moisture(averageMoisture)
                .moistureIsOk(moistureIsOk)
                .build();
    }

}