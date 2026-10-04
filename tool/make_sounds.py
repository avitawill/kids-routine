"""Generates the app's sound effects. Original, synthesized; no third-party audio.

Run: python3 tool/make_sounds.py  (writes assets/sounds/*.wav)
"""
import math
import struct
import wave

RATE = 22050


def bell(freq, start, dur, vol=0.5, decay=4.0):
    """A soft bell partial: sine + quiet octave, quick attack, exponential decay."""
    return (freq, start, dur, vol, decay)


def render(path, notes, total):
    n = int(RATE * total)
    buf = [0.0] * n
    for freq, start, dur, vol, decay in notes:
        s0 = int(RATE * start)
        for i in range(int(RATE * dur)):
            if s0 + i >= n:
                break
            t = i / RATE
            attack = min(1.0, t / 0.008)
            env = attack * math.exp(-decay * t)
            v = math.sin(2 * math.pi * freq * t) + 0.25 * math.sin(4 * math.pi * freq * t)
            buf[s0 + i] += vol * env * v
    peak = max(abs(x) for x in buf) or 1.0
    scale = 0.7 / peak  # leave headroom; these should never be loud
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(RATE)
        w.writeframes(b"".join(struct.pack("<h", int(x * scale * 32767)) for x in buf))


# Star: bright two-note "ding-ding" up a fifth (C6 -> G6).
render("assets/sounds/star.wav", [bell(1046.5, 0.0, 0.5, decay=7), bell(1568.0, 0.09, 0.6, decay=6)], 0.7)
# Start / next task: friendly three-note rise (C5 E5 G5).
render("assets/sounds/start.wav", [bell(523.3, 0.0, 0.5), bell(659.3, 0.14, 0.5), bell(784.0, 0.28, 0.7)], 1.0)
# Time is up: slow, soft, low chime (G4 -> E4). Gentle, not an alarm.
render("assets/sounds/time_up.wav", [bell(392.0, 0.0, 1.0, vol=0.4, decay=2.5), bell(329.6, 0.35, 1.1, vol=0.4, decay=2.5)], 1.5)
