// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "outfit.h"

#include "pugicast.h"
#include "tools.h"

bool Outfits::loadFromXml()
{
	pugi::xml_document doc;
	pugi::xml_parse_result result = doc.load_file("data/XML/outfits.xml");
	if (!result) {
		console::printResult(CONSOLE_LOADING_ERROR);
		printXMLError("Outfits::loadFromXml", "data/XML/outfits.xml", result);
		return false;
	}

	std::deque<std::string> warnings;

	for (auto outfitNode : doc.child("outfits").children()) {
		pugi::xml_attribute attr;
		if ((attr = outfitNode.attribute("enabled")) && !attr.as_bool()) {
			continue;
		}

		if (!(attr = outfitNode.attribute("type"))) {
			warnings.push_back("Missing outfit type!");
			continue;
		}

		uint16_t type = pugi::cast<uint16_t>(attr.value());
		if (type > PLAYERSEX_LAST) {
			warnings.push_back(fmt::format("Invalid outfit type {:d}!", type));
			continue;
		}

		pugi::xml_attribute lookTypeAttribute = outfitNode.attribute("looktype");
		if (!lookTypeAttribute) {
			warnings.push_back("Missing looktype on outfit!");
			continue;
		}

		Outfit outfit = Outfit(
			outfitNode.attribute("name").as_string(),
			pugi::cast<uint16_t>(lookTypeAttribute.value()),
			outfitNode.attribute("premium").as_bool(),
			outfitNode.attribute("unlocked").as_bool(true)
		);

		if (attr = outfitNode.attribute("tooltip")) {
			uint8_t tooltipId = pugi::cast<uint8_t>(attr.value());
			outfit.tooltip = static_cast<OutfitTooltip_t>(tooltipId);
		} else {
			outfit.tooltip = OUTFIT_TOOLTIP_NONE;
		}

		outfits[type].emplace_back(outfit);
	}

	// show how many loaded
	uint16_t outfitCount = 0;
	for (std::vector<Outfit> outfitType : outfits) {
		outfitCount += outfitType.size();
	}
	console::printResultText(console::getColumns("Outfits:", std::to_string(outfitCount)));

	// show warnings
	if (!warnings.empty()) {
		for (int warningId = 0; warningId < warnings.size(); ++warningId) {
			console::reportWarning("Outfits::loadFromXml", warnings[warningId]);
		}
	}

	return true;
}

const Outfit* Outfits::getOutfitByLookType(PlayerSex_t sex, uint16_t lookType) const
{
	for (const Outfit& outfit : outfits[sex]) {
		if (outfit.lookType == lookType) {
			return &outfit;
		}
	}
	return nullptr;
}

const Outfit* Outfits::getOutfitByLookType(uint16_t lookType) const
{
	for (uint8_t sex = PLAYERSEX_FEMALE; sex <= PLAYERSEX_LAST; sex++) {
		for (const Outfit& outfit : outfits[sex]) {
			if (outfit.lookType == lookType) {
				return &outfit;
			}
		}
	}
	return nullptr;
}

bool Outfits::setOutfitOfferId(uint16_t lookType, uint32_t offerId)
{
	for (uint8_t sex = PLAYERSEX_FEMALE; sex <= PLAYERSEX_LAST; sex++) {
		for (Outfit& outfit : outfits[sex]) {
			if (outfit.lookType == lookType) {
				outfit.offerId = offerId;
				return true;
			}
		}
	}

	return false;
}
