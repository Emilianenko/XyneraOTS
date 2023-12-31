// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "consolemanager.h"
#include "chat.h"

#include <boost/algorithm/string/replace.hpp>

extern Chat* g_chat;

namespace console {
void appendHistory(const std::string& message, ConsoleMessageType messageType, bool send) {
	for (uint8_t i = 0; i < CONSOLE_CACHE_SIZE -1; ++i) {
		consoleHistory[i] = consoleHistory[i+1];
	}
	consoleHistory[CONSOLE_CACHE_SIZE - 1] = std::make_pair(message, messageType);

#ifdef DEV_MODE
	if (send && g_chat) {
		if (ChatChannel* channel = g_chat->getChannelById(CHANNEL_CONSOLE)) {
			MessageClasses channelColor = MESSAGE_PARTY; // white
			switch (messageType) {
				case CONSOLEMESSAGE_TYPE_STARTUP:
				case CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL:
					channelColor = MESSAGE_CHANNEL_MANAGEMENT; // green
					break;
				case CONSOLEMESSAGE_TYPE_WARNING:
					channelColor = TALKTYPE_CHANNEL_Y; // yellow
					break;
				case CONSOLEMESSAGE_TYPE_ERROR:
				case CONSOLEMESSAGE_TYPE_BROADCAST:
					channelColor = TALKTYPE_CHANNEL_R1; // red
					break;
				//case CONSOLEMESSAGE_TYPE_INFO:
				default:
					break;
			}
			channel->sendChannelSystemMessage(message, channelColor);
		}
	}
#endif
}

#ifdef SHOW_CONSOLE_TIMESTAMPS
std::string currentConsoleStamp() {
	std::time_t t = std::time(nullptr);
	std::tm* now = std::localtime(&t);

	char buffer[128];
	strftime(buffer, sizeof(buffer), "%d/%m/%Y %X", now);
	return buffer;
}
#endif

void print(ConsoleMessageType messageType, const std::string& message, bool newLine, const std::string& location)
{
	std::string prefix;
	std::ostringstream msgToCache;

	Color color;

	switch (messageType) {
		case CONSOLEMESSAGE_TYPE_ERROR:
			prefix = "Error";
			color = error;
			break;
		case CONSOLEMESSAGE_TYPE_WARNING:
			prefix = "Warning";
			color = warning;
			break;
		case CONSOLEMESSAGE_TYPE_STARTUP:
		case CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL:
			prefix = "Start";
			color = start;
			break;
		case CONSOLEMESSAGE_TYPE_BROADCAST:
			prefix = "Broadcast";
			color = broadcast;
			break;
		case CONSOLEMESSAGE_TYPE_INFO:
		default:
			prefix = "Info";
			color = info;
			break;
	}

#ifdef SHOW_CONSOLE_TIMESTAMPS
	std::string timePrefix = currentConsoleStamp();
	msgToCache << fmt::format("[{:s}] ", timePrefix);
#endif

#ifdef SHOW_CONSOLE_PREFIXES
	msgToCache << "[" << (!location.empty() ? fmt::format("{:s} - {:s}", prefix, location) : prefix) << "]: " << message;
#else
	if (!location.empty()) {
		msgToCache << "[" << fmt::format("{:s} - {:s}", prefix, location) << "]: ";
	}

	msgToCache << message;
#endif

	size_t realMsgLength = prefix.size() + message.size() + location.size();

	if (!location.empty()) {
		prefix = fmt::format("{:s} - {:s}", prefix, location);
		realMsgLength += 3;

#ifndef SHOW_CONSOLE_PREFIXES
		// override prefix preference for error messages
		prefix = fmt::format("[{:s}]: ", setColor(color, prefix));
	} else {
		realMsgLength -= prefix.size();
		prefix = "";
#endif
	}

#ifdef SHOW_CONSOLE_PREFIXES
	prefix = fmt::format("[{:s}]: ", setColor(color, prefix));
#endif

#ifdef SHOW_CONSOLE_TIMESTAMPS
	realMsgLength += (timePrefix.size() + 3);
	timePrefix = setColor(color, timePrefix);
	prefix = fmt::format("[{:s}] {:s}", timePrefix, prefix);
#endif

	if (messageType == CONSOLEMESSAGE_TYPE_STARTUP_SPECIAL) {
		color = serveronline;
	}

	std::string outputMessage = prefix;
	if (messageType == CONSOLEMESSAGE_TYPE_STARTUP) {
		outputMessage += message;
	} else {
		outputMessage += setColor(color, message);
	}

	size_t formattedMsgLength = outputMessage.size();

	std::ostringstream outStr;
	if (!newLine) {
		outStr << std::setw(58 + formattedMsgLength - realMsgLength) << std::left;
	}

	outStr << outputMessage;

	if (newLine) {
		outStr << std::endl;
	} else {
		outStr << std::flush;
	}

	appendHistory(msgToCache.str(), messageType);
	std::cout << outStr.str() << std::flush;
}

// pattern for functions below
const std::string pattern = fmt::format("{{:^{:d}}}", TAG_WIDTH);

void printResult(ConsoleLoadingResult result)
{
	Color color;
	std::string msg;

	switch (result) {
		case CONSOLE_LOADING_OK:
			color = loading_ok;
			msg = "OK";
			break;
		case CONSOLE_LOADING_PENDING:
			color = loading_pending;
			msg = "";
			break;
			/*
			case CONSOLE_LOADING_WARNING:
				color = Color::yellow;
				msg = "WARNING";
				break;
			*/
		case CONSOLE_LOADING_ERROR:
		default:
			color = loading_error;
			msg = "ERROR";
			break;
	}

	fmt::print("[{:s}]\n", setColor(color, fmt::format(pattern, msg)));
}

void printResultText(const std::string& msg, Color color)
{
	fmt::print("[{:s}]\n", setColor(color, fmt::format(pattern, msg)));
}

void printPVPType(const std::string& worldType)
{
	Color color = pvp;
	if (worldType == "no-pvp"){
		color = noPvp;
	} else if (worldType == "pvp-enforced") {
		color = pvpEnfo;
	}

	printResultText(asUpperCaseString(worldType), color);
}

void printLoginPorts(uint16_t loginPort, uint16_t gamePort, uint16_t statusPort)
{
#ifdef SHOW_CONSOLE_TIMESTAMPS
	std::string spacing = "  ";
#else
	std::string spacing = "        ";
#endif

	print(
		CONSOLEMESSAGE_TYPE_STARTUP,
		fmt::format(
			"Login port: {:s}{:s}Game port: {:s}{:s}Status port: {:s}",
			setColor(serverPorts, std::to_string(loginPort)), spacing,
			setColor(serverPorts, std::to_string(gamePort)), spacing,
			setColor(serverPorts, std::to_string(statusPort))
		)
	);
}

void printWorldInfo(const std::string& key, const std::string& value, bool isStartup, size_t width)
{
	std::ostringstream worldInfo;
	worldInfo << std::setw(width) << std::left << fmt::format(">> {:s}:", key) << setColor(mapStats, value);
	print(isStartup ? CONSOLEMESSAGE_TYPE_STARTUP : CONSOLEMESSAGE_TYPE_INFO, worldInfo.str());
}

void callOverflow(const std::string location)
{
	print(CONSOLEMESSAGE_TYPE_ERROR, "Call stack overflow!", true, location);
}

void reportError(const std::string location, const std::string text)
{
	print(CONSOLEMESSAGE_TYPE_ERROR, text, true, location);
}

void reportWarning(const std::string location, const std::string text)
{
	print(CONSOLEMESSAGE_TYPE_WARNING, text, true, location);
}

void reportFileError(const std::string location, const std::string fileName, const std::string text)
{
	console::reportError(location, fmt::format("Unable to load {:s}!", fileName));
	if (text.size() > 0) {
		console::reportError(location, text);
	}
}

std::string getColumns(const std::string& leftColumn, const std::string& rightColumn, size_t width)
{
	std::ostringstream response;
	response << leftColumn;

	// align if left column is shorter than limit
	if (leftColumn.size() < width) {
		response << std::setw(width - leftColumn.size()) << std::right;
	}

	response << rightColumn;
	return response.str();
}

#ifdef USE_COLOR_CONSOLE
std::string setColor(Color color, const std::string& text)
{
	std::string newText = text;
	boost::replace_all(newText, "{", "{{");
	boost::replace_all(newText, "}", "}}");
	return fmt::format(fg(color), newText);
}
#else
std::string setColor(Color, const std::string& text) { return text; }
#endif

const std::string& getLastMessage()
{
	return consoleHistory[CONSOLE_CACHE_SIZE-1].first;
}

console::Cache getHistory()
{
	return consoleHistory;
}

} // namespace console
