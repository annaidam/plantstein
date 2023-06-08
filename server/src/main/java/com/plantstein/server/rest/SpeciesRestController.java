package com.plantstein.server.rest;


import com.plantstein.server.exception.NotFoundException;
import com.plantstein.server.model.Species;
import com.plantstein.server.repository.SpeciesRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.hibernate.cfg.NotYetImplementedException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * The rest controller for all species related requests.
 */
@RestController
@RequestMapping("/species")
@Tag(name = "Species")
@RequiredArgsConstructor
public class SpeciesRestController {
    private final SpeciesRepository speciesRepository;

    @Operation(summary = "Get all species")
    @ApiResponse(responseCode = "200", description = "List of species")
    @GetMapping("/all")
    public List<Species> getAll() {
        return speciesRepository.findAll();
    }

    @Operation(summary = "Get species by ID")
    @ApiResponse(responseCode = "200", description = "Species with that ID")
    @ApiResponse(responseCode = "404", description = "Species with that ID not found", content = @Content)
    @GetMapping("/get/{name}")
    public Species getSpecies(@PathVariable String name) {
        return speciesRepository.findById(name)
                .orElseThrow(() -> new NotFoundException("Species " + name + " does not exist"));
    }

}
