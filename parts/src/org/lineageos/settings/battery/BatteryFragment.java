package org.lineageos.settings.battery;

import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;
import androidx.preference.PreferenceScreen;

import org.lineageos.settings.R;

import java.util.Locale;

public class BatteryFragment extends PreferenceFragment {
    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private Preference mStatus;
    private Preference mLevel;
    private Preference mVoltage;
    private Preference mCurrent;
    private Preference mPower;
    private Preference mTemperature;
    private Preference mUptime;
    private Preference mDeepSleep;
    private Preference mDeepSleepRatio;

    private final Runnable mRefresh = new Runnable() {
        @Override
        public void run() {
            update();
            mHandler.postDelayed(this, 2000L);
        }
    };

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        Context context = getActivity();
        PreferenceScreen screen = getPreferenceManager().createPreferenceScreen(context);
        mStatus = add(screen, R.string.battery_status);
        mLevel = add(screen, R.string.battery_level);
        mVoltage = add(screen, R.string.battery_voltage);
        mCurrent = add(screen, R.string.battery_current);
        mPower = add(screen, R.string.battery_power);
        mTemperature = add(screen, R.string.battery_temperature);
        mUptime = add(screen, R.string.device_uptime);
        mDeepSleep = add(screen, R.string.deep_sleep);
        mDeepSleepRatio = add(screen, R.string.deep_sleep_ratio);
        setPreferenceScreen(screen);
    }

    @Override
    public void onResume() {
        super.onResume();
        mRefresh.run();
    }

    @Override
    public void onPause() {
        mHandler.removeCallbacks(mRefresh);
        super.onPause();
    }

    private Preference add(PreferenceScreen screen, int title) {
        Preference preference = new Preference(getActivity());
        preference.setTitle(title);
        preference.setSelectable(false);
        screen.addPreference(preference);
        return preference;
    }

    private void update() {
        Context context = getActivity();
        if (context == null) return;
        Intent battery = context.registerReceiver(null,
                new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
        if (battery == null) return;

        int status = battery.getIntExtra(BatteryManager.EXTRA_STATUS,
                BatteryManager.BATTERY_STATUS_UNKNOWN);
        mStatus.setSummary(statusText(status));

        int level = battery.getIntExtra(BatteryManager.EXTRA_LEVEL, 0);
        int scale = battery.getIntExtra(BatteryManager.EXTRA_SCALE, 100);
        int percent = scale > 0 ? Math.round(level * 100f / scale) : 0;
        mLevel.setSummary(String.format(Locale.getDefault(), "%d%%", percent));

        int millivolts = battery.getIntExtra(BatteryManager.EXTRA_VOLTAGE, 0);
        double volts = millivolts / 1000.0;
        mVoltage.setSummary(String.format(Locale.getDefault(), "%.3f V", volts));

        BatteryManager manager = context.getSystemService(BatteryManager.class);
        long microamps = manager == null ? 0
                : manager.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
        if (microamps == Long.MIN_VALUE) microamps = 0;
        double milliamps = Math.abs(microamps) / 1000.0;
        mCurrent.setSummary(String.format(Locale.getDefault(), "%.0f mA", milliamps));
        mPower.setSummary(String.format(Locale.getDefault(), "%.2f W",
                volts * milliamps / 1000.0));

        int tenths = battery.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, 0);
        mTemperature.setSummary(String.format(Locale.getDefault(), "%.1f °C", tenths / 10.0));

        long elapsed = SystemClock.elapsedRealtime();
        long awake = SystemClock.uptimeMillis();
        long deep = Math.max(0L, elapsed - awake);
        mUptime.setSummary(formatDuration(awake));
        mDeepSleep.setSummary(formatDuration(deep));
        double ratio = elapsed == 0 ? 0 : deep * 100.0 / elapsed;
        mDeepSleepRatio.setSummary(String.format(Locale.getDefault(), "%.1f%%", ratio));
    }

    private String statusText(int status) {
        switch (status) {
            case BatteryManager.BATTERY_STATUS_CHARGING:
                return getString(R.string.charging);
            case BatteryManager.BATTERY_STATUS_DISCHARGING:
                return getString(R.string.discharging);
            case BatteryManager.BATTERY_STATUS_FULL:
                return getString(R.string.full);
            case BatteryManager.BATTERY_STATUS_NOT_CHARGING:
                return getString(R.string.not_charging);
            default:
                return getString(R.string.unknown);
        }
    }

    private String formatDuration(long milliseconds) {
        long seconds = milliseconds / 1000L;
        long hours = seconds / 3600L;
        long minutes = (seconds % 3600L) / 60L;
        long remaining = seconds % 60L;
        return String.format(Locale.getDefault(), "%02dh %02dm %02ds", hours, minutes, remaining);
    }
}
