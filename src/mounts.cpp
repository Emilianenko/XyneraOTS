// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "mounts.h"

#include "definitions.h"
#include "pugicast.h"
#include "tools.h"

bool Mounts::reload()
{
	console::print(CONSOLEMESSAGE_TYPE_INFO, "Reloading mounts ... ", false);
	mounts.clear();
	return loadFromXml();
}

bool Mounts::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/mounts.xml");
	if (!result) {
		console::printResult(CONSOLE_LOADING_ERROR);
		printXMLError("Mounts::loadFromXml", "data/XML/mounts.xml", result);
		return false;
	}

	std::deque<std::string> warnings;

	for (auto mountNode : doc.child("mounts").children()) {
		if (!(mountNode.attribute("id"))) {
			warnings.push_back("Missing mount id!");
			continue;
		}

		uint16_t nodeId = pugi::cast<uint16_t>(mountNode.attribute("id").value());
		if (nodeId == 0 || nodeId > std::numeric_limits<uint8_t>::max()) {
			warnings.push_back(fmt::format("Mount id \"{:d}\" is not within 1 and 255 range!", nodeId));
			continue;
		}

		if (getMountByID(nodeId)) {
			warnings.push_back(fmt::format("Duplicate mount with id \"{:d}\"!", nodeId));
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = mountNode.attribute("clientid");
		if (!lookTypeAttribute) {
			warnings.push_back(fmt::format("Missing cliendid for mount id {:d}!", nodeId));
			continue;
		}

		mounts.emplace_back(
			static_cast<uint8_t>(nodeId),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			mountNode.attribute("name").as_string(),
			pugi::cast<int32_t>(mountNode.attribute("speed").value()),
			mountNode.attribute("premium").as_bool()
		);
	}
	mounts.shrink_to_fit();

	// show how many loaded
	console::printResultText(console::getColumns("Mounts:", std::to_string(mounts.size())));

	// show warnings
	if (!warnings.empty()) {
		for (int warningId = 0; warningId < warnings.size(); ++warningId) {
			console::reportWarning("Mounts::loadFromXml", warnings[warningId]);
		}
	}

	return true;
}

Mount* Mounts::getMountByID(uint8_t id)
{
	auto it = std::find_if(mounts.begin(), mounts.end(), [id](const Mount& mount) {
		return mount.id == id;
	});

	return it != mounts.end() ? &*it : nullptr;
}

Mount* Mounts::getMountByName(const std::string& name) {
	auto mountName = name.c_str();
	for (auto& it : mounts) {
		if (caseInsensitiveEqual(mountName, it.name)) {
			return &it;
		}
	}

	return nullptr;
}

Mount* Mounts::getMountByClientID(uint16_t clientId)
{
	auto it = std::find_if(mounts.begin(), mounts.end(), [clientId](const Mount& mount) {
		return mount.clientId == clientId;
	});

	return it != mounts.end() ? &*it : nullptr;
}
