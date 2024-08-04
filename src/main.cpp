#include <iostream>
#include <fstream>
#include <filesystem>

#include <libevdev-1.0/libevdev/libevdev.h>

#include "InputViewer/Constant.hpp"
#include "InputViewer/FileDescriptor.hpp"

using namespace iv;

void ListInputDevices() {
    struct libevdev *dev = nullptr;
    FileDescriptor fde;
    const std::string path = "/dev/input/";
    std::ifstream dir(path);

    if (!dir.is_open()) {
        std::cerr << "Failed to open directory: " << path << '\n';
        return;
    }

    for (const auto &entry : std::filesystem::directory_iterator("/dev/input/")) {
        std::string device = entry.path().string();
        if (device.find("event") != std::string::npos) {
            fde.set(device);
            dev = libevdev_new();
            if (dev == nullptr) {
                std::cerr << "Failed to allocate libevdev device\n";
                return;
            }
            if (libevdev_set_fd(dev, fde.get()) < 0) {
                std::cerr << "Failed to set fd\n";
                return;
            }
            std::cout << "Input device: " << libevdev_get_name(dev) << '\n';
            libevdev_free(dev);
        }
    }
}

int main() {
    ListInputDevices();
    return IV_SUCCESS;
}