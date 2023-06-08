package com.plantstein.server.repository;

import com.plantstein.server.model.RoomTimeSeries;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.sql.Timestamp;
import java.util.List;


public interface RoomTimeSeriesRepository extends JpaRepository<RoomTimeSeries, Long> {
    List<RoomTimeSeries> findFirst3ByRoomIdOrderByTimestampDesc(Long roomId);

    @Query("""
                SELECT
                    CAST(rts.timestamp AS DATE) as day,
                    DAYNAME(rts.timestamp) as weekday,
                    ROUND(AVG(rts.brightness), 2) as avg_brightness,
                    ROUND(AVG(rts.temperature), 2) as avg_temperature,
                    ROUND(AVG(rts.humidity), 2) as avg_humidity
                FROM
                    RoomTimeSeries rts
                WHERE
                    rts.timestamp >= ?1
                GROUP BY
                    CAST(rts.timestamp AS DATE),
                    DAYNAME(rts.timestamp)
            """)
    List<Object[]> getAvgValuesForLastNDays(Timestamp nLastDays);


}
