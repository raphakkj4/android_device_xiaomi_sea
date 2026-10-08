package org.lineageos.settings.gpu;

import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.widget.Toast;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;

import org.lineageos.settings.R;

public class GpuFragment extends PreferenceFragment {
    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private Preference mMode;
    private Preference mFrequency;
    private Preference mUtilization;

    private final Runnable mRefresh = new Runnable() {
        @Override
        public void run() {
            update();
            mHandler.postDelayed(this, 1000L);
        }
    };

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource(R.xml.gpu_settings, rootKey);
        mMode = findPreference("gpu_mode");
        mFrequency = findPreference("gpu_frequency");
        mUtilization = findPreference("gpu_utilization");
        Preference restore = findPreference("gpu_restore");
        if (restore != null) {
            restore.setOnPreferenceClickListener(preference -> {
                boolean restored = GpuUtils.restoreDynamicScaling();
                Toast.makeText(getActivity(), restored ? R.string.gpu_restored
                        : R.string.gpu_restore_failed, Toast.LENGTH_SHORT).show();
                update();
                return true;
            });
        }
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

    private void update() {
        String fixedOpp = GpuUtils.getFixedOpp();
        if (fixedOpp == null) {
            mMode.setSummary(R.string.gpu_unavailable);
        } else if (fixedOpp.trim().equals("-1")) {
            mMode.setSummary(R.string.gpu_dynamic);
        } else {
            mMode.setSummary(getString(R.string.gpu_locked, fixedOpp.trim()));
        }
        setSummary(mFrequency, GpuUtils.getCurrentFrequency());
        setSummary(mUtilization, GpuUtils.getUtilization());
    }

    private void setSummary(Preference preference, String value) {
        preference.setSummary(value == null ? getString(R.string.gpu_unavailable) : value);
    }
}
