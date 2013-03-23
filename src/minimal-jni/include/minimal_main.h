/*
    SDL - Simple DirectMedia Layer
    Copyright (C) 1997-2009 Sam Lantinga

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    Sam Lantinga
    slouken@libsdl.org
*/

#ifndef _minimal_main_h
#define _minimal_main_h

#include "SDL_stdinc.h"

/** @file minimal_main.h
 *  *  Redefine main() on Win32 and MacOS so that it is called by winmain.c
 *   */

#if defined(__WIN32__) || \
	    (defined(__MWERKS__) && !defined(__BEOS__)) || \
    defined(__MACOS__) || defined(__MACOSX__) || \
    defined(__SYMBIAN32__) || defined(QWS) || defined(ANDROID)

/** The application's main() function must be called with C linkage,
 *  and should be declared like this:
 *      @code
 *      #ifdef __cplusplus
 *      extern "C"
 *      #endif
 *	int main(int argc, char *argv[])
 *	{
 *	}
 *      @endcode
 */
#define main	minimal_main

/** The prototype for the application's main() function */
extern C_LINKAGE int minimal_main(int argc, char *argv[]);

#endif /* Need to redefine main()? */

#endif /* _minimal_main_h */
