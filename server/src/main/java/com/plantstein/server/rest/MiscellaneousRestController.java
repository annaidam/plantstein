package com.plantstein.server.rest;

import com.plantstein.server.repository.PlantRepository;
import com.plantstein.server.repository.RoomRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping()
@Tag(name = "Miscellaneous")
@RequiredArgsConstructor
public class MiscellaneousRestController {
    private final RoomRepository roomRepository;
    private final PlantRepository plantRepository;

    @Operation(summary = "Delete all user data (rooms, plants)")
    @ApiResponse(responseCode = "200", description = "All user data deleted")
    @DeleteMapping("/delete-user-data")
    public void deleteUserData(@RequestHeader String clientId) {
        plantRepository.deleteAllByRoomClientId(clientId);
        roomRepository.deleteAllByClientId(clientId);
    }
}
