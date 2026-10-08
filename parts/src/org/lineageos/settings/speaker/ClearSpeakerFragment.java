package org.lineageos.settings.speaker;

import android.media.AudioAttributes;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioTrack;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.preference.Preference;
import androidx.preference.PreferenceFragment;
import androidx.preference.SwitchPreferenceCompat;

import org.lineageos.settings.R;

public class ClearSpeakerFragment extends PreferenceFragment
        implements Preference.OnPreferenceChangeListener {
    private static final int SAMPLE_RATE = 48000;
    private static final long DURATION_MS = 30000L;

    private final Handler mHandler = new Handler(Looper.getMainLooper());
    private volatile boolean mRunning;
    private volatile AudioTrack mTrack;
    private Thread mAudioThread;
    private SwitchPreferenceCompat mSwitch;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        setPreferencesFromResource(R.xml.clear_speaker_settings, rootKey);
        mSwitch = findPreference("clear_speaker");
        mSwitch.setOnPreferenceChangeListener(this);
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if ((Boolean) newValue) {
            startPlaying();
        } else {
            stopPlaying();
        }
        return true;
    }

    @Override
    public void onStop() {
        stopPlaying();
        super.onStop();
    }

    private void startPlaying() {
        if (mRunning) return;
        requireActivity().setVolumeControlStream(AudioManager.STREAM_MUSIC);
        int minimum = AudioTrack.getMinBufferSize(SAMPLE_RATE,
                AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT);
        int bufferSize = Math.max(minimum, SAMPLE_RATE / 5);
        AudioTrack track = new AudioTrack.Builder()
                .setAudioAttributes(new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                        .build())
                .setAudioFormat(new AudioFormat.Builder()
                        .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                        .setSampleRate(SAMPLE_RATE)
                        .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                        .build())
                .setBufferSizeInBytes(bufferSize)
                .setTransferMode(AudioTrack.MODE_STREAM)
                .build();
        if (track.getState() != AudioTrack.STATE_INITIALIZED) {
            track.release();
            mSwitch.setChecked(false);
            return;
        }

        mTrack = track;
        mRunning = true;
        track.play();
        mAudioThread = new Thread(() -> streamTone(track), "SeaSpeakerClean");
        mAudioThread.start();
        mHandler.postDelayed(() -> {
            stopPlaying();
            if (mSwitch != null) mSwitch.setChecked(false);
        }, DURATION_MS);
    }

    private void streamTone(AudioTrack track) {
        short[] samples = new short[2048];
        long frame = 0;
        double phase = 0.0;
        try {
            while (mRunning) {
                for (int i = 0; i < samples.length; i++, frame++) {
                    double sweep = (frame % (SAMPLE_RATE * 4L)) / (SAMPLE_RATE * 4.0);
                    double frequency = 155.0 + 95.0 * (sweep < 0.5 ? sweep * 2.0
                            : 2.0 - sweep * 2.0);
                    phase += 2.0 * Math.PI * frequency / SAMPLE_RATE;
                    if (phase > 2.0 * Math.PI) phase -= 2.0 * Math.PI;
                    samples[i] = (short) (Math.sin(phase) * 26000.0);
                }
                if (track.write(samples, 0, samples.length, AudioTrack.WRITE_BLOCKING) < 0) break;
            }
        } catch (IllegalStateException ignored) {
        }
    }

    private void stopPlaying() {
        mHandler.removeCallbacksAndMessages(null);
        mRunning = false;
        AudioTrack track = mTrack;
        mTrack = null;
        if (track != null) {
            try {
                track.pause();
                track.flush();
                track.stop();
            } catch (IllegalStateException ignored) {
            }
            track.release();
        }
        if (mAudioThread != null) {
            mAudioThread.interrupt();
            mAudioThread = null;
        }
        if (mSwitch != null && mSwitch.isChecked()) mSwitch.setChecked(false);
    }
}
