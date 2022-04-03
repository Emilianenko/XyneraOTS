// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "baseevents.h"

#include "luascript.h"
#include "tools.h"

extern LuaEnvironment g_luaEnvironment;

bool BaseEvents::loadFromXml()
{
	std::string location = "BaseEvents::loadFromXml";

	if (loaded) {
		console::reportError(location, "Event already loaded!");
		return false;
	}

	std::string scriptsName = getScriptBaseName();
	std::string basePath = "data/" + scriptsName + "/";
	if (getScriptInterface().loadFile(basePath + "lib/" + scriptsName + ".lua") == -1) {
		console::reportFileError(location, fmt::format("Unable to load {:s}lib/{:s}.lua!", basePath, scriptsName));
	}

	std::string filename = basePath + scriptsName + ".xml";

	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file(filename.c_str());
	if (!result) {
		printXMLError(location, filename, result);
		return false;
	}

	loaded = true;

	for (auto node : doc.child(scriptsName.c_str()).children()) {
		Event_ptr event = getEvent(node.name());
		if (!event) {
			continue;
		}

		if (!event->configureEvent(node)) {
			console::reportWarning(location, "Failed to configure event!");
			continue;
		}

		bool success;

		pugi::xml_attribute scriptAttribute = node.attribute("script");
		if (scriptAttribute) {
			std::string scriptFile = "scripts/" + std::string(scriptAttribute.as_string());
			success = event->checkScript(basePath, scriptsName, scriptFile) && event->loadScript(basePath + scriptFile);
			if (node.attribute("function")) {
				event->loadFunction(node.attribute("function"), true);
			}
		} else {
			success = event->loadFunction(node.attribute("function"), false);
		}

		if (success) {
			registerEvent(std::move(event), node);
		}
	}
	return true;
}

bool BaseEvents::reload()
{
	loaded = false;
	clear(false);
	return loadFromXml();
}

void BaseEvents::reInitState(bool fromLua)
{
	if (!fromLua) {
		getScriptInterface().reInitState();
	}
}

Event::Event(LuaScriptInterface* interface) : scriptInterface(interface) {}

bool Event::checkScript(const std::string& basePath, const std::string& scriptsName, const std::string& scriptFile) const
{
	std::string location = "Event::checkScript";

	LuaScriptInterface* testInterface = g_luaEnvironment.getTestInterface();
	testInterface->reInitState();

	if (testInterface->loadFile(std::string(basePath + "lib/" + scriptsName + ".lua")) == -1) {
		console::reportFileError(location, basePath + "lib/" + scriptsName + ".lua");
	}

	if (scriptId != 0) {
		console::reportError(location, fmt::format("Failed to check script with id {:d}!", scriptId));
		return false;
	}

	if (testInterface->loadFile(basePath + scriptFile) == -1) {
		console::reportFileError(location, scriptFile, testInterface->getLastLuaError());
		return false;
	}

	int32_t id = testInterface->getEvent(getScriptEventName());
	if (id == -1) {
		console::reportWarning(location, fmt::format("Event {:s} not found! ({:s})", getScriptEventName(), scriptFile));
		return false;
	}
	return true;
}

bool Event::loadScript(const std::string& scriptFile)
{
	std::string location = "[Event::loadScript]";

	if (!scriptInterface || scriptId != 0) {
		console::reportError(location, fmt::format("scriptInterface == nullptr, scriptId = {:d}", scriptId));
		return false;
	}

	if (scriptInterface->loadFile(scriptFile) == -1) {
		console::reportFileError(location, scriptFile, scriptInterface->getLastLuaError());
		return false;
	}

	int32_t id = scriptInterface->getEvent(getScriptEventName());
	if (id == -1) {
		console::reportWarning(location, fmt::format("Event {:s} not found! ({:s})", getScriptEventName(), scriptFile));
		return false;
	}

	scripted = true;
	scriptId = id;
	return true;
}

bool Event::loadCallback()
{
	if (!scriptInterface || scriptId != 0) {
		console::reportError("[Event::loadCallback]", fmt::format("scriptInterface == nullptr, scriptId = {:d}", scriptId));
		return false;
	}

	int32_t id = scriptInterface->getEvent();
	if (id == -1) {
		console::reportWarning("[Event::loadCallback]", fmt::format("Event {:s} not found!", getScriptEventName()));
		return false;
	}

	scripted = true;
	scriptId = id;
	return true;
}

bool CallBack::loadCallBack(LuaScriptInterface* interface, const std::string& name)
{
	if (!interface) {
		console::reportError("[CallBack::loadCallBack]", fmt::format("scriptInterface == nullptr, scriptId = {:d}", scriptId));
		return false;
	}

	scriptInterface = interface;

	int32_t id = scriptInterface->getEvent(name.c_str());
	if (id == -1) {
		console::reportWarning("[CallBack::loadCallBack]", fmt::format("Event {:s} not found!", name));
		return false;
	}

	scriptId = id;
	loaded = true;
	return true;
}
