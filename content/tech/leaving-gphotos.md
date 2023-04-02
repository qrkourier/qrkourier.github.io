Title: How I Reclaimed Storage Space in Google Photos By Moving All My Videos
Tags: python, backup, rclone
Icon: fas fa-video-slash

There's no easy way to find and delete a particular file or type of file in Google Photos, and there's no way to bulk delete with a tool or even the API. Here's a simple tool chain that answered my need to move all videos out to reclaim storage space.

[TOC]

Google Photos has some unique talents. I find it useful for exploring my own archives with the built-in machine learning features like "pictures from Ashland" or "red car". The balance of value is less favorable for videos, and they were the only reason I was paying for 2TB of cloud storage, so I decided to prune them out of my Google Photos account.

Problem: there's no easy way to do that! Even the API doesn't have a delete operation. I can find them easily enough in the app by searching "videos", and I can painstakingly download them and delete them, but I'd prefer to express this as code, if possible.

## Sync Photos and Videos

I found `gphotos-sync`, a handy implementation of the Google Photos API that creates a local replica of the entire library with albums and other metadata that I didn't need. Still, supremely useful to make sure I have a copy of all videos.

## Move Videos

I wrote a tiny Python program to to move my videos out of the gphotos-sync directory.

1. walk the gphotos-sync photos directory
1. detect if a file is a video MIME type
1. move the videos to a new folder

```shell
❯ python ./move_videos.py
Moving: ./2017/02/2017-02-15-they-sang.mp4 787.8MiB -> ./Videos/videos_from_gphotos/2017/02/2017-02-15-they-sang.mp4
Moving: ./2003/04/or-portland-roofing_residence.3gp 849.1KiB -> ./Videos/videos_from_gphotos/2003/04/or-portland-roofing_residence.3gp
Moving: ./2003/02/or-ashland-alex_and_ax_blowin_in_the_wind.3gp 1.0MiB -> ./Videos/videos_from_gphotos/1973/02/or-ashland-alex_and_ax_blowin_in_the_wind.3gp
Total: 58.7GiB
```

```python
import filetype
from os.path import join, getsize, dirname
from os import walk, chdir
from shutil import move
from pathlib import Path

# move_videos.py moves files with a video MIME type to a different top-level directory with the same directory structure

def main():
    # The top argument for walk
    topdir = './Downloads/from_gphotos/photos'
    dest_topdir = './Videos/videos_from_gphotos'
    chdir(topdir)

    total_bytes = 0
    for root, dirs, files in walk('.'):
        for name in files:
            if Path(join(root, name)).is_symlink():
                continue
            elif filetype.is_video(join(root, name)):
                size = getsize(join(root, name))
                total_bytes = size+total_bytes
                dest = Path(join(dest_topdir, root.strip('./'), name))
                print("Moving:", join(root, name), sizeof_fmt(size), "->", dest)
                try:
                    parent = Path(dirname(dest))
                    parent.mkdir(parents=True, exist_ok=True)
                    move(join(root, name), dest)
                except Exception:
                    raise
            else:
                pass
    print("Total:", sizeof_fmt(total_bytes))


def sizeof_fmt(num, suffix="B"):
    for unit in ["", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei", "Zi"]:
        if abs(num) < 1024.0:
            return f"{num:3.1f}{unit}{suffix}"
        num /= 1024.0
    return f"{num:.1f}Yi{suffix}"


if __name__ == '__main__':
    main()
```

## Delete All Videos From Google Photos

There's a simple trick to do this in a fell swoop.

1. search "videos" and make sure the results are all videos
1. tick the select box on the first result
1. scroll down to the bottom of results
1. hold SHIFT and left-click the last result
1. click the trash button or press `#` to delete

As of this writing the videos would be in Trash for 60 days before they're permanently deleted and the available storage returned to you.

## Replicated Videos to New Storage

I still need to keep a copy of my videos off-site in case something happens to my storage at home or I lose access for some reason. I didn't want to keep track of copying the files so it needs to be an automated sync.

I chose `rclone` which is a versatile sync tool for cloud storage. It works with S3-compliant APIs, and I found STORJ has a very cheap option and as a bonus it is a form decentralized storage with an open-source bent. Cool.

1. I signed up for Storj's free 150GB option and added about 20 USD worth of STORJ tokens to my account to cover future overages. No credit card required. 
1. I followed [Storj's own guide](https://docs.storj.io/dcs/how-tos/sync-files-with-rclone/rclone-with-native-integration/) for configuring `rclone`.
1. I added a sync command to my backup script:

```bash
rclone sync ~/Videos/ storj:videos/
```