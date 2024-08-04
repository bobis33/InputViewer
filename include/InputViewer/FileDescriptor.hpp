#pragma once

#include <string>
#include <fcntl.h>
#include <unistd.h>
#include <stdexcept>

namespace iv {

    class FileDescriptor {

        public:

            explicit FileDescriptor() : m_fd(-1) {}

            explicit FileDescriptor(const std::string &path) : m_fd(open(path.c_str(), O_RDONLY | O_NONBLOCK)) { m_fd < 0 ? throw std::runtime_error("Failed to open file descriptor") : 0; }
            ~FileDescriptor() { m_fd >= 0 ? close(m_fd) : 0; }

            [[nodiscard]] int get() const { return m_fd; }
            void set(const std::string &path) {
                if (m_fd >= 0) { close(m_fd); }
                m_fd = open(path.c_str(), O_RDONLY | O_NONBLOCK);
                if (m_fd < 0) {
                    throw std::runtime_error("Failed to open file descriptor");
                }
            }

            FileDescriptor(const FileDescriptor &) = delete;
            FileDescriptor &operator=(const FileDescriptor &) = delete;

            FileDescriptor(FileDescriptor &&other) noexcept : m_fd(other.m_fd) { other.m_fd = -1; }
            FileDescriptor &operator=(FileDescriptor &&other) noexcept {
                if (this != &other) {
                    if (m_fd >= 0) { close(m_fd); }
                    m_fd = other.m_fd;
                    other.m_fd = -1;
                }
                return *this;
            }

        private:

            int m_fd;

    }; // class FileDescriptor

} // namespace iv
