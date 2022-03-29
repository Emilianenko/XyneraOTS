/**
 * The Forgotten Server - a free and open-source MMORPG server emulator
 * Copyright (C) 2019  Mark Samman <mark.samman@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#ifndef FS_CONSOLEMANAGER_H
#define FS_CONSOLEMANAGER_H

// comment this line if you wish to disable colors in console
#define USE_COLOR_CONSOLE

#include "enums.h"
#include "tools.h"

#include <fmt/color.h>
namespace console {

typedef fmt::color Color;

// stylesheet
static constexpr Color
	serveronline = Color::lime,
	serverPorts = Color::lime,
	error = Color::red,
	warning = Color::yellow,
	start = Color::green,
	info = Color::cornflower_blue,
	pvp = Color::yellow,
	pvpEnfo = Color::red,
	noPvp = Color::lime;

static constexpr size_t TAG_WIDTH = 12;
static constexpr size_t WORLDINFO_SPACING = 24;

// functions responsible for printing formatted messages in the console

//// startup messages
// output: [messageType - location]: message
void print(ConsoleMessageType messageType, const std::string& message, bool newLine = true, const std::string& location = std::string());

// output: [result]
void printResult(ConsoleLoadingResult result);

// output: [msg]
void printResultText(const std::string& msg, Color color = Color::lime);

// output: [PVP-TYPE]
void printPVPType(const std::string& worldType);

// output: "Login port: x, Game port: y, Status port: z"
void printLoginPorts(uint16_t loginPort, uint16_t gamePort, uint16_t statusPort);

// output: ">> key:     value"
void printWorldInfo(const std::string& key, const std::string& value, bool isStartup = true, size_t width = WORLDINFO_SPACING);

//// error reporting functions
// output: [Error - location] Call stack overflow!
void reportOverflow(const std::string location);

// output: [Error - location] text
void reportError(const std::string location, const std::string text);

// output: [Warning - location] text
void reportWarning(const std::string location, const std::string text);

// returns formatted string
// args: leftColumn, rightColumn, total width
std::string getColumns(const std::string& leftColumn, const std::string& rightColumn, size_t width = TAG_WIDTH);

// returns painted string
// args: text, color
std::string setColor(Color color, const std::string& text);

} // namespace console
#endif