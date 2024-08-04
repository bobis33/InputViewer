///
/// @file Constant.hpp
/// @brief This file contains the constant values used in the project
/// @namespace iv
///

#pragma once

#include <cstdint>

namespace iv {

    using return_type_t = enum ReturnType : uint8_t {
        IV_SUCCESS = 0,
        IV_FAILURE = 1
    };

} // namespace iv
