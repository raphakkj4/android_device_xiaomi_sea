package org.lineageos.settings.seaparts;

import android.content.Intent;
import android.os.Bundle;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;

import org.lineageos.settings.R;
import org.lineageos.settings.battery.BatteryActivity;
import org.lineageos.settings.gpu.GpuActivity;
import org.lineageos.settings.speaker.ClearSpeakerActivity;

public class SeaPartsFragment extends PreferenceFragment {
    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource(R.xml.sea_parts_settings, rootKey);
        bind("gpu", GpuActivity.class);
        bind("battery", BatteryActivity.class);
        bind("clear_speaker", ClearSpeakerActivity.class);
    }

    private void bind(String key, Class<?> activity) {
        Preference preference = findPreference(key);
        if (preference != null) {
            preference.setOnPreferenceClickListener(clicked -> {
                startActivity(new Intent(requireContext(), activity));
                return true;
            });
        }
    }
}
