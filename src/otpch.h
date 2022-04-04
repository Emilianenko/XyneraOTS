// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_OTPCH_H
#define FS_OTPCH_H

// Definitions should be global.
#include "definitions.h"

// Includes
#include <algorithm>
#include <array>
#include <atomic>
#include <bitset>
#include <boost/asio.hpp>
#include <boost/iostreams/device/mapped_file.hpp>
#include <boost/lockfree/stack.hpp>
#include <boost/variant.hpp>
#include <cassert>
#include <cmath>
#include <condition_variable>
#include <cstdint>
#include <cstdlib>
#include <deque>
#include <fmt/color.h>
#include <forward_list>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <list>
#include <map>
#include <memory>
#include <mutex>
#include <mysql/mysql.h>
#include <pugixml.hpp>
#include <random>
#include <set>
#include <sstream>
#include <string>
#include <string_view>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <valarray>
#include <variant>
#include <vector>


// Lua lib
#if __has_include("luajit/lua.hpp")
#include <luajit/lua.hpp>
#else
#include <lua.hpp>
#endif

// Console handler
#include "consolemanager.h"

#endif // FS_OTPCH_H
