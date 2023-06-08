package com.plantstein.server.util;

public class Utils {
    private Utils() {

    }

    /**
     * @param valueToCheck     The value to check
     * @param targetValue      The target value, that valueToCheck should be close to
     * @param targetValueSlack The slack around the target value, that valueToCheck should be within
     * @return -1 if under target value +slack, +1 if above target value + slack, 0 if within slack
     */
    public static int checkWithinTargetValue(double valueToCheck, double targetValue, double targetValueSlack) {
        if (valueToCheck < targetValue - targetValueSlack) {
            return -1;
        } else if (valueToCheck > targetValue + targetValueSlack) {
            return 1;
        } else {
            return 0;
        }
    }
    
    public static double roundToDecimalPlaces(double value, int decimalPlaces) {
        double scaleFactor = Math.pow(10, decimalPlaces);
        return Math.round(value * scaleFactor) / scaleFactor;
    }
}
