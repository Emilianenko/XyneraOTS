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

#include "otpch.h"

#include "familiars.h"
#include "vocation.h"
#include "pugicast.h"
#include "tools.h"

extern Vocations g_vocations;

bool Familiars::reload()
{
	familiars.clear();
	return loadFromXml();
}

bool Familiars::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/familiars.xml");
	if (!result) {
		console::printResult(CONSOLE_LOADING_ERROR);
		printXMLError("Familiars::loadFromXml", "data/XML/familiars.xml", result);
		return false;
	}

	std::deque<std::string> warnings;

	for (auto familiarNode : doc.child("familiars").children()) {
		if (!(familiarNode.attribute("id"))) {
			warnings.push_back("Missing familiar id!");
			continue;
		}

		uint16_t nodeId = pugi::cast<uint16_t>(familiarNode.attribute("id").value());
		if (nodeId == 0 || nodeId > std::numeric_limits<uint8_t>::max()) {
			warnings.push_back(fmt::format("Familiar id \"{:d}\" is not within 1 and 255 range!", nodeId));
			continue;
		}

		if (getFamiliarByID(nodeId)) {
			warnings.push_back(fmt::format("Duplicate familiar with id \"{:d}\"!", nodeId));
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = familiarNode.attribute("clientid");
		if (!lookTypeAttribute) {
			warnings.push_back(fmt::format("Missing cliendid for familiar id {:d}!", nodeId));
			continue;
		}

		Familiar familiar = Familiar(
			static_cast<uint8_t>(nodeId),
			pugi::cast<uint16_t>(familiarNode.attribute("clientid").value()),
			familiarNode.attribute("name").as_string(),
			familiarNode.attribute("premium").as_bool(),
			familiarNode.attribute("unlocked").as_bool()
		);

		pugi::xml_attribute attr;
		for (auto vocationNode : familiarNode.children()) {
			if (!(attr = vocationNode.attribute("name"))) {
				continue;
			}

			int32_t vocationId = g_vocations.getVocationId(attr.as_string());
			if (vocationId != -1) {
				familiar.vocations.push_back(vocationId);
			} else {
				warnings.push_back(fmt::format("Vocation name \"{:s}\" does not exist! Familiar id: {:d}", attr.as_string(), nodeId));
			}
		}

		familiars.emplace_back(familiar);
	}

	familiars.shrink_to_fit();

	// show how many loaded
	console::printResultText(console::getColumns("Familiars:", std::to_string(familiars.size())));

	// show warnings
	if (!warnings.empty()) {
		for (int warningId = 0; warningId < warnings.size(); ++warningId) {
			console::reportWarning("Familiars::loadFromXml", warnings[warningId]);
		}
	}
	return true;
}

Familiar* Familiars::getFamiliarByID(uint8_t id)
{
	auto it = std::find_if(familiars.begin(), familiars.end(), [id](const Familiar& familiar) {
		return familiar.id == id;
	});

	return it != familiars.end() ? &*it : nullptr;
}

Familiar* Familiars::getFamiliarByName(const std::string& name)
{
	auto familiarName = name.c_str();
	for (auto& it : familiars) {
		if (strcasecmp(familiarName, it.name.c_str()) == 0) {
			return &it;
		}
	}

	return nullptr;
}

Familiar* Familiars::getFamiliarByClientID(uint16_t clientId)
{
	auto it = std::find_if(familiars.begin(), familiars.end(), [clientId](const Familiar& familiar) {
		return familiar.clientId == clientId;
	});

	return it != familiars.end() ? &*it : nullptr;
}
