# Kartalytics

Kartalytics is a project to in real time analyse Mario Kart 8 Deluxe matches as they're being played and then take action on that analysis.

It is comprised of 3 main parts:

## Recorder

Its function is to capture the input stream of Mario Kart and save it out as sequence of snapshots. To do this we'll use the following hardware:
  - HDMI splitter
  - HDMI to ethernet converter ([LKV373A](http://www.ebay.com.au/itm/LKV373A-V3-0-HDMI-Extender-100-120M-HDMI-Extender-Over-Cat5-Cat6-TCP-IP-based-/162287794299))
  - Raspberry Pi

We'll use the approach/software developed here:

https://github.com/benjojo/de-ip-hdmi/blob/master/main.go

https://blog.danman.eu/new-version-of-lenkeng-hdmi-over-ip-extender-lkv373a/)

https://trac.ffmpeg.org/wiki/Create%20a%20thumbnail%20image%20every%20X%20seconds%20of%20the%20video - here is how to dump images every ~second or so.  `%t` will interpolate a timestamp into the filename

http://engineer2you.blogspot.com.au/2016/10/rasbperry-pi-ffmpeg-install-and-stream.html

https://stackoverflow.com/questions/35338478/buffering-while-converting-stream-to-frames-with-ffmpeg

https://www.raspberrypi.org/forums/viewtopic.php?f=70&t=152499

### How to run:

http://ffmpeg.gusari.org/viewtopic.php?f=12&t=624

sysctl -w net.core.rmem_max=26214400

ffmpeg -i udp://239.255.42.42:5004?localaddr=169.254.244.97 -c copy -map 0 -f tee "[f=mpegts]udp://239.255.42.42:5004?localaddr=169.254.244.97|[f=mpegts]pipe:" | ffmpeg -f mpegts -skip_frame nokey -i pipe: -vsync 0 out%d.png


ffmpeg -i  -c copy -map 0 -f tee "[f=mpegts]udp://239.255.42.42:5004?localaddr=169.254.244.97|[f=mpegts]pipe:" | ffmpeg -f mpegts -skip_frame nokey -i pipe: -vf select='not(mod(n,5))' -vsync 0 out%d.png


STEP 1:
sudo iptables -t raw -A PREROUTING -p udp -m length --length 28 -j DROP

https://stackoverflow.com/questions/42612315/ffmpeg-extract-a-fram-from-a-live-stream-once-every-5-seconds

STEP 2:
All of these cause crappy pictures after a while
ffmpeg -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=50000000" -vf fps=2 -qscale:v 5 out%04d.jpg

ffmpeg -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=50000000"  -r 2 -f image2 'out%04d.jpg'

ffmpeg -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000"  -r 2 -f image2 'out%04d.jpg'

To test:

avconv -skip_frame nokey -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000" -vf fps=2 -qscale:v 5 out%04d.jpg

avconv -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000" -r 2 -s WxH -f image2 foo-%03d.jpeg

ffmpeg -skip_frame nokey -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000" -c:v h264 -vf fps=2 -qscale:v 5 out%04d.jpg


Currently testing:

ffmpeg -skip_frame nokey -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000" -vf fps=2 -qscale:v 5 out%04d.jpg

APPEARS GOOD!!

ffmpeg -skip_frame nokey -i "udp://239.255.42.42:5004?localaddr=169.254.244.97&buffer_size=128000&overrun_nonfatal=1&fifo_size=500000" -vf fps=2 -qscale:v 5 out%04d.jpg

### Raspberry pi config

Improvements to raspberry pi performance:
  - Disable GUI
  - Ramdisk for tmp image writes
  - https://www.linux-toys.com/?p=1153

mount -t tmpfs -o size=1m tmpfs [MOUNTPOINT]

http://www.jamescoyle.net/how-to/943-create-a-ram-disk-in-linux



## Analyser

Its function is to take the raw snapshot images and analyse them to determine what is happening in the image.  It is stateless and it simply populate an event stream with events such as:
  - Load screen
  - Main Menu
  - Race Start (race_name)
  - Race Underway
    - Player 1 (position: 6, items: [red shell, none], coins: 5)
    - etc
  - Race finish:
    - Player 1 (position: 2, points: 12)
  - View Results:
    - Player 1 (position: 3, points: 87)

## Brain

The brain is responsible for consuming the event stream and reconstituting those into a concept of Games/Players/Results etc.  As an example, the brain sees a series of race underway events then a "Main Menu" event, it should assume the game has been abandoned.  Likewise if it sees a series of Race Underway events then a Race Finish then a View Results it should assume a game has been completed.

## What can we do with it

Would be cool if we can track fastest race on a given course.  To do this we'd need to start extracting course name on race start