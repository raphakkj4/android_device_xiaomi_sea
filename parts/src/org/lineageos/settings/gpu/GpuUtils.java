package org.lineageos.settings.gpu;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

final class GpuUtils {
    private static final String FIXED_OPP = "/proc/gpufreqv2/fix_target_opp_index";
    private static final String CURRENT_FREQUENCY = "/sys/kernel/ged/hal/current_freqency";
    private static final String UTILIZATION = "/sys/kernel/ged/hal/gpu_utilization";
    private static final Pattern INTEGER = Pattern.compile("-?\\d+");

    private GpuUtils() {
    }

    static String getFixedOpp() {
        String value = read(FIXED_OPP);
        if (value == null) return null;
        Matcher matcher = INTEGER.matcher(value);
        return matcher.find() ? matcher.group() : value.trim();
    }

    static String getCurrentFrequency() {
        String value = read(CURRENT_FREQUENCY);
        if (value == null) return null;
        String[] fields = value.trim().split("\\s+");
        if (fields.length < 2) return value;
        try {
            long frequency = Long.parseLong(fields[1]);
            double mhz = frequency > 10000000L ? frequency / 1000000.0 : frequency / 1000.0;
            return String.format(Locale.getDefault(), "%.0f MHz (OPP %s)", mhz, fields[0]);
        } catch (NumberFormatException exception) {
            return value;
        }
    }

    static String getUtilization() {
        String value = read(UTILIZATION);
        if (value == null) return null;
        String[] fields = value.trim().split("\\s+");
        if (fields.length < 3) return value;
        return String.format(Locale.getDefault(), "Load %s%% · blocked %s%% · idle %s%%",
                fields[0], fields[1], fields[2]);
    }

    static boolean restoreDynamicScaling() {
        try (FileWriter writer = new FileWriter(FIXED_OPP)) {
            writer.write("-1");
            return true;
        } catch (IOException exception) {
            return false;
        }
    }

    private static String read(String path) {
        try (BufferedReader reader = new BufferedReader(new FileReader(path), 256)) {
            return reader.readLine();
        } catch (IOException exception) {
            return null;
        }
    }
}
