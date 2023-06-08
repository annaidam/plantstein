package com.plantstein.server.repository;

import com.plantstein.server.model.Plant;
import com.plantstein.server.model.Room;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long> {
    @Query("select distinct r.clientId from Room r")
    List<String> getAllClientIds();

    @Query("select r from Room r where r.clientId = ?1 order by r.id asc")
    List<Room> findByClientId(String clientId);

    @Query("select p from Plant p where p.room.id = ?1")
    List<Plant> getPlantsInRoom(Long roomId);

    @Transactional
    @Modifying
    @Query("UPDATE Room r SET r.name = ?2 WHERE r.id = ?1")
    Integer updateRoomName(Long id, String newName);

    @Transactional
    @Modifying
    @Query("DELETE FROM Room r WHERE r.clientId = ?1")
    Integer deleteAllByClientId(String clientId);
}