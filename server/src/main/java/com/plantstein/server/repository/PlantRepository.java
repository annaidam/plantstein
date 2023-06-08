package com.plantstein.server.repository;

import com.plantstein.server.model.Plant;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlantRepository extends JpaRepository<Plant, Long> {
    List<Plant> findByNickname(String nickname);

    @Query("select p from Plant p where p.room.clientId = ?1")
    List<Plant> findByClientId(String clientId);

    @Query("select p from Plant p where p.room.clientId = ?2 and p.nickname = ?1")
    List<Plant> findByClientIdAndNickname(String nickname, String clientId);

    @Transactional
    @Modifying
    @Query("UPDATE Plant p SET p.room.id = ?2 WHERE p.id = ?1")
    Integer updatePlantRoom(Long plantId, Long roomId);

    @Transactional
    @Modifying
    @Query("UPDATE Plant p SET p.nickname = ?2 WHERE p.id = ?1")
    Integer updatePlantName(Long id, String newName);

    @Transactional
    @Modifying
    Integer deleteAllByRoomId(Long roomId);

    @Transactional
    @Modifying
    Integer deleteAllByRoomClientId(String clientId);
}
