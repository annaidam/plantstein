package com.plantstein.server;

public class AppConfig {

    private AppConfig() {
    }

    public enum Topic {
        TIMESERIES("timeseries"),
        PLANT_CONDITIONS("plant-conditions");
        private final String stringRepresentation;

        Topic(String stringRepresentation) {
            this.stringRepresentation = stringRepresentation;
        }

        @Override
        public String toString() {
            return stringRepresentation;
        }
    }

    public static final double BRIGHTNESS_SLACK = 250;
    public static final double TEMPERATURE_SLACK = 2.0;
    public static final double HUMIDITY_SLACK = 10;
    public static final int PLANT_CONDITION_PUBLISH_INTERVAL = 3000;

}
