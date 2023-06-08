package com.plantstein.server.repository;

import com.plantstein.server.model.PlantTimeSeries;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlantTimeSeriesRepository extends JpaRepository<PlantTimeSeries, Long> {
    List<PlantTimeSeries> findFirst3ByPlantIdOrderByTimestampDesc(Long plantId);
}
