package com.plantstein.server.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public enum Moisture {
    TOO_DRY, OKAY, TOO_WET;


    public static Moisture fromString(String moistureString) {
        Double value = Double.parseDouble(moistureString);
        if (value < 300)
            return TOO_DRY;
        if (value < 700)
            return OKAY;
        else if (value >= 700)
            return TOO_WET;

        throw new IllegalArgumentException("Invalid moisture string: " + moistureString);
    }

    public static Moisture getAverageMoisture(List<Moisture> list) {
        Map<Moisture, Integer> countMap = new HashMap<>();
        for (Moisture moisture : list) {
            countMap.put(moisture, countMap.getOrDefault(moisture, 0) + 1);
        }

        Moisture mostFrequentMoisture = OKAY;
        int highestCount = 0;
        for (Map.Entry<Moisture, Integer> entry : countMap.entrySet()) {
            if (entry.getValue() > highestCount) {
                mostFrequentMoisture = entry.getKey();
                highestCount = entry.getValue();
            }
        }

        return mostFrequentMoisture;
    }

}
