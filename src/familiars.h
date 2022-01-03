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

#ifndef FS_FAMILIARS_H_C00089BD41B5F10BED759BFF7590782C
#define FS_FAMILIARS_H_C00089BD41B5F10BED759BFF7590782C

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
