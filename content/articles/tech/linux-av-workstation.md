---
title: A Better Webcam: Linux AV Workstation with OBS Virtual Camera
tags: linux, obs, video, audio, streaming, webcam, v4l2loopback
icon: fas fa-video
category: Tech
date: 2026-03-09
---

Laptop webcams are terrible. The tiny sensors produce noisy, washed-out video.
Built-in mics pick up every keystroke and fan whir. Bluetooth headsets solve the
mic problem but sound thin and look awkward. I wanted dramatically better
conferencing, streaming, and recording quality by repurposing prosumer hardware I
already owned — no headset required.

[TOC]

## Hardware inventory

| Component | Role | Year | Paid |
| --- | --- | --- | --- |
| Sony NEX-6 mirrorless camera | Video source (HDMI out) | 2014 | $524 |
| Elgato Cam Link 4K | HDMI capture card (USB 3.0) | 2021 | $100 |
| Deity V-Mic D4 Mini | Primary microphone (1/4" thread-mounted on clamp) | 2021 | $62 |
| Movo UCMA-1 TRS 3.5mm → USB-C adapter | Mic analog-to-digital conversion | 2021 | $32 |
| Focusrite Scarlett 2i2 (3rd Gen) | Audio output DAC with physical volume knob | 2021 | $170 |
| Neewer 480 LED bi-color panel | Bounced off ceiling for warm, diffuse lighting | 2021 | $85 |
| UTEBIT 1/4" tripod clip clamp (x2) | Camera and mic mounts | 2023 | $10 |
| Anker Soundcore Space One | Optional output (A2DP high-fidelity mode) | 2024 | $79 |

## Signal flow

<pre class="mermaid">
graph LR
    subgraph Video
        NEX6["Sony NEX-6"] -->|HDMI| CamLink["Elgato Cam Link 4K"]
        CamLink -->|USB 3.0| OBS["OBS Studio"]
        OBS -->|crop filter| OBS
        OBS -->|v4l2loopback| VCam["/dev/video*"]
        VCam --> Apps["Zoom, Meet, Teams, Signal"]
    end

    subgraph Audio Input
        Mic["Deity Shotgun Mic"] -->|TRS 3.5mm| DAC["USB-C DAC Dongle"]
        DAC -->|USB| PW_in["PipeWire"]
        PW_in --> OBS
        PW_in --> Apps
    end

    subgraph Audio Output
        PW_out["PipeWire"] -->|USB| Scarlett["Scarlett 2i2"]
        Scarlett --> Speakers["Speakers, Headphones"]
        PW_out -.->|Bluetooth A2DP| Anker["Anker Soundcore"]
    end
</pre>

## Software stack

| Software | Version / Source | Role |
| --- | --- | --- |
| Pop!_OS 24.04 LTS | COSMIC desktop, Wayland | Operating system |
| OBS Studio | 32.0.4 (Flatpak) | Video compositing and virtual camera |
| PipeWire | 1.5.85 | Audio routing |
| v4l2loopback | DKMS | Virtual webcam kernel module |
| OBS Background Removal | Plugin | AI-powered background removal |
| OBS Composite Blur | Plugin | Gaussian/box blur for background |

## The virtual webcam trick

The key to this setup is **v4l2loopback** — a kernel module that creates a
virtual Video4Linux2 device. OBS writes its composited output to this device, and
every application on the system sees it as a normal USB webcam.

### How it works

1. **v4l2loopback** is installed via DKMS so it rebuilds automatically on kernel
   updates.
2. A **sudoers rule** allows passwordless `modprobe v4l2loopback` for users in
   the `sudo` group — no password prompt when OBS starts the virtual camera.
3. Click **Start Virtual Camera** in OBS. The module loads and creates
   `/dev/video*`.
4. Open any conferencing app — Zoom, Google Meet, Teams, Signal — and select the
   OBS virtual camera from the video device list.

That's it. Every app gets the same high-quality, composited video feed with
background removal, color correction, and whatever else OBS provides.

**Flatpak note:** The OBS Flatpak ships with `devices=all` in its default
permissions, so it can access `/dev/video*` devices (both the Cam Link input and
the v4l2loopback output) without any Flatseal overrides.

## Cropping the Sony NEX-6 HDMI output

The NEX-6 doesn't have a "clean" HDMI output — it overlays exposure info, focus
indicators, and framing guides onto the HDMI signal. This is common on older
mirrorless cameras that predate the streaming era.

The fix is simple: an **OBS crop/pad filter** on the capture source. Crop the
overlay bars from each edge to isolate the actual video feed. The result is a
clean, full-frame image from a camera that was never designed for this purpose.

## Audio routing with PipeWire

PipeWire handles all audio routing with zero configuration beyond setting
defaults:

- **Input:** The Deity shotgun mic is 1/4"-thread mounted on a heavy clamp
  attached to the laptop stand, less than two feet from my mouth and out of
  frame. The mic's supercardioid pickup is aimed at my voice and oriented 90°
  away from the keyboard, maximizing noise rejection. It never needs to be
  relocated and doesn't interfere with hand movement or line of sight to any
  device. It connects through the USB-C DAC dongle and appears as "USB PnP
  Audio Device" — set it as the default PipeWire source.
- **Output:** The Scarlett 2i2 is the default sink. Its physical volume knob
  controls speaker and headphone levels without touching software.
- **Bluetooth fallback:** The Anker Soundcore headphones connect in **A2DP
  mode** (high-fidelity stereo) rather than HFP headset mode. A2DP sounds
  dramatically better — full frequency range instead of the telephone-quality
  8 kHz mono that HFP provides. The tradeoff is that A2DP is output-only, so
  the Deity mic remains the input source.

The OBS **Background Removal** plugin can also apply noise suppression when
needed, though the shotgun mic's directional pickup pattern already rejects most
ambient noise.

## Reproducing this setup

Here's the concise checklist if you want to build something similar:

1. **Install OBS Studio** — Flatpak recommended for automatic updates:

        flatpak install flathub com.obsproject.Studio

2. **Install v4l2loopback** via DKMS:

        sudo apt install v4l2loopback-dkms

3. **Add a sudoers rule** for passwordless modprobe:

        echo '%sudo ALL=(ALL) NOPASSWD: /sbin/modprobe v4l2loopback' | sudo tee /etc/sudoers.d/v4l2loopback

4. **Connect your capture card** (Cam Link 4K or similar) and camera via HDMI.

5. **Configure OBS:**
    - Add a Video Capture Device source (select the Cam Link).
    - Add a crop/pad filter if your camera overlays metadata on HDMI.
    - Set up any additional filters (background removal, color correction).

6. **Set audio defaults** in PipeWire / PulseAudio settings:
    - Default source → your USB mic/DAC.
    - Default sink → your audio interface or speakers.

7. **Start Virtual Camera** in OBS and select it in your conferencing app.

<!-- TODO: Add photos
- Physical desk/camera setup
- OBS scene showing the crop filter
- Virtual camera device appearing in a conferencing app
-->
