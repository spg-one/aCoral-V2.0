/*
	Copyright (C) 2004-2005 Li Yudong
*/
/*
** This program is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** (at your option) any later version.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with this program; if not, write to the Free Software
** Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

#ifndef _INVAREA_H_
#define _INVAREA_H_
#include<resource.h>

#ifdef __cplusplus                     
extern "C" {
#endif

typedef struct _InvalidRect
{
	BOOL bErase;
	RECT rect;
	struct _InvalidRect* pNext;
} InvalidRect;
typedef InvalidRect* PInvalidRect;

typedef struct _InvalidRegion
{
	RECT rcBound;
	PInvalidRect pHead;
	PInvalidRect pTail;
	PPrivateHeap pHeap;
} InvalidRegion;
typedef InvalidRegion* PInvalidRegion;


BOOL 
InitInvalidRegionHeap();

void 
DestroyInvalidRegionHeap();


BOOL 
InitInvalidRegion(
	PInvalidRegion pInvalidRegion
);

BOOL
IsEmptyInvalidRegion(
	PInvalidRegion pInvalidRegion
);

BOOL
GetBoundInvalidRegion(
	PInvalidRegion pInvalidRegion
);

BOOL 
EmptyInvalidRegion(
	PInvalidRegion pInvalidRegion
);

BOOL
AddRectInvalidRegion(
	PInvalidRegion pInvalidRegion,
	const PRECT prc,
	BOOL bErase
);


#ifdef __cplusplus
}
#endif 

#endif
