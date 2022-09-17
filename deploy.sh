git pull
cmake -S . -B build 1> log_cmake.txt 2>&1
cd build && make 1> log_build.txt 2>&1
sleep 1
mv -f /home/xynera/build/tfs /home/xynera/tfs
mv -f /home/xynera/build/log_build.txt /home/xynera/log_build.txt
pkill tfs