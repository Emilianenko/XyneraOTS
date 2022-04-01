// Copyright 2022 The Forgotten Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_FAMILIARS_H
#define FS_FAMILIARS_H

struct Familiar
{
		Familiar(uint8_t id, uint16_t clientId, std::string name, bool premium, bool unlocked) :
			id(id), clientId(clientId), name(std::move(name)), premium(premium), unlocked(unlocked) {}

		std::string name;
		uint8_t id;
		uint16_t clientId;
		bool premium;
		bool unlocked;
		std::vector<uint16_t> vocations;
};

class Familiars
{
	public:
		bool reload();
		bool loadFromXml();
		Familiar* getFamiliarByID(uint8_t id);
		Familiar* getFamiliarByName(const std::string& name);
		Familiar* getFamiliarByClientID(uint16_t clientId);

		const std::vector<Familiar>& getFamiliars() const {
			return familiars;
		}

	private:
		std::vector<Familiar> familiars;
};

#endif
