/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *    andLinux                                                                 *
 *    Copyright (C) 2008 by David Solomon and Joachim Gehweiler                *
 *                                                                             *
 *    This program is free software: you can redistribute it and/or modify     *
 *    it under the terms of the GNU General Public License as published by     *
 *    the Free Software Foundation, either version 3 of the License, or        *
 *    (at your option) any later version.                                      *
 *                                                                             *
 *    This program is distributed in the hope that it will be useful,          *
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of           *
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            *
 *    GNU General Public License for more details.                             *
 *                                                                             *
 *    You should have received a copy of the GNU General Public License        *
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.    *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#define _WIN32_IE 0x0600 // für Ballon Tips

#include <stdio.h>
#include <string.h>

#include <windows.h>
#include <windowsx.h>
#include <shellapi.h> // muß *NACH* windows eingebunden werden - sonst Kompilierfehler

#include <winsock2.h>
#include <commctrl.h>

#include <string>

#include "menu.h"


#define UWM_SYSTRAY (WM_USER + 1) // Sent to us by the systray


typedef struct BITMAP_MENU_ITEM
{
	char command[512];
	char name[32];
	int iconIndex;
} BITMAP_MENU_ITEM;


LRESULT CALLBACK wndProc(HWND, UINT, WPARAM, LPARAM);
void sockCleanup(SOCKET);
int launch(char*);


HWND g_hwnd;
HMENU g_hMenu;
HIMAGELIST g_hIcons;
BITMAP_MENU_ITEM *g_menuItems;
int g_nMenuItems;
char g_andLinuxIP[20];
int g_andLinuxPort;


int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpszCmdLine, int nCmdShow)
{
	char buffer[1024], *pos1, *pos2, *classname = STR_PROG_NAME;
	int i, tmp;
	HWND hwnd;
	WNDCLASSEX wc;
	MSG msg;
	NOTIFYICONDATA nid;
	HICON icon;
	FILE *f;
	DWORD dwSize, dwType;
	HKEY hKey;

	// set working directory to installation directory (to support relative icon file names in menu.txt)
	GetModuleFileName(NULL, buffer, 1024);
	if((pos1 = strrchr(buffer, '\\')) == NULL)
	{
		MessageBox(NULL, STR_ERROR_SETCWD, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}
	pos1[1] = '\0';
	if(!SetCurrentDirectory(buffer))
	{
		MessageBox(NULL, STR_ERROR_SETCWD, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}

	if(RegOpenKeyEx(HKEY_LOCAL_MACHINE, "SOFTWARE\\andLinux\\Launcher", 0, KEY_READ, &hKey) == ERROR_SUCCESS)
	{
		dwSize = sizeof(buffer);
		if(RegQueryValueEx(hKey, "IP", NULL, &dwType, (LPBYTE)buffer, &dwSize) == ERROR_SUCCESS && dwType == REG_SZ && dwSize < 20)
		{
			buffer[dwSize] = '\0'; // not automatically appended by RegQueryValueEx if missing
			strcpy(g_andLinuxIP, buffer);
		}
		else
			strcpy(g_andLinuxIP, "192.168.11.150");

		dwSize = sizeof(int);
		if(RegQueryValueEx(hKey, "Port", NULL, &dwType, (LPBYTE)&tmp, &dwSize) == ERROR_SUCCESS && dwType == REG_DWORD)
			g_andLinuxPort = tmp;
		else
			g_andLinuxPort = 2081;

		RegCloseKey(hKey);
	}
	else
	{
		strcpy(g_andLinuxIP, "192.168.11.150");
		g_andLinuxPort = 2081;
	}

	// ensure that the common control DLL is loaded
	InitCommonControls();

	// build menu
	if((g_hMenu = CreatePopupMenu()) == NULL)
	{
		MessageBox(NULL, STR_ERROR_CREATE_MENU, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}

	if((f = fopen("menu.txt", "r")) == NULL)
	{
		MessageBox(NULL, STR_ERROR_READ_MENU, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}
	g_nMenuItems = 1; // for Exit item
	while(fgets(buffer, 1024, f) != NULL)
		g_nMenuItems += 1;

	if((g_hIcons = ImageList_Create(GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), ILC_COLOR32 | ILC_MASK, g_nMenuItems, 0)) == NULL)
	{
		fclose(f);
		MessageBox(NULL, STR_ERROR_CREATE_ICONS, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}

	if((g_menuItems = (BITMAP_MENU_ITEM*)malloc(g_nMenuItems * sizeof(BITMAP_MENU_ITEM))) == NULL)
	{
		fclose(f);
		MessageBox(NULL, STR_ERROR_NO_MEMORY, STR_PROG_NAME, MB_ICONERROR | MB_TASKMODAL | MB_TOPMOST);
		exit(1);
	}

	rewind(f);
	for(i=0; i<g_nMenuItems-1; i++)
	{
		fgets(buffer, 1024, f);
		if((pos1 = strchr(buffer, ';')) != NULL && (pos2 = strchr(pos1+1, ';')) != NULL)
		{
			*pos1 = '\0';
			pos1++;
			*pos2 = '\0';
			pos2++;
			if(pos2[strlen(pos2)-1] == '\n') // \r automatically removed when file open in text mode ("translated mode")
				pos2[strlen(pos2)-1] = '\0';

			strncpy(g_menuItems[i].name, buffer, 32);
			g_menuItems[i].name[31] = '\0';
	
			icon = LoadImage(NULL, pos1, IMAGE_ICON, GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), LR_LOADFROMFILE);
			if(icon != NULL)
				g_menuItems[i].iconIndex = ImageList_AddIcon(g_hIcons, icon);
			else
				g_menuItems[i].iconIndex = -1;
	
			strncpy(g_menuItems[i].command, pos2, 512);
			g_menuItems[i].command[511] = '\0';
	
			AppendMenu(g_hMenu, MF_OWNERDRAW, 100+i, (LPCTSTR)&g_menuItems[i]);
		}
		else
			AppendMenu(g_hMenu, MF_SEPARATOR, NULL, NULL);
	}
	fclose(f);

	AppendMenu(g_hMenu, MF_SEPARATOR, NULL, NULL);

	strcpy(g_menuItems[g_nMenuItems-1].name, "Exit");
	g_menuItems[g_nMenuItems-1].iconIndex = -1;
	AppendMenu(g_hMenu, MF_OWNERDRAW, 100+g_nMenuItems-1, (LPCTSTR)&g_menuItems[g_nMenuItems-1]);

	wc.cbSize = sizeof(WNDCLASSEX);
	wc.style = 0;
	wc.lpfnWndProc = wndProc;
	wc.cbClsExtra = wc.cbWndExtra = 0;
	wc.hInstance = hInstance;
	wc.hIcon = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_MAIN));
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = classname;
	wc.hIconSm = LoadImage(hInstance, MAKEINTRESOURCE(IDI_MAIN), IMAGE_ICON, GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), 0);
	RegisterClassEx(&wc);

	// Create window. Note that WS_VISIBLE is not used, and window is never shown
	g_hwnd = CreateWindowEx(0, classname, classname, WS_POPUP, CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

	nid.cbSize = sizeof(NOTIFYICONDATA);
	nid.hWnd = g_hwnd; // window to receive notifications
	nid.uID = 1;     // application-defined ID for icon (can be any UINT value)
	nid.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
	nid.uCallbackMessage = UWM_SYSTRAY;
	nid.hIcon = LoadImage(hInstance, MAKEINTRESOURCE(IDI_MAIN), IMAGE_ICON, GetSystemMetrics(SM_CXSMICON), GetSystemMetrics(SM_CYSMICON), 0);
	// szTip is the ToolTip text (64 byte array including NULL)
	strncpy(nid.szTip, STR_PROG_NAME, 64);
	// NIM_ADD: Add icon; NIM_DELETE: Remove icon; NIM_MODIFY: modify icon
	Shell_NotifyIcon(NIM_ADD, &nid);

	while(GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return msg.wParam;
}

LRESULT CALLBACK wndProc(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int res, sel, x, y;
	POINT pt;
	NOTIFYICONDATA nid;
	LPMEASUREITEMSTRUCT lpmis;
	LPDRAWITEMSTRUCT lpdis;
	BITMAP_MENU_ITEM *item;
	HDC hdc;
	SIZE size;
	COLORREF clrPrevText, clrPrevBkgnd;

	switch(message)
	{
	case WM_DESTROY:
		DestroyMenu(g_hMenu);
		ImageList_Destroy(g_hIcons);
		free(g_menuItems);
		nid.cbSize = sizeof(NOTIFYICONDATA);
		nid.hWnd = hwnd;
		nid.uID = 1;
		nid.uFlags = 0;
		Shell_NotifyIcon(NIM_DELETE, &nid);
		PostQuitMessage(0);
		return TRUE;

	case WM_MEASUREITEM:
		lpmis = (LPMEASUREITEMSTRUCT)lParam;
		item = (BITMAP_MENU_ITEM*)lpmis->itemData;
		hdc = GetDC(hwnd);
		GetTextExtentPoint32(hdc, item->name, strlen(item->name), &size);
		lpmis->itemWidth = size.cx;
		if(item->iconIndex == -1)
			lpmis->itemHeight = size.cy;
		else
			lpmis->itemHeight = GetSystemMetrics(SM_CYSMICON) + 4;
		ReleaseDC(hwnd, hdc);
		return TRUE;

        case WM_DRAWITEM:
		lpdis = (LPDRAWITEMSTRUCT)lParam;
		item = (BITMAP_MENU_ITEM*)lpdis->itemData;
		// set the appropriate foreground and background colors
		if(lpdis->itemState & ODS_SELECTED)
		{
			clrPrevText = SetTextColor(lpdis->hDC, GetSysColor(COLOR_HIGHLIGHTTEXT));
			clrPrevBkgnd = SetBkColor(lpdis->hDC, GetSysColor(COLOR_HIGHLIGHT));
		}
		else
		{
			clrPrevText = SetTextColor(lpdis->hDC, GetSysColor(COLOR_MENUTEXT));
			clrPrevBkgnd = SetBkColor(lpdis->hDC, GetSysColor(COLOR_MENU));
		}
		// determine position and draw bitmap and text
		x = lpdis->rcItem.left + 2;
		y = lpdis->rcItem.top + 2;
		if(item->iconIndex != -1)
		{
			ExtTextOut(lpdis->hDC, x+GetSystemMetrics(SM_CXSMICON)+4, y+1, ETO_OPAQUE, &lpdis->rcItem, item->name, strlen(item->name), NULL);
			ImageList_Draw(g_hIcons, item->iconIndex, lpdis->hDC, x, y, ILD_NORMAL);
		}
		else
			ExtTextOut(lpdis->hDC, x+GetSystemMetrics(SM_CXSMICON)+4, y-1, ETO_OPAQUE, &lpdis->rcItem, item->name, strlen(item->name), NULL);
		// restore the original colors
		SetTextColor(lpdis->hDC, clrPrevText);
		SetBkColor(lpdis->hDC, clrPrevBkgnd);
		return TRUE;

 	case UWM_SYSTRAY: // We are being notified of mouse activity over the icon
		switch (lParam)
		{
		case WM_LBUTTONUP:
		case WM_RBUTTONUP:
			GetCursorPos(&pt);

			/* SetForegroundWindow and the ensuing null PostMessage is a
			workaround for a Windows 95 bug (see MSKB article Q135788,
			http://support.microsoft.com/default.aspx?scid=kb;en-us;135788). */
			SetForegroundWindow(hwnd);

			/* We specifiy TPM_RETURNCMD, so TrackPopupMenu returns the menu
			selection instead of returning immediately and our getting a
			WM_COMMAND with the selection. */
			sel = TrackPopupMenu(g_hMenu, TPM_RETURNCMD | TPM_RIGHTBUTTON, pt.x, pt.y, 0, hwnd, NULL);
			if(sel >= 100 && sel < 100+g_nMenuItems-1)
			{
				res = launch(g_menuItems[sel-100].command);
				if(res != 0)
				{
					// Show ToolTip
					nid.cbSize = sizeof(NOTIFYICONDATA);
					nid.hWnd = hwnd;
					nid.uID = 1;
					nid.uFlags = NIF_INFO;
					if(res == 7)
						snprintf(nid.szInfo, 256, "%s%s%s%s:%d", STR_ERROR_LAUNCH_PART1, g_menuItems[sel-100].name, STR_ERROR_LAUNCH_PART2b, g_andLinuxIP, g_andLinuxPort);
					else
						snprintf(nid.szInfo, 256, "%s%s%s%d", STR_ERROR_LAUNCH_PART1, g_menuItems[sel-100].name, STR_ERROR_LAUNCH_PART2a, res);
					strncpy(nid.szInfoTitle, STR_ERROR_HEADER, 64);
					nid.dwInfoFlags = NIIF_ERROR;
					nid.u.uTimeout = 10000;
					Shell_NotifyIcon(NIM_MODIFY, &nid);
				}
			}
			else if(sel == 100+g_nMenuItems-1)
				DestroyWindow(hwnd);

			PostMessage(hwnd, WM_NULL, 0, 0); // see above
			break;
		}
		return TRUE;
	}

	return DefWindowProc(hwnd, message, wParam, lParam);
}

void sockCleanup(SOCKET sock)
{
	if(sock != INVALID_SOCKET)
		closesocket(sock);
	
	WSACleanup();
}

int launch(char *cmd)
{
	char buffer[1024], request[1024], response[256];
	int bytesRead, offset, retVal, timeOut;
	struct sockaddr_in dst;
	SOCKET sock;
	WSADATA wsaData;

	// Initialize WinSock 2.0
	retVal = WSAStartup(MAKEWORD(2, 0), &wsaData);
	if(retVal != 0)
		return 1;
	if(LOBYTE(wsaData.wVersion) != 2)
		return 2;
	if(HIBYTE(wsaData.wVersion) != 0)
		return 3;

	// Set up destination address
	dst.sin_family = AF_INET;
	dst.sin_addr.s_addr = inet_addr(g_andLinuxIP);
	dst.sin_port = htons(g_andLinuxPort);

	// Set up socket
	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if(sock == INVALID_SOCKET)
	{
		sockCleanup(sock);
		return 4;
	}

	// Set socket options
	timeOut = 10000; // 130s
	retVal = setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeOut, sizeof(int));
	if(retVal != 0)
	{
		sockCleanup(sock);
		return 5;
	}

	timeOut = 10000; // 10s
	retVal = setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, (char*)&timeOut, sizeof(int));
	if(retVal != 0)
	{
		sockCleanup(sock);
		return 6;
	}

	// Connect the socket
	retVal = connect(sock, (struct sockaddr*)&dst, sizeof(struct sockaddr_in));
	if(retVal != 0)
	{
		sockCleanup(sock);
		return 7;
	}

	// Send request
	snprintf(request, 1024, "cmd=%s&file=\n", cmd);
	retVal = send(sock, request, strlen(request), 0);
	if(retVal < 0 || (unsigned int)retVal != strlen(request))
	{
		sockCleanup(sock);
		return 8;
	}
	
	// Receive response
	offset = 0;
	memset(response, 0, 256);
	do
	{
		bytesRead = recv(sock, buffer, 1024, 0);
		if(bytesRead < 0) // 0 if connection gracefully closed
		{
			sockCleanup(sock);
			return 9;
		}

		if(offset < 256)
		{
			if(256 - offset < bytesRead)
			{
				memcpy(response+offset, buffer, 256-offset);
				offset = 256;
			}
			else
			{
				memcpy(response+offset, buffer, bytesRead);
				offset += bytesRead;
			}
		}
	} while(bytesRead > 0); // leaves the loop when connection gracefully closed
	response[(offset >= 256 ? 255 : offset)] = '\0';

	if(strncmp(response, "ok", 2) != 0)
	{
		sockCleanup(sock);
		return 10;
	}

	sockCleanup(sock);
	return 0;
}
