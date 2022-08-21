// Copyright 2022 Xynera.net. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "imbuing.h"

Imbuements::Imbuements(){}

ImbuementType* Imbuements::getImbuementType(uint8_t imbuId)
{
	if (imbuId == 0) {
		// id reserved for empty sockets
		return nullptr;
	}

	auto it = imbuementTypes.find(imbuId);
	if (it == imbuementTypes.end()) {
		// create new
		return &imbuementTypes[imbuId];
	}

	// return existing
	return &it->second;
}
